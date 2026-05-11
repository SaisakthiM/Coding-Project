import requests
from bs4 import BeautifulSoup

def decode_secret_message(url):
    response = requests.get(url)
    soup = BeautifulSoup(response.text, 'html.parser')
    
    table = soup.find('table')
    rows = table.find_all('tr')
    
    characters = []
    
    for row in rows[1:]:  # skip header
        cols = row.find_all('td')
        if len(cols) == 3:
            x = int(cols[0].get_text().strip())   # col 0 = x
            char = cols[1].get_text().strip()      # col 1 = character
            y = int(cols[2].get_text().strip())    # col 2 = y
            characters.append((char, x, y))
    
    max_x = max(x for _, x, _ in characters)
    max_y = max(y for _, _, y in characters)
    
    grid = [[' ' for _ in range(max_x + 1)] for _ in range(max_y + 1)]
    
    for char, x, y in characters:
        grid[max_y - y][x] = char  # invert y-axis
    
    for row in grid:
        print(''.join(row))

decode_secret_message("https://docs.google.com/document/d/e/2PACX-1vSvM5gDlNvt7npYHhp_XfsJvuntUhq184By5xO_pA4b_gCWeXb6dM6ZxwN8rE6S4ghUsCj2VKR21oEP/pub")