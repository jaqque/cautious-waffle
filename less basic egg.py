from random import randint

# This is a very good demonstration... But, we can improve it in a few ways.

# Rather than storing an array, we can remember how many of each egg there are.
# There are 6 white eggs, 4 brown eggs, and 2 blue eggs.
# So if we pick any number between 1 and 6, we get a white egg.
# Any number between 7 and 10, we'll get a brown egg.
# Any number between 11 and 12, we'll get a blue egg.

# This can be rewritten as:
# 1  = x and x <= 6  white
# 7  = x and x <= 10  brown
# 11 = x and x <= 12 blue

# There are other ways to rewrite this, but let's use this syntax first
# (Actually 2023 me, you wrote that terribly)

# We should also account for the error of "Wait, we don't have that many eggs!"

# So again, let us pick our random number, 1-12.
chosen_number = randint(1, 12)

# And then, a basic if-else statement set to determine which egg was picked:
egg = ''
if ((chosen_number == 1) and (chosen_number <= 6)):
  egg = 'white'
elif ((chosen_number == 7) and (chosen_number <= 10)):
  egg = 'brown'
elif ((chosen_number == 11) and (chosen_number <= 12)):
  egg = 'blue'
else:
  egg = 'Call the farmer!'

print(f'The number you chose was {chosen_number}. This means you picked a '
      f'{egg} egg.')