compdef _octaccord octaccord

_octaccord () {
  local curcontext="$curcontext"
  local line state _opts

  _opts=("${(@f)$(octaccord completions -- ${(Q)words[2,-1]})}")
  $_opts && return 0

  return 1
}
