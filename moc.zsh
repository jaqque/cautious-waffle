#!/usr/bin/env zsh

# from the simulator:
# const GEM_TYPES = [1, 2, 5];
# const GEM_ODDS = [0.754, 0.201, 0.045];
# const FIVE_STAR_GEM_TYPES = [2, 3, 4, 5]
# const FIVE_STAR_ODDS = [0.75, 0.2, 0.04, 0.01];

typeset -A gems
gems[1]='0.754,\u2605 trickshot black-rose everlasting-torment'
gems[2]='0.201,\u2605\u20\u2605 power-and-command hunger bloody-reach'
gems[2/5]='0.045*0.75,\u2605\u20\u2605\u20\u2606\u20\u2606\u20\u2606 bottled-hope phoenix-ashes bsj'
gems[3/5]='0.045*0.20,\u2605\u20\u2605\u20\u2605\u20\u2606\u20\u2606 '${${(ps: :)gems[2/5]}[2,-1]}
gems[4/5]='0.045*0.04,\u2605\u20\u2605\u20\u2605\u20\u2605\u20\u2606 '${${(ps: :)gems[2/5]}[2,-1]}
gems[5/5]='0.045*0.01,\u2605\u20\u2605\u20\u2605\u20\u2605\u20\u2605 '${${(ps: :)gems[2/5]}[2,-1]}

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
  local number_of_gem_types random_roll potential_type
  variable_name=$1
  # means returns number of items in array
  # (k) means return keys as an array
  number_of_gem_types=${#${(k)gems}}
  # (k) means return keys as an array
  get_random_number random_roll
  for potential_type in ${(k)gems}; do
    gem_chance=${${(ps: :)gems[$potential_type]}[1]%,*}
    if (( random_roll < (gem_chance) )); then
      break
    fi
    : $((random_roll-=gem_chance))
  done
  output=$potential_type
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
  gem_type=$2

  output="${${(ps: :)gems[$gem_type]}[1]#*,} "

  : ${(P)${variable_name}::=${output}}
}

# set PRNG seed, if passed
if [[ $1 ]]; then
 RANDOM=$1
fi

# CONSTANTS

typeset -r legos_per_run=10
typeset -r dollars_per_run=25

typeset -A totals
need_five_stars=true
crest_runs=0
csv_document=()

while [[ $need_five_stars == true ]]; do
  ten_cr_run=()
  rolls=0
  while [[ rolls -lt legos_per_run ]]; do
    get_gem_type gem_type
    get_gem_name gem $gem_type
    get_gem_stars stars $gem_type
    if [[ $gem_type == "5/5" ]]; then
      need_five_stars=false
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
