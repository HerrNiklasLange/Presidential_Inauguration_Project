# import pandas lib as pd
#
import pandas as pd
import nltk
nltk.download('all')
# load excel file into a dataframe object.
print("here is the dataframe")

# read by default 1st sheet of an excel file
df_speech = pd.read_excel('pres_inuagural_address.xlsx')


def preprocess_text(text):
    # Tokenization
    tokens = nltk.word_tokenize(text)
    
    # Lowercasing
    tokens = [token.lower() for token in tokens]
    
    # Remove punctuation and non-alphabetic characters
    tokens = [token for token in tokens if token.isalpha()]
    
    # Remove stop words
    stop_words = set(nltk.corpus.stopwords.words('english'))
    tokens = [token for token in tokens if token not in stop_words]
    
    # Stemming or Lemmatization (using stemming here)
    stemmer = nltk.PorterStemmer()
    tokens = [stemmer.stem(token) for token in tokens]
    
    return tokens

df_speech['processed_speech'] = df_speech['speech'].apply(preprocess_text)
print(df_speech.head())

def sum_graph(df):
    import matplotlib.pyplot as plt
    from wordcloud import WordCloud

    all_words = ' '.join([' '.join(map(str, tokens)) for tokens in df['processed_speech']])
    wordcloud = WordCloud(width=800, height=400, background_color='white').generate(all_words)

    plt.figure(figsize=(10, 5))
    plt.imshow(wordcloud, interpolation='bilinear')
    plt.axis('off')
    plt.show()
    
sum_graph(df_speech)