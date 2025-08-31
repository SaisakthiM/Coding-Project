file = open(r"C:\Coding Project\Pycharm\Testing\Txt File\detail.txt",'r')
file1 = open(r"C:\Coding Project\Pycharm\Testing\Txt File\new_file.txt",'+r')
count_d = 0
lines = file.readlines()
file.seek(0)
for line in lines:
    words = line.split()
    for word in words:
        if word.startswith("D") or word.startswith("d"):
            print(word)
            file1.writelines(word)
            count_d += 1

print("")
print(f"No of Lines which starts with \"D\" is : {count_d}")

print("")
print("The content in the \"new_file.txt\" is :")
print(file1.readlines())