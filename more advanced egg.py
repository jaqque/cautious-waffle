from random import randint

# So let's now improve that even further. Generalize it even more.
# Draw the basket now as it was first described to us:
# There are 6 white eggs, 4 brown eggs, and 2 blue eggs.

# This can be done using a hash, or in Python, a dict.
basket = {
  'white': 6,
  'brown': 4,
  'blue': 2
}

# The next thing we should do is use the total sum of the values of the dict to
# define the largest number we can randomly pick, instead of setting it
# arbitrarily to "12".
# This is so very easy. xD
amount_of_eggs = sum(basket.values())
chosen_number = randint(1, amount_of_eggs)

# Then we can examine the formula of the last step:
# lower bound = x and x <= upper bound

# Where lower bound began at 1, and increased by the count of the
# previous egg for each step:
# 1, (+ 6) 7, (+ 4)
# Note here that it could be 0 or 1 as the first lower bound, and change
# nothing, as we tell randint to only pick a number between 1 and total.
# So for ease, we'll be starting with the lower bound of 0

# And the upper bound began at the first count, and increased by the
# current egg for each step:
# 6, (+ 4) 10, (+ 2)

# We can also rewrite the formula itself:
# if lower bound < x <= upper bound
# if 1 < x <= 6, for example
# If we set the lower bound to the upper bound at the end of each cycle,
# then we've already decided that it is more than the lower bound at least.
# (Help with words? sorry)

# Now, let us construct a loop, where we iterate through the different colors,
# and see if we have an egg within those bounds.

# Start with our bounds at 0
lower_bound = upper_bound = 0

# Make sure we can grab that egg we choose
# Default it to the error case!
chosen_egg = '... Call the farmer!'
for color, count in basket.items():
  # Move our upper bound up by
  # the # of eggs in that color
  upper_bound += count

  # Then, set the egg if it matches:
  if ((lower_bound < chosen_number) and (chosen_number <= upper_bound)):
    chosen_egg = color
    # And break out of the loop, to save memory:
    break

  # Move the lower bound up
  lower_bound = upper_bound

print(f'The number you chose was {chosen_number}. This means you picked a '
      f'{chosen_egg} egg.')