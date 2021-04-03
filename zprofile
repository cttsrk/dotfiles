# Append user bin directory to path if it exists
if [ -d "$HOME/bin" ] ; then
    export PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/.cargo/bin" ] ; then
     export PATH="$HOME/.cargo/bin:$PATH"
fi

# Make sure we have a temp directory
if [ -z "$TMPDIR" ]; then
    TMPDIR="/tmp/"
fi
