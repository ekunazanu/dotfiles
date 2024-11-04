title=$(cmus-remote -Q | grep title | cut -c 11-)
artist=$(cmus-remote -Q | grep "tag artist" | cut -c 12-)
status=$(cmus-remote -Q | grep status | cut -c 8-)
shuffle=$(cmus-remote -Q | grep shuffle | cut -c 13-)
repeat=$(cmus-remote -Q | grep "repeat " | cut -c 12-)
repeat_current=$(cmus-remote -Q | grep repeat_current | cut -c 20-)

echo {'"title":' '"'$title'"', '"artist":' '"'$artist'"', '"status":' '"'$status'"', '"shuffle":' '"'$shuffle'"', '"repeat":' '"'$repeat'"', '"repeat_current":' '"'$repeat_current'"'}
