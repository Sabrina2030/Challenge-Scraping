""" Funcion que procesa la informacion y crea las metricas necesarias """

def process_data(df):
    # Contar el número de palabras en el título
    df['word_count'] = df['title'].apply(lambda x: len(x.split()))
    
    # Contar el número de caracteres en el título
    df['char_count'] = df['title'].apply(len)
    
    # Generar una lista de palabras que comienzan con mayúscula
    df['capitalized_words'] = df['title'].apply(lambda x: [word for word in x.split() if word.istitle()])
    
    return df
