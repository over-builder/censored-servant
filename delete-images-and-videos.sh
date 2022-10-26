#!/bin/bash
for f in /home/$pervert/Downloads/* /home/$pervert/Downloads/**/* ; do
  f_mime=`file --mime-type "$f" | sed -n -e 's/^.*: //p'`

  case $f_mime in
      image* | bitmap* | video*)
          rm "$f"
          ;;
      *)
          ;;
  esac
done
