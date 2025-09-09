# import pandas lib as pd
#
import pandas as pd
import nltk
nltk.download('all')
# load excel file into a dataframe object.
print("here is the dataframe")

# read by default 1st sheet of an excel file
dataframe1 = pd.read_excel('pres_inuagural_address.xlsx')
i = 0 
for i in range(dataframe1.shape[0]):
    print(i)
    #dataframe1["speech"][i]
print(dataframe1["speech"][0])

from nltk.tokenize import word_tokenize
from nltk.corpus import stopwords
from nltk.stem import WordNetLemmatizer
# Tokenization
tokens = word_tokenize(dataframe1["speech"][0])
print(tokens)
# Remove stop words
stop_words = set(stopwords.words('english'))
filtered_tokens = [word for word in tokens if word.lower() not in stop_words]
print(filtered_tokens)
# Lemmatization
lemmatizer = WordNetLemmatizer()
lemmatized_tokens = [lemmatizer.lemmatize(word) for word in filtered_tokens]
print(lemmatized_tokens)
# POS tagging