#!/usr/bin/awk -f
# Highlight every other row for increased readability.
NR % 2 == 0 {
    print "\033[48:5:0m" "\033[38;5;7m" $0 "\033[48:5:0m" "\033[K" "\033[0m"
    next
}
NR % 2 == 1 {
    print "\033[48;5;18m" "\033[38;5;7m" $0 "\033[48:5:18m" "\033[K" "\033[0m"
}
