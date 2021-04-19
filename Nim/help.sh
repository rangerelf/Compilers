#!/bin/bash
# Display some help content, and also some built-in
# small utility scripts.

version() {
  nim --version \
    | grep -Eoi 'version [0-9]+(\.[0-9]+)+' \
    | head -1 \
    | awk '{print $2}'
}

usage() {
  cat <<EOT
This docker image encapsulates the Nim v$(version) compiler
and tools, including inim, the interactive command line
exploration tool.

Also included is the MUSL LibC, which is a completely static
compact libc implementation, used to compile nim programs to
a completely static release by way of the -d:musl compiler
flag.

This command line can be used to compile a command line:

XXXX

$ docker run -ti --rm -v 

EOT
}



case "${0##*/}" in
  nimc) nimc ;;
     *) usage ;;
esac
exit 0
