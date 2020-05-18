<# :: Batch to PowerShell pivot.
:: Starting as batch works around a restrictive execution policy until we have
:: admin privilege and can relax it.

:: Cmd.exe helpfully fails the first line silenty. In batch, '<' is "redirect
:: from file" and '#' is a non-null empty value. Once we get to PowerShell,
:: this prolog is a block comment and is ignored. If cmd.exe wasn't being
:: helpful, the initial '<#' could be injected in the powershell invocation
:: below with "('<#' + (gc -raw %~f0))".

:: Vim obviously thinks it's a batch file too. Set modeline and modelines=15 in
:: vim to make this work.
:: vim:syntax=ps1

:: Silently disable command echoing.
@echo off

:: Since PowerShell interprets *.bat files as batch, it would loop infinitely
:: if launched with this file. Force interpretation of the script as PowerShell
:: by getting the raw text from the file instead. After parsing the content,
:: run the launch function which should now be available. We need the filename
:: for further relaunches so pass it along to powershell, otherwise we would
:: have to extract it from $MyInvocation with hacky regexes. If batch arguments
:: are needed in powershell, append %* at the end of the line.
powershell -nop -ex bypass -c iex (gc -raw %~f0); Main %~f0

:: ^LEGEND:
:: -nop is "-NoProfile".
:: -ex is "-ExecutionPolicy".
:: -c is "-Command", any text after is sent as a single line to PowerShell.
:: iex is "Invoke-Execution".
:: gc is "Get-Content".
:: -raw gets the whole file as one string, instead of an array of lines.
:: %~f0 is the current full filename in batch.
:: Main is the name of the entry function in the powershell script below.

:: Exit when we return - don't send the rest of the script to 'cmd.exe'.
exit /B

:: End batch, begin powershell.
#>



<# ~~~ CTTSRK's WINDOWS 10 SETUP SCRIPT ~~~

This file is a hybrid batch/powershell/bash script that relaunches itself
multiple times to switch between scripting languages, acquire admin privileges,
persist over reboots, enable automated fullscreening, etc.

The script is idempotent (so far) and runs from the start on relaunch and
reboot.

This is a learning exercise. Tools already exist to do something like this, eg
Boxstarter, Chocolatey, Nuget, DISM, etc. YMMV.

ABOUT AUTOLOGON
Autologon on Windows 10 is a pita. The regular registry hack stores plaintext
passwords in registry. LSA autologon stores plaintext passwords in a hidden
part of the registry. ARSO is sparsely documented and uses LSA, but maybe not
as insecurely as LSA autologon? SecureString is deprecated and understood to be
nothing but security through a little bit of obscurity. Storing credentials for
scheduled tasks is done with the Windows Credential Manager through DPAPI and
again seems to rely only on obscurity and can be retrieved with the appropriate
tools. And you can't run a scheduled task behind the logon screen without
stored credentials. I would like to see only hashes that need bruteforcing to
ever retrieve the plaintext password. Is the only good way to roll your own
credential manager? One does not simply... write a credential manager in
PowerShell. Autologon feature abandoned.

TODO
base16-scripts
that one program for scrubbing conhost settings
conhost setup
pause windows update service and configuration manager
maybe figure out env path manipulation
chocolatey install?
.net check/install?
uninstall bloatware
developer-minded windows settings
font setup

INSPIRATION
stackoverflow.com/users/1683264/rojo
github.com/jayharris/dotfiles-windows

BITS AND PIECES FROM
github.com/chocolatey/boxstarter

LICENSE
Apache License 2.0

#>



function Main {

    # region sanityCheck

    $requireVer = '5'
    if ($PSVersionTable.PSVersion.Major -ge $requireVer) {
        PPrint "PowerShell version $($PSVersionTable.PSVersion)."
    }
    else {
        PPrint "PowerShell version $requireVer or later is required."
        return
    }

    # We should never hit this since the batch prolog sets the
    # ExecutionPolicy to Bypass for this script.
    Set-Alias -Name GeExPo -Value Get-ExecutionPolicy
    if (@("Restricted", "AllSigned") | Where {$_ -eq (GeExPo)}) {
        PPrint "Your Execution Policy is set to $(GeExPo)."
        PPrint "Change it to RemoteSigned or Unrestricted and retry."
        return
    }
    
    if ($args) {
        PPrint "Arguments: $($args -Join ' ')"
    }
    else {
        PPrint "Got no arguments, exiting. (Need at least a filename.)"
        return
    }
    
    # Actually just checking if it's -a- valid file.
    # TODO: How to check if it's -this- file?
    if (Test-Path $args[0]) {
        PPrint "Filename: $($args[0])"
    }
    else {
        PPrint "The first argument should be the path of this file."
        return
    }
    
    # endregion


    
    # region initialSetup
      
    # Make the arguments available script-wide. There's only the filename in
    # there for now.
    $script:args = $args

    # Pick your poison.
    $script:debian = 'Debian 9 Stable'
    $script:ubuntu = 'Ubuntu 18.04 LTS'
    $script:WSLDistro = $script:debian
    
    # Changing the path on Windows 10 is a fustercluck, just piggyback on
    # this directory that already exists in "$Env:PATH".
    # TODO Maybe do this properly?
    # Currently not needed.
    # $script:BIN = "$Env:LOCALAPPDATA\Microsoft\WindowsApps"

    # Pick a name for the resume after reboot task.
    $script:taskName = 'cttsrk_installer_temp_resume_task'
    
    # Pick an execution policy during script run.
    $script:relaxPolicy = 'Unrestricted'
    
    # Pick an execution policy to leave the system at after the script runs.
    $script:strictPolicy = 'RemoteSigned'
      
    # endregion



    # region MAIN ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    MigrateToTemp
    GetAdmin
    Banner "Welcome to Cttsrk's Windows 10 box setup script!"
    DeleteTempResumeTask
    RelaxExecutionPolicy
    InstallWSL
    DummyStage
    RestrictExecutionPolicy
    PivotToWSL
    # pause # DEBUG
        
    return
    
    # endregion
}



# region stageFunctions

function MigrateToTemp {
    # Copy this file to a local temp file and relaunch from it. This
    # protects against the file disappearing if run from inside a zip or
    # other archive or from a network drive. The file needs to stick around
    # for relaunches and reboots. (Do this before elevating to admin to
    # ensure it ends up in a user-writeable location - is this necessary on
    # Windows?)
    
    # Make sure we're not already running from a tempfile.
    if (!($script:args[0] -Like "*.tempMAGIC*.bat")) {

        # Build the name of the new file and create it.
        $fileName = Split-Path -Leaf $script:args[0]
        Set-Alias -Name gr -Value Get-Random
        $magic = ".tempMAGIC" + (gr -Min 1000000 -Max 9000000) + ".bat"
        $newFileFullname = (Join-Path $Env:TEMP $fileName) + $magic
        $newFile = New-Item -ItemType File $newFileFullname

        # Copy this file to the new file and update our path argument.
        Get-Content $script:args[0] | Set-Content $newFile
        $script:args[0] = $newFile

        PPrint "Relaunching from new temp file."
        PowerShell -NoProfile -ExecutionPolicy Unrestricted $script:args
    
        exit 0
    }
    else {
        return
    }
}

function GetAdmin {
    # Make sure the script is running with admin privileges.
    if(!(Test-Admin)) {
        PPrint "Not running as admin. Attempting to elevate..."
        # Can't combine "-NoNewWindow" with "-Verb" in Start-Process. =(
        $command = "/C $($script:args)"
        Start-Process "cmd.exe" -Verb RunAs -ArgumentList $command
        exit 0
    }
    else {
        return
    }
}

function RelaxExecutionPolicy {
    if ((Get-ExecutionPolicy | Out-String) -Match $script:relaxPolicy) {
        PPrint "ExecutionPolicy already set to $($script:relaxPolicy)."
    }
        else {
        PPrint "Setting ExecutionPolicy to $($script:relaxPolicy)." 
        # This order might prevent scope complaints.
        Set-Alias -Name SeExPo -Value Set-ExecutionPolicy
        SeExPo -Scope Process -ExecutionPolicy $script:relaxPolicy
        SeExPo -Scope CurrentUser -ExecutionPolicy Undefined
        SeExPo -Scope LocalMachine -ExecutionPolicy $script:relaxPolicy
        SeExPo -Scope Process -ExecutionPolicy Undefined
        # Get-ExecutionPolicy -list  | Out-Host # DEBUG
    }
    return
}

function RestrictExecutionPolicy {
    if ((Get-ExecutionPolicy | Out-String) -Match $script:strictPolicy) {
        PPrint "ExecutionPolicy already set to $($script:strictPolicy)."
    }
    else {
        PPrint "Setting ExecutionPolicy to $($script:strictPolicy)." 
        Set-Alias -Name SeExPo -Value Set-ExecutionPolicy
        SeExPo -Scope Process -ExecutionPolicy Undefined
        SeExPo -Scope CurrentUser -ExecutionPolicy Undefined
        SeExPo -Scope LocalMachine -ExecutionPolicy $script:strictPolicy
        # Get-ExecutionPolicy -list  | Out-Host # DEBUG
    }
    return
}

function InstallWSL {
    # Chocolatey and Boxstarter fail to do this on my boxes without erroring
    # out a couple of times. Roll my own solution and make it smooth.

    if ($script:WSLDistro -Match $script:debian) {
        # Debian 9 Stable
        $distroUrl = "https://aka.ms/wsl-debian-gnulinux"
        $appxName = "TheDebianProject.DebianGNULinux"
        $installerName = "debian.exe"
        $exeName = "bash.exe"
    }
    elseif ($script:WSLDistro -Match $script:ubuntu) {
        # Ubuntu 18.04 LTS
        $distroUrl = "https://aka.ms/wsl-ubuntu-1804"
        $appxName = "CanonicalGroupLimited.Ubuntu18.04onWindows"
        $installerName = "ubuntu1804.exe"
        $exeName = "bash.exe"
    }
    
    # Enable the WSL feature in Windows.
    $featureStatus = Get-WindowsOptionalFeature -Online `
            -FeatureName Microsoft-Windows-Subsystem-Linux
    if ($featureStatus.State -Match 'Enabled') {
        PPrint "Windows Subsystem for Linux (WSL) already enabled."
    }
    else {
        PPrint "Enabling the Windows Subsystem for Linux (WSL)."
        Enable-WindowsOptionalFeature -Online -NoRestart `
                -FeatureName Microsoft-Windows-Subsystem-Linux | Out-Null
        if (Reboot-Pending) { Invoke-ResumeReboot }
    }

    # Download and add the distro appx package.
    if (Get-Command $installerName -ErrorAction SilentlyContinue) {
        PPrint "$script:WSLDistro appx package already added."
    }
    else {
        PPrint "Downloading the WSL distro, please wait."
        $distroAppx = Download-File $distroUrl "$Env:TEMP\wsl.appx"
        Add-AppxPackage $distroAppx
        Remove-Item -confirm:$false -force $distroAppx
    }
    
    # Install the WSL distro, defer user creation.
    # TODO Make this check somehow if it's already installed? Don't know how
    # yet. Bash.exe appears as soon as the WSL feature is enabled. At any
    # rate, the command seems to have built-in idempotence, so maybe don't
    # bother?
    PPrint "Running $installerName."
    & $installerName install --root
  
    return
}

