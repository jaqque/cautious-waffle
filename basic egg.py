from random import randint

# Let's say we have a basket of a dozen eggs.
# There are 6 white eggs, 4 brown eggs, and 2 blue eggs.
# We want to pick a random egg from that basket.

# So let's draw that basket as an array.
basket = ['white', 'white', 'white', 'white', 'white', 'white', 'brown',
          'brown', 'brown', 'brown', 'blue', 'blue']

# Then, let's pick a random number.
chosen_number = randint(1, 12)

# Our egg that we've chosen will be at that number, minus 1
# (because lists are indexed starting at 0)
chosen_egg = basket[chosen_number - 1]

print(f'The number you chose was {chosen_number}. This means you picked a '
      f'{chosen_egg} egg.')

# Oh btw- random has "choice"-
# https://docs.python.org/3/library/random.html#random.choice
# But still walking through how to do this yourself first, should you ever need
# to do this without such power again in the future.