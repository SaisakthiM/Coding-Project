source = 'def n():\n\tprint("hi")\nn()'

with open("example.py", "w") as f:
    f.write(source)