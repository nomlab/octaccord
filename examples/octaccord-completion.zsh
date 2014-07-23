compctl -K _octaccord octaccord

_octaccord() {
  local words completions
  read -cA words

  if [ "${#words}" -eq 2 ]; then
    completions="$(octaccord commands)"
  elif [ "${#words}" -eq 3 ]; then
    completions=$(git remote -v | sed 's!.*github.com[/:]!!' | sed 's/\.git .*//' | sed 's/\.wiki$//' | sort | uniq)
  else
    completions="$(octaccord completions ${words[2]})"
  fi

  reply=("${(ps:\n:)completions}")
}
