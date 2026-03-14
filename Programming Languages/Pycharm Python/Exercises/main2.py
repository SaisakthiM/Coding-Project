def words_main():
    f = open("Report.txt", 'r')
    s = f.readlines()
    words_res = ""
    for line in s: 
        words = line.split()
        for word in words:
            if word[0] in "aeiouAEIOU" and word[-1] in "aeiouAEIOU":
                words_res += word + " "
    f.close()
    print(words_res)
words_main()
