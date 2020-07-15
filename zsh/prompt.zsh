autoload colors && colors
# cheers, @ehrenmurdick
# http://github.com/ehrenmurdick/config/blob/master/zsh/prompt.zsh

if (( $+commands[git] ))
then
  git="$commands[git]"
else
  git="/usr/bin/git"
fi

git_branch() {
  echo $($git symbolic-ref HEAD 2>/dev/null | awk -F/ {'print $NF'})
}

git_dirty() {
  if $(! $git status -s &> /dev/null)
  then
    echo ""
  else
    if [[ $($git status --porcelain) == "" ]]
    then
      echo "on %{$fg_bold[green]%}$(git_prompt_info)%{$reset_color%}"
    else
      echo "on %{$fg_bold[red]%}$(git_prompt_info)%{$reset_color%}"
    fi
  fi
}

git_prompt_info() {
  ref=$($git symbolic-ref HEAD 2>/dev/null) || return
  echo "${ref#refs/heads/}"
}

#unpushed() {
  #$git cherry -v @{upstream} 2>/dev/null
#}

need_push() {
  if [ $($git rev-parse --is-inside-work-tree 2>/dev/null) ]; then
    #number=$($git cherry -v origin/$($git symbolic-ref --short HEAD) | wc -l | bc)
    number=$($git cherry -v @{upstream} 2>/dev/null | wc -l | bc)

    if [[ $number == 0 ]]; then
      echo " "
    else
      echo " with %{$fg_bold[magenta]%}$number unpushed%{$reset_color%}"
    fi
  fi
}

#node_version() {
  #echo "$(nodebrew ls | grep current | awk '{print $2}')"
#}

#ruby_version() {
  #if (( $+commands[rbenv] ))
  #then
    #echo "$(rbenv version | awk '{print $1}')"
  #fi

  #if (( $+commands[rvm-prompt] ))
  #then
    #echo "$(rvm-prompt | awk '{print $1}')"
  #fi
#}

#node_prompt() {
  #if ! [[ -z "$(node_version)" ]]
  #then
    #echo "%{$fg_bold[yellow]%}$(node_version)%{$reset_color%} "
  #else
    #echo ""
  #fi
#}

#rb_prompt() {
  #if ! [[ -z "$(ruby_version)" ]]
  #then
    #echo "%{$fg_bold[yellow]%}$(ruby_version)%{$reset_color%} "
  #else
    #echo ""
  #fi
#}

host_name() {
  echo "%{$fg_bold[yellow]%}%n@%m%{$reset_color%}"
}

directory_name() {
  echo "%{$fg_bold[cyan]%}%1/%\/%{$reset_color%}"
}

export PROMPT=$'\n$(host_name) in $(directory_name) $(git_dirty)$(need_push)\n› '
set_prompt() {
  export RPROMPT="%{$fg_bold[cyan]%}%{$reset_color%}"
}

precmd() {
  title "zsh" "%m" "%55<...<%~"
  set_prompt
}