function PivotToWSL {
    # Convert the windows path for this file to a WSL unix path. Grab the
    # filename from args, lowercase the first letter, replace backslash with
    # slash, replace 'x:' with '/mnt/x'.
    $winFile = $script:args[0]
    $temp = ($winFile[0].ToString()).ToLower() + $winFile.Substring(1)
    $file = $temp -Replace "\\","/" -Replace "(^[a-z]):",'/mnt/$1'
    # PPrint "WSL unix filename is: $file" # DEBUG

    # Pivot to WSL bash. Use bash to grab the bash script snippet in this
    # file, convert CRLF to LF, and pipe it into a second instance of bash
    # for
    # execution. Also pass the name of this file to the second bash instance
    # via the $file variable. After the script snippet finishes, drop to the
    # command line by running a third instance of bash as a login schell.
    iex ("bash -c 'sed -n /#\ region\ bash/,/#\ endregion\ MAGIC/p " + $file `
            + " | tr -d \\\r | file=" + $file + " bash ; bash -l'")

    # ^LEGEND:
    # iex   PowerShell Invoke-Expression
    # bash   The default unix shell in WSL.
    # -c     Bash command to execute.
    # sed   The unix stream editor, a non-interactive text editor.
    # -n     Don't print all lines by default.
    # /pattern1/,/pattern2/p     Print lines from pattern1 to pattern2.
    # tr     The unix translate program for character replacement.
    # -d     Delete instead of replace.
    # \\\r   Extra escaped escape code for Carriage Return (CR).
    # file   The environment variable used to pass the filename to bash.
    # -l     Launch bash as a login shell.
}

function DummyStage { # DEBUG
    PPrint "Hit the $($MyInvocation.MyCommand.Name) function!"
    # PPrint "Filename: $($script:args[0])"
    # pause
    return
}

function DeleteTempResumeTask {
    $task = $script:taskName
    if (Get-ScheduledTask -TaskName $task -ErrorAction SilentlyContinue) {
        PPrint "Removing temporary reboot-and-resume scheduled task."
        Unregister-ScheduledTask -TaskName $task -Confirm:$false
    }
    return
}

# endregion stageFunctions



# region helperFunctions

function Banner ($text) {
    # Banner Overkill. :D
    $columns = $Host.UI.RawUI.WindowSize.Width
    $text = ' ' + $text + ' '
    $numSquiggles = [math]::Truncate(($columns - $text.Length - 8) / 2)
    $squiggles = ''
    While ($squiggles.Length -Lt $numSquiggles) { $squiggles += '~' }
    PPrint ("`n`n    " + $squiggles + $text + $squiggles + "    `n`n")
}

function Get-CurrentUser {
    $identity  = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $parts = $identity.Name -split "\\"
    return @{Domain=$parts[0];Name=$parts[1]}
}

function Download-File ($url, $destFile = 'none' ) {
    # Why is tls1.2 disabled by default?
    [Net.ServicePointManager]::SecurityProtocol = "tls12, tls11"
    
    # Get the filename from the url if it wasn't specified, and set TEMP as
    # the download directory path.
    if ($destFile -Eq 'none') {
        $destFile = Split-Path -Leaf $url
        $destFile = Join-Path $Env:TEMP $destFile
    }

    # Set destination file and remove an old version if it exists.
    if( Test-Path $destFile ) { Remove-Item -force $destFile }
    
    # Make us a webclient. (Invoke-Webrequest is slow as garbage, miss me
    # with that shit. Possibly bandwidth-limited by the user interface,
    # possibly using full internet explorer under the hood for downloads...)
    $downloader = New-Object System.Net.WebClient;
    
    # Proxy support!
    $webProxy=[System.Net.WebProxy]::GetDefaultProxy()
    $webProxy.UseDefaultCredentials = $true
    $downloader.Proxy=$wp
    
    # Some sites don't like us unless we pretend to be a browser.
    $downloader.Headers['User-Agent'] = `
            [Microsoft.PowerShell.Commands.PSUserAgent]::Chrome
    
    # Get it! Quickly now!
    PPrint "Downloading $url to $destFile."
    $downloader.DownloadFile($url, $destFile)
    
    # Return a file handle object for the new file.
    Return New-Object io.fileinfo $destFile
}

function Unzip-Archive ($file, $dstDir = $Env:TEMP) {
    # Unzip to temp directory if no destination is specified.
    PPrint "Extracting $file to $dstDir."
    return Expand-Archive -LiteralPath $file -DestinationPath $dstDir -Force
}

function Get-ZipContent ($zipfile) {
    [Reflection.Assembly]::LoadWithPartialName(
        'System.IO.Compression.FileSystem'
    )
    $zipfileHandle = [IO.Compression.ZipFile]::OpenRead($zipfile)
    $entries = $zipfileHandle.Entries
    $zipfileHandle.Dispose()
    return $entries
}

function Test-Admin {
    $identity  = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object System.Security.Principal.WindowsPrincipal(
        $identity
    )
    $admin = [System.Security.Principal.WindowsBuiltInRole]::Administrator
    return $principal.IsInRole( $admin )
}

function Restart-Explorer {
    PPrint "Restarting the Windows Explorer process..."
    $user = Get-CurrentUser
    $explorer = Get-Process -Name explorer -ErrorAct stop -IncludeUserName

    if($explorer -ne $null) {
        if ($explorer.UserName -eq "$($user.Domain)\$($user.Name)") {
            Stop-Process -Force -ErrorAct Stop $explorer | Out-Null
        }
    }

    Start-Sleep 1

    if(!(Get-Process -Name explorer -ErrorAct SilentlyContinue)) {
        start-Process -FilePath explorer
    }
    return
}

function Ensure-MSMQModule { # TODO

}

function Ensure-NugetPackageProvider {
    $requireVer = '2.8.5.201'
    if ('nuget' -In (Get-PackageProvider).name) {
        $installedVer = (Get-PackageProvider nuget).version.ToString()
    }
    if ($installedVer -Lt $requireVer) {
    PPrint "Installing or upgrading NuGet Package Provider."
    Install-PackageProvider -Name NuGet -MinimumVersion $requireVer `
            -Force | Out-Null
    }
    return
}

function Ensure-PendingRebootModule {
    # Installing PendingReboot with Install-Module depends on a good version
    # of NuGet.
    Ensure-NugetPackageProvider

    # Install the PendingReboot PowerShell module. 'gcm' is "Get-Command".
    if (gcm -Name Test-PendingReboot -ErrorAction SilentlyContinue) {
        PPrint "Test-PendingReboot module already installed."
    }
    else {
        PPrint "Trusting the PSGallery module repository, please wait."
        Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted
        PPrint "Installing the PendingReboot powershell module."
        Install-Module PendingReboot
        PPrint "Untrusting the PSGallery repository, please wait."
        Set-PSRepository -Name "PSGallery" -InstallationPolicy UnTrusted
    }
    return
}

function Reboot-Pending {
    # Make sure we have the Test-PendingReboot cmdlet installed.
    Ensure-PendingRebootModule

    return (Test-PendingReboot `
            -SkipConfigurationManagerClientCheck).IsRebootPending
}

function Invoke-ResumeReboot {
    $task = $script:taskName
    $user = Get-CurrentUser
    $username = $user.Name
    $domain = $user.Domain
    $fullUser = $domain + '\' + $username  
    $dir = Split-Path $script:args[0]
    $file = Split-Path -Leaf $script:args[0]


    # Schedule a task since it bypasses the UAC prompt (unlike the registry
    # runonce and tartup shortcut methods of resuming).
    
    # Remove an old task if it's there.
    DeleteTempResumeTask

    # Compose task settings.
    $arg = '-noprofile ' + ($script:args -Join ' ')
    $d = "Temporary task to resume $file at logon."
    $a = New-ScheduledTaskAction -Execute "PowerShell" -Argument "$arg" `
            -WorkingDirectory "$dir"
    $p = New-ScheduledTaskPrincipal -RunLevel Highest -UserId "$fullUser"
    $s = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -Priority 4 `
            -DontStopIfGoingOnBatteries
    $t = @()
    $t += New-ScheduledTaskTrigger -AtLogon -User $fullUser

    # Build and register the task.
    $taskObject = New-ScheduledTask -Description $d -Action $a -Principal $p `
            -Settings $s -Trigger $t
    Register-ScheduledTask -Force -TaskName $task -User $fullUser `
            -InputObject $taskObject | Out-Null

    # Doublecheck that it registered.
    if (Get-ScheduledTask -TaskName $task -ErrorAction SilentlyContinue) {
        PPrint "Created scheduled task: '$($task.ToString())'."
    }
    else {
        PPrint "Failed to schedule task. Reboot and relaunch manually."
        exit
    }

    PPrint "Rebooting and resuming at logon."
    pause # DEBUG
    Invoke-Reboot
}

function Invoke-Reboot {
    Restart-Computer -force -ErrorAct SilentlyContinue
    # It's important to exit here or Windows will happily keep running the
    # parts of the script that are only supposed to happen after reboot
    # while rebooting... ¬¬
    exit
}

function PPrint {
    # TODO: Pretty-print this somehow?
    Write-Host $args
}

# endregion



<# Bash shellscript block.
# region bash      MAGIC LINE - do not change unless you know what you're doing!

# This snippet is the bash section of the script. It's a block comment in
# PowerShell.

function Main {
    ComfyWelcome
    winUser=$(GetWindowsUser)
    echo "Windows username:" $winUser
    # TODO apt-get and stuff
    DeleteThisTempFile
}

function GetWindowsUser {
    # Funny how you can run windows commandline programs from bash (as long
    # as you specify the file extension).
    cmd.exe /c "echo %USERNAME%"
}

function DeleteThisTempFile {
    # Make the regex as narrow as possible. Look for our magic string and
    # exactly 7 digits.
    if [[ $file =~ .*\.tempMAGIC[0-9]{7}\.bat$ ]]; then
        echo "Removing this temporary file:"

    echo "   " $file
    rm -f $file
    fi
}

function ComfyWelcome {
        cat << 'ENDASCII'
                 .                                            .            
     *   .                  .              .        .   *          .       
  .         .                     .       .           .      .        .    
        o                             .                   .                
         .              .                  .           .                   
          0     .                                                          
                 .          .                 ,                ,    ,      
 .          \          .                         .                         
      .      \   ,                                                         
   .          o     .                 .                   .            .   
     .         \                 ,             .                .          
               #\##\#      .                              .        .       
             #  #O##\###                .                        .         
   .        #*#  #\##\###                       .                     ,    
        .   ##*#  #\##\##               .                     .            
      .      ##*#  #o##\#         .                             ,       .  
          .     *#  #\#     .                    .             .          ,
                      \          .                         .               
____^/\___^--____/\____O______________/\/\---/\___________---______________
   /\^   ^  ^    ^                  ^^ ^  '\ ^          ^       ---        
         --           -            --  -      -         ---  __       ^    
   --  __                      ___--  ^  ^                         --  __  

                        Welcome home, space cowboy.                        

ENDASCII
}

# Enable forward function declarations.
Main "$@"

# endregion         MAGIC LINE, do not change unless you know what you're doing!
#>
