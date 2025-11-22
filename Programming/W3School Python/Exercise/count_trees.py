def count_trees():
    print(f"No of Trees in trees.txt is {sum(1 for line in open(r'C:\\Coding Project\\Programming\\W3School Python\\Exercise\\trees.txt', 'r') for word in line.split() if word.lower() == 'trees')}")

count_trees()