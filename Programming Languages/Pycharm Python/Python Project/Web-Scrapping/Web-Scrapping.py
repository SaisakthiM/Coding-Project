from bs4 import BeautifulSoup

f = open('Resources/index.html','r').read()
soup = BeautifulSoup(f,'lxml')
print(soup.prettify())

