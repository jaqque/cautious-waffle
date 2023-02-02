#!/usr/bin/env/ruby

def egg(basket, colors)
  total_of_eggs=basket.sum
  egg_number=( rand() * total_of_eggs + 1 ).to_i

  lower_bound = upper_bound = 0

  basket.each_with_index do |amount, index|
    upper_bound += amount
    return colors[index] if ( lower_bound < egg_number and egg_number <= upper_bound )
    lower_bound = upper_bound
  end
end

puts egg([6,4,2],["White","Brown","Blue")
