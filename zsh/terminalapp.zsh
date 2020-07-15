# http://superuser.com/a/313172/187254
precmd () { print -Pn "\e]2; %~/ \a" }
preexec () { print -Pn "\e]2; %~/ \a" }
