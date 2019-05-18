# one path to rule them all
[ -d $HOME/bin ] && export PATH=$HOME/bin:$PATH
[ -d $HOME/otp/bin ] && export PATH=$HOME/otp/bin:$PATH

# one locale to rule them all
unset  LC_ALL
unset  LANGUAGE
unset  LC_CTYPE
export LANG=$(locale -a | grep -Ei "en.us.utf")
