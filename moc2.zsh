#!/usr/bin/env zsh

# this one does it more like the simulator

# from the simulator:
# const GEM_TYPES = [1, 2, 5];
# const GEM_ODDS = [0.754, 0.201, 0.045];
# const FIVE_STAR_GEM_TYPES = [2, 3, 4, 5]
# const FIVE_STAR_ODDS = [0.75, 0.2, 0.04, 0.01];

typeset -ra GEM_TYPES=(1 2 5)
typeset -ra GEM_ODDS=(0.754 0.201 0.045)
typeset -ra FIVE_STAR_GEM_TYPES=(2 3 4 5)
typeset -ra FIVE_STAR_ODDS=(0.75 0.2 0.04 0.01)

typeset -A gems
gems[1]='trickshot black-rose everlasting-torment'
gems[2]='power-and-command hunger bloody-reach'
gems[2/5]='bottled-hope phoenix-ashes bsj'
gems[3/5]=$gems[2/5]
gems[4/5]=$gems[2/5]
gems[5/5]=$gems[2/5]

typeset -r filled_star=$'\u2605' # ★
typeset -r hollow_star=$'\u2606' # ☆

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
  variable_name=$1
  local number_of_gem_types random_roll potential_type

  gem_types=($GEM_TYPES)
  gem_odds=($GEM_ODDS)
  get_random_number random_roll
  current_star_chance=0
  for star_chance in $gem_odds; do
    : $(( current_star_chance+=star_chance ))
    if (( random_roll <= current_star_chance )); then
      max_stars=$gem_types[1]
      output=$max_stars
      break
    fi
    shift gem_types
  done
  if (( max_stars == 5 )); then
    gem_types=($FIVE_STAR_GEM_TYPES)
    gem_odds=($FIVE_STAR_ODDS)
    get_random_number random_roll
    current_star_chance=0
    for star_chance in $gem_odds; do
      : $(( current_star_chance+=star_chance ))
      if (( random_roll <= current_star_chance )); then
        max_stars=$gem_types[1]
        output="$max_stars/$output"
        break
      fi
      shift gem_types
    done
  fi

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

  local number_of_filled_stars total_of_all_stars
  number_of_filled_stars=${2%/*}
  total_of_all_stars=${2#*/}

   # right fill takes strings, not parameters
  output=${${(r:${number_of_filled_stars}::*:):-}:gs/*/$filled_star}
  output=${${(r:${total_of_all_stars}::-:)output}:gs/-/$hollow_star}
  output="${(j: :)${(s::)output}} " # double wide characters

  : ${(P)${variable_name}::=${output}}
}

# unit test for get_gem_stars
# for i in 1 2 2/5 3/5 4/5 5/5 4/7 3/2 /; do
#   get_gem_stars g $i
#   # can probably center the $i with some fancy padding zsh-expn-style
#   printf '%-3s -> "%s"\n' $i $g
# done
# exit 0

# set PRNG seed, if passed
if [[ $1 ]]; then
 RANDOM=$1
fi

# CONSTANTS

typeset -r legos_per_run=10
typeset -r dollars_per_run=25

typeset -A totals
five_stars_found=0
five_stars_required=6
crest_runs=0
csv_document=()

while (( five_stars_found < five_stars_required )); do
  # need_five_stars=false
  ten_cr_run=()
  rolls=0
  while [[ rolls -lt legos_per_run ]]; do
    get_gem_type gem_type
    get_gem_name gem $gem_type
    get_gem_stars stars $gem_type
    if [[ $gem_type == "5/5" ]]; then
      : $(( five_stars_found++ ))
    fi
    : $((totals[$gem_type]+=1 ))
    # printf '[%d/%4d] you found a [%3s] %-10b %s\n' \
    #   $rolls $crest_runs $gem_type $stars $gem
    printf '[%d/%4d] %-10b %s\n' \
      $rolls $crest_runs $stars $gem
    result="$gem_type,$stars,$gem"
    ten_cr_run+=($result)
    # increment rolls
    : $(( rolls++ ))
  done
  printf ' --  --  --\n'
  # print "${(j:,:)ten_cr_run}"
  csv_document+=(${(j:,:)ten_cr_run})
  : $(( crest_runs++ ))
done
# print "${(j:\n:)csv_document}"
print "TOTAL RUNS: $crest_runs"
print "You spent: \$$(( crest_runs * dollars_per_run ))"
print "I hope it was worth it."

print "GEM SUMMARY:"
for key in ${(ok)totals}; do
  printf '%-3s %5i (%7.4f%%)\n' \
    $key \
    ${totals[$key]} \
    $(( 100.0 * totals[$key] / (legos_per_run * crest_runs ) ))
done
