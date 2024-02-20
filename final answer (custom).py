from random import randint

# For you to copy, if you use Python, without the explanation.

basket = {
  'white': 6,
  'brown': 4,
  'blue': 2
}

amount_of_eggs = sum(basket.values())
chosen_number = randint(1, amount_of_eggs)

lower_bound = upper_bound = 0
chosen_egg = '... Call the farmer!'
for color, count in basket.items():
  upper_bound += count

  if ((lower_bound < chosen_number) and (chosen_number <= upper_bound)):
    chosen_egg = color
    break

  lower_bound = upper_bound

print(f'The number you chose was {chosen_number}. This means you picked a '
      f'{chosen_egg} egg.')