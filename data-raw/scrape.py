
from bs4 import BeautifulSoup
import pandas as pd
import requests
import string


# Create home URLS
base = 'https://www.goruck.com/blogs/news-stories/'
pages = [
    'daily-wod-december-2023',
    'daily-wod-november-2023',
    'daily-wod-october-2023',
    'daily-wod-september-2023',
    'daily-wod-august-2023',
    'daily-wod-july-2023',
    'goruck-wod-june-2023'
]

URLS = [base + page for page in pages]

def get_workouts(URL):


    # URL of the webpage you want to scrape
    # url = URLS[0]


    # Send a GET request to the webpage
    response = requests.get(URL)

    # Parse the HTML content of the webpage
    soup = BeautifulSoup(response.text, 'html.parser')

    # List to store paragraph texts and iframe URLs in order
    paragraphs_and_iframes = []

    # Find all paragraph tags
    paragraphs = soup.find_all('p')

    # Loop through each paragraph and process
    for paragraph in paragraphs:
        # Replace <br> tags with actual line breaks
        for br in paragraph.find_all('br'):
            br.replace_with('\n')
        
        # Append the text content of the paragraph to the list
        paragraph_text = paragraph.text.strip()
        paragraphs_and_iframes.append(paragraph_text)
        
        # Find all iframe tags within the paragraph
        iframes = paragraph.find_all('iframe')
        
        # Loop through each iframe tag
        for iframe in iframes:
            # Get the URL from the src attribute of the iframe
            iframe_url = iframe.get('src')
            if iframe_url:
                # Append the URL found within the iframe to the list
                paragraphs_and_iframes.append(iframe_url)

    # Print the combined list
    # print("Paragraphs and Iframes:", paragraphs_and_iframes)

    # for i in paragraphs_and_iframes:
    #     print(i)

    pos_header = [i.endswith('"') for i in paragraphs_and_iframes]
    pos_yt = [i.startswith('https') for i in paragraphs_and_iframes]


def split_list(paragraphs_and_iframes, pos_header, pos_yt):
    sublists = []
    current_sublist = []

    for text, is_header, is_yt in zip(paragraphs_and_iframes, pos_header, pos_yt):
        if is_header:
            # Start a new sublist
            current_sublist = [text]
        else:
            current_sublist.append(text)
            
        if is_yt:
            # End the current sublist
            sublists.append(current_sublist)
            current_sublist = []

    # Add the last sublist if it's not empty
    if current_sublist:
        sublists.append(current_sublist)

    return sublists


    results = split_list(paragraphs_and_iframes, pos_header, pos_yt)
    results = [ x for x in results if "BE THE FIRST TO KNOW" not in x ]

    # Fix URL
    final = [[text.replace('embed/', 'watch?v=') for text in sublist] for sublist in results]

    return(final)


if __name__ == '__main__':

    # Loop through each webpage
    workouts = [get_workouts(url) for url in URLS]

    

    # Final cleanup
    flattened_workouts = [item for sublist in workouts for item in sublist]
    blanks_gone = [list(filter(None, lst)) for lst in flattened_workouts]

    # Convert to df
    colnames = list(string.ascii_lowercase[:19])
    df = pd.DataFrame(blanks_gone, dtype=object)
    df.columns = colnames


    def replace_commas_with_star(sublist):
        delim = "*" 
        return reduce(lambda x, y: str(x) + delim + str(y), sublist)
    
    # replace comma delim in list of lists
    to_write = [replace_commas_with_star(sublist) for sublist in blanks_gone]
    

    # Write to csv
    df.to_csv('data-raw/workouts.csv', index=False)
    filename = "data-raw/workouts.txt"
    # with open(filename, "w") as file:
    #     for item in blanks_gone:
    #         file.write(str(item) + "\n")
