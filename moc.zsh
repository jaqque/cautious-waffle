#!/usr/bin/env zsh

typeset -A gems
gems[1]='trickshot black-rose everlasting-torment'
gems[2]='power-and-command hunger bloody-reach'
gems[2/5]='bottled-hope phoenix-ashes bsj'
gems[3/5]=$gems[2/5]
gems[4/5]=$gems[2/5]
gems[5/5]=$gems[2/5]

typeset -A stars
stars[1]=$'\u2605'
stars[2]=$'\u2605\u20\u2605'
stars[2/5]=$'\u2605\u20\u2605\u20\u2606\u20\u2606\u20\u2606'
stars[3/5]=$'\u2605\u20\u2605\u20\u2605\u20\u2606\u20\u2606'
stars[4/5]=$'\u2605\u20\u2605\u20\u2605\u20\u2605\u20\u2606'
stars[5/5]=$'\u2605\u20\u2605\u20\u2605\u20\u2605\u20\u2605'

get_random_number() {
  if [[ $1 ]]; then
    print $(( RANDOM % $1 ))
  else
    # magick number from zsh(1) manpage
    print $(( 1.0 * RANDOM / 32767 ))
  fi
}

get_gem_type() {
  local number_of_gem_types random_index
  # means returns number of items in array
  # (k) means return keys as an array
  number_of_gem_types=${#${(k)gems}}
  # (k) means return keys as an array
  r=$(get_random_number $number_of_gem_types)
  : echo $(( r % number_of_gem_types +1 ))
  print ${${(k)gems}[(( r % number_of_gem_types + 1 ))]}
}

get_gem_name() {
  local number_of_gems_in_type
  # (ps: :) means split on space, return as array
  # means returns number of items in array
  number_of_gems_in_type=${#${(ps: :)gems[$gem_type]}}
  # print ${${gems[(( RANDOM % number_of_gem_in_type + 1 ))]}}
  print ${${(ps: :)gems[$gem_type]}[(( RANDOM % number_of_gems_in_type + 1))]}

}

rolls=0

# set PRNG seed, if passed
#if [[ $1 ]]; then
#  RANDOM=$1
#fi

while [[ rolls -lt 10 ]]; do
  print RAND=$(get_random_number)
  gem_type=$(get_gem_type)
  gem=$(get_gem_name $gem_type)

  echo "you found a $stars[$gem_type]  $gem"

  # increment rolls
  : $(( rolls++ ))
done

