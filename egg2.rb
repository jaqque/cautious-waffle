#!/usr/bin/env/ruby

def egg()
  egg_number=(rand()*12+1).to_i

  if    (egg_number >=  1 and egg_number <=  6); "White";
  elsif (egg_number >=  7 and egg_number <=  9); "Brown";
  elsif (egg_number >= 10 and egg_number <= 12); "Blue";
  else  "Call the farmer!"
  end
end

puts egg
