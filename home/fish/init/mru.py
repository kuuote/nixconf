import sys

try:
    with open(sys.argv[1]) as h:
        data = h.readlines()
except Exception:
    data = []

data.insert(0, sys.argv[2] + '\n')
data = list(dict.fromkeys(data))

with open(sys.argv[1], 'w') as h:
    h.writelines(list(dict.fromkeys(data)))
