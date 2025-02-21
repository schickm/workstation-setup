#!/bin/sh

# Meant to be called by kakoune so that nnn redirects opened files back kakoune client that called
# it.

if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <kak_session> <kak_client>" >&2  # Error message to stderr
  exit 1  # Exit with error code
fi

# Export these so that they are available inside of nnn-kak-opener.sh.  NNN doesn't support openers
# being passed arguments, so thus we have to make them available in the ENV.
export kak_session="$1"
export kak_client="$2"

# and set the opener script.  This will get triggered by NNN whenever a file is opened in it, passing
# the file name as the first argument
export NNN_OPENER="nnn-kak-opener.sh"

# and lastly launch nnn
nnn
