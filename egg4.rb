#!/usr/bin/env/ruby

def egg(basket)
  total_of_eggs=basket.values.sum
  egg_number=( rand() * total_of_eggs + 1 ).to_i

  lower_bound = upper_bound = 0

  basket.keys.each do |color|
    upper_bound += basket[color]
    return color if ( lower_bound < egg_number and egg_number <= upper_bound )
    lower_bound = upper_bound
  end
end

puts egg({"White" => 6, "Brown" => 4, "Blue" => 2})
