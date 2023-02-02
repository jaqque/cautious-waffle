#!/usr/bin/env zsh

typeset -A gems
gems[1]='\u2605 trickshot black-rose everlasting-torment'
gems[2]='\u2605\u20\u2605 power-and-command hunger bloody-reach'
gems[2/5]='\u2605\u20\u2605\u20\u2606\u20\u2606\u20\u2606 bottled-hope phoenix-ashes bsj'
gems[3/5]='\u2605\u20\u2605\u20\u2605\u20\u2606\u20\u2606 '${${(ps: :)gems[2/5]}[2,-1]}
gems[4/5]='\u2605\u20\u2605\u20\u2606\u20\u2605\u20\u2606 '$gems[2/5]
gems[5/5]='\u2605\u20\u2605\u20\u2606\u20\u2606\u20\u2605 '$gems[2/5]

# typeset -A stars
# stars[1]=$'\u2605'
# stars[2]=$'\u2605\u20\u2605'
# stars[2/5]=$'\u2605\u20\u2605\u20\u2606\u20\u2606\u20\u2606'
# stars[3/5]=$'\u2605\u20\u2605\u20\u2605\u20\u2606\u20\u2606'
# stars[4/5]=$'\u2605\u20\u2605\u20\u2605\u20\u2605\u20\u2606'
# stars[5/5]=$'\u2605\u20\u2605\u20\u2605\u20\u2605\u20\u2605'

get_random_number() {
  local variable_name output
  variable_name=$1

  if [[ $2 ]]; then
    output=$(( $RANDOM % $2 ))
  else
    # magick number from zsh(1) manpage
    output=$(( 1.0 * $RANDOM / 32767 ))
  fi
  : ${(P)${variable_name}::=${output}}
}

get_gem_type() {
  local variable_name output
  local number_of_gem_types random_index
  variable_name=$1
  # means returns number of items in array
  # (k) means return keys as an array
  number_of_gem_types=${#${(k)gems}}
  # (k) means return keys as an array
  get_random_number random_index $number_of_gem_types
  output=${${(k)gems}[(( random_index % number_of_gem_types + 1 ))]}
  : ${(P)${variable_name}::=${output}}
}

get_gem_name() {
  local variable_name output
  variable_name=$1
  local gem_type number_of_gems_in_type
  gem_type=$2
  # (ps: :) means split on space, return as array
  # means returns number of items in array
  number_of_gems_in_type=${#${(ps: :)gems[$gem_type]}}
  # print ${${gems[(( RANDOM % number_of_gem_in_type + 1 ))]}}
  get_random_number gem_selection $(( number_of_gems_in_type-1 ))
  output=${${(ps: :)gems[$gem_type]}[(( gem_selection+2 ))]}
  : ${(P)${variable_name}::=${output}}
}

get_gem_stars() {
  # i know, a lot of boilerplate.
  # thus is the price of avoiding a subshell
  # don't need to do these things in a _real_ language
  # or i could just - *GASP* - use **GLOBALS**
  local variable_name output
  variable_name=$1

  output=${${(ps: :)gems[$gem_type]}[1]}

  : ${(P)${variable_name}::=${output}}
}
rolls=0

# set PRNG seed, if passed
if [[ $1 ]]; then
 RANDOM=$1
fi

## debugging function; safe to ignore
# inc() {
#   local variable_name output
#   variable_name=$1
#   output=${(P)${variable_name}}
#   : $(( output++ ))
#   : ${(P)${variable_name}::=${output}}
# }


while [[ rolls -lt 10 ]]; do
  # echo -n "internal: "
  # inc _internal
  # print $_internal
  # print RAND=$(get_random_number $RANDOM)
  # echo 3x: $RANDOM $RANDOM $RANDOM
  get_gem_type gem_type
  get_gem_name gem $gem_type
  get_gem_stars stars $gem_type
  echo "you found a $stars  $gem"

  # increment rolls
  : $(( rolls++ ))
done

