#!/usr/bin/env python
# coding: utf-8

# In[ ]:


#Automatic file organizer


# In[1]:


import os, shutil


# In[26]:


path = r"C:/Users/Manisha/Documents/Python-Projects/"


# In[36]:


file_names = os.listdir(path)
print(file_names)


# In[39]:


folder_names = ['csv files','image files','text files']


# In[41]:


for loop in range(0,3):
    if not os.path.exists(path + folder_names[loop]):
        print(path + folder_names[loop])
        os.makedirs((path + folder_names[loop]))


# In[42]:


for file in file_names:
    if '.csv' in file and not os.path.exists(path + 'csv files/' + file):
        shutil.move(path + file, path + 'csv files/' + file)
    elif '.png' in file and not os.path.exists(path + 'image files/' + file):
        shutil.move(path + file, path + 'image files/' + file)
    elif '.txt' in file and not os.path.exists(path + 'csv files/' + file):
        shutil.move(path + file, path + 'text files/' + file)


# In[49]:


from bs4 import BeautifulSoup


# In[50]:


import requests


# In[52]:


from bs4 import BeautifulSoup
import requests
html_doc = """
<html>
    <body>
        <h1>Hello!</h1>
    </body>
</html>
"""

soup = BeautifulSoup(html_doc, 'html.parser')

print(soup.find('h1').get_text())


# In[53]:


get_ipython().system('pip3 install requests')


# In[54]:


import requests


# In[55]:


from bs4 import BeautifulSoup
import requests


# In[56]:


url = 'https://www.scrapethissite.com/pages/forms/'

requests.get(url)


# In[ ]:




