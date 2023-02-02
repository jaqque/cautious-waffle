#!/usr/bin/env/ruby

def egg()
  egg_number=(rand()*12+1).to_i

  if (egg_number == 1); "White";
  elsif (egg_number == 2); "White";
  elsif (egg_number == 3); "White";
  elsif (egg_number == 4); "White";
  elsif (egg_number == 5); "White";
  elsif (egg_number == 6); "White";
  elsif (egg_number == 7); "Brown";
  elsif (egg_number == 8); "Brown";
  elsif (egg_number == 9); "Brown";
  elsif (egg_number == 10); "Brown";
  elsif (egg_number == 11); "Blue";
  elsif (egg_number == 12); "Blue";
  else "Call the farmer!"
  end
end

puts egg
