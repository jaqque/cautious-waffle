from random import choices

# There's also the python pre-implemented way, mentioned in basic:
# https://docs.python.org/3/library/random.html#random.choice

# random.choices(population, weights=None, *, cum_weights=None, k=1)

# If a weights sequence is specified, selections are made according to the relative weights. Alternatively, if a cum_weights sequence is given, the selections are made according to the cumulative weights (perhaps computed using itertools.accumulate()). For example, the relative weights [10, 5, 30, 5] are equivalent to the cumulative weights [10, 15, 45, 50]. Internally, the relative weights are converted to cumulative weights before making selections, so supplying the cumulative weights saves work.

basket = {
  'white': 6,
  'brown': 4,
  'blue': 2
}

chosen_egg = choices(list(basket.keys()), weights=list(basket.values()))
print(chosen_egg[0])

# Can even do many!
chosen_eggs = choices(list(basket.keys()), weights=list(basket.values()), k=10)
print(chosen_eggs)