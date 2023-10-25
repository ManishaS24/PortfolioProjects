#!/usr/bin/env python
# coding: utf-8

# In[1]:


from bs4 import BeautifulSoup
import requests


# In[7]:


url = 'https://en.wikipedia.org/wiki/list_of_largest_companies_in_the_United_States_by_revenue'

page = requests.get(url)
soup = BeautifulSoup(page.text, 'html')


# In[8]:


print(soup)


# In[11]:


soup.find('table')


# In[14]:


table = soup.find_all('table')[1]


# In[15]:


print(table)


# In[31]:


world_title = table.find_all('th')


# In[32]:


print(world_title)


# In[33]:


world_table_title = [title.text.strip() for title in world_title]


# In[34]:


print(world_table_title)


# In[47]:


#!pip install pandas


# In[37]:


import pandas as pd


# In[42]:


df = pd.DataFrame(columns = world_table_title)
df


# In[46]:


column_data = table.find_all('tr')
#print(column_data)


# In[60]:


for row in column_data[1:]:
    row_data = row.find_all('td')
    individual_row_data = [data.text.strip() for data in row_data]
    #print(individual_row_data)
    length = len(df)
    #print(length)
    df.loc[length] = individual_row_data
df


# In[64]:


df.to_csv(r'C:\Users\Manisha\Documents\GitHub\Python\Web Scraping\LargestCompaniesByRevenue.csv', index = False)


# In[ ]:




