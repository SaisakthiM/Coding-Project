from re import search

import requests

API_KEY = open("API_KEY", "r").read()
SEARCH_ENGINE_ID = open("SEARCH_ENGINE_ID", "r").read()

search_query = input("Enter the search query: ")
url = "https://www.googleapis.com/customsearch/v1"

parameter = {
    'q' : search_query,
    'key' : API_KEY,
    'cx' : SEARCH_ENGINE_ID,
    'dateRestrict' : '2001-09-10:2001-09-13 ',
}

response = requests.get(url, params=parameter)
data = response.json()

if 'items' in data:
    for item in data['items']:
        title = item['title']
        link = item['link']
        snippet = item['snippet']
        print(f"Title: {title}\nLink: {link}\nSnippet: {snippet}\n\n")
    