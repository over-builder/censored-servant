#!/bin/bash
debug=true
dry_run=true
cmd=echo
cmd_pip=tr '\n' ' ' | cat && echo

while getopts 'n' opt; do
  case "$opt" in
      h)
       usage
       ;;

      d)
       ;&

usage() {
    welcome
    echo "Command line options:"
    echo "  -d               display debug messages"
    echo "  -u <username>    use <username> instead of the current user"
    echo "  -p               make it permanent and alter files"
    exit 1;
}

if $dry_run; then
  cmd=echo
  cmd_pipe=tr '\n' ' ' | cat && echo
else
  cmd=''
  cmd_pip=''
fi

if [$debug]; then
  echo "Test of dry_run - if dry_run flag not set, should produce output of 'ls' command." 
  $cmd ls -l

echo This script is designed to lock down your Ubuntu 22 system down to prevent the current user from modifying your browser settings and uninstalling or disabling the pury.fi extension for firefox.

if [ -z "$pervert" ]; then # pervert is unset or is the empty string
  if [ $SUDO_USER ]; then
      pervert=$SUDO_USER
  else
      pervert=$(whoami)
  fi
  echo "Censoring user $pervert"
fi

if [$pervert==root]
   echo "The script must be run by the user (a sudoer) whose privileges are being removed, and not as root." >&2
   exit 1
fi

if ! [ $(id -u) = 0 ]; then
   echo "The script need to be run with superuser privileges." >&2
   exit 1
fi

echo "Over Builder recommends setting up an account at ptimelock.com to store your passwords. We will need to store two passwords - your root and sudoer account passwords. We will also test that each password was entered correctly a few times before locking things down. Please copy and paste the response below."
echo ""
wait 10
echo "This is probably a good time to mention that you should disable remote login into your sudoer account if you're going to be storing the password on some random website."
echo ""
wait 10
echo "What will you use as a root password"
read -s root_password
echo "Please confirm the root password"
read -s root_check
if [$root_password == $root_check]; then
   echo "Take a boomer screenshot (a cell phone picture) of the password you copy pasted from ptimelock.com, or whatever other website you're using, in case you screw up saving it properlybecause you're a giant idiot. (Also, that website can be a bit fiddly with the usernames you enter and fails to save somewhat quietly.)"
   wait 60
   echo "Now enter the password by hand from the screenshot."
   read -s root_check
   if [$root_password == $root_check]; then
       echo "Good, now we can move on to the sudoer password that you will use to rescue your system if you break it, and to disable the policies that will restrict editing firefox. If ${pervert} is not the only sudoer on this system, you will want to deal with the passwords for those other logins somehow, but that can wait."
       echo ""
       wait 10
   else
      echo "Uh-oh, you didn't get the passwords right. It's probably best to start over when you're not drunk."
      exit 1
   fi
else
    echo "Uh-oh, you didn't get the passwords right. it's probably best to start over when you're not high."
    exit 1
fi
echo ""
echo "What will you use as a sudoer password?"
read -s puryfier_password
echo "Please confirm the sudoer password."
read -s puryfier_check
if [$puryfier_password == $puryfier_check]; then
   echo "Take a boomer screenshot (a cell phone picture) of the password you copy pasted from ptimelock.com, here and on ptimelock (or whatever other website you're using) in case you screw up saving it properly because you're a giant idiot. (Also, that website can be a bit fiddly with the usernames you enter and fails to save somewhat quietly.)"
   wait 60
   echo "Now enter the password by hand from the screenshot."
   read -s root_check
   if [$puryfier_password == $puryfier_check]; then
       echo "Excellent. We'll set up the sudoer with the username \"puryfier\"."
       echo ""
       wait 10
   else
      echo "Uh-oh, you didn't get the passwords right. It's probably best to start over when you're not hungover."
      exit 1
   fi
else
    echo "Uh-oh, you didn't get the passwords right. It's probably best to start over."
    exit 1
fi
if [$debug]; then
    echo "root:${root_password}"
    echo "puryfier:${puryfier_password}"
fi

$cmd mkdir /etc/firefox
$cmd mkdir /etc/firefox/policies
$cmd cp policies.json /etc/firefox/policies/policies.json

# /var/lib/snapd/profiles/snap.firefox.firefox

$cmd chmod +x delete-images-and-videos.sh
$cmd cp delete-images-and-videos.sh /usr/local/bin/delete-images-and-videos.sh

$cmd cp censored-servant.path /etc/systemd/local/user/

chmod 750 /bin/curl
chmod 750 /bin/wget

cat<<EOF
set superusers:"puryfier","root"
passwd puryfier $puryfier_passwd
passwd root     $root_passwd
EOF

$cmd deluser $pervert sudoers

echo "You are now locked out. Check to make sure everything works. Once you've tried logging into root, puryfier, and checked to make sure the grub password works.
