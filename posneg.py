import re
import pandas as pd
import requests
import zipfile
import io
import os
import nltk
from nltk.tokenize import word_tokenize
from nltk.corpus import stopwords
from collections import Counter

# Download necessary NLTK resources (uncomment if running for first time)
# nltk.download('punkt')
# nltk.download('stopwords')

class SentimentAnalyzer:
    def __init__(self):
        """Initialize the sentiment analyzer."""
        self.positive_words = set()
        self.negative_words = set()
        self.stop_words = set(stopwords.words('english'))
        
    def download_nrc_lexicon(self):
        """
        Download and process the NRC Emotion Lexicon.
        This uses the publicly available NRC Word-Emotion Association Lexicon (EmoLex)
        """
        nrc_url = "https://saifmohammad.com/WebDocs/NRC-Emotion-Lexicon.zip"
        lexicon_path = "NRC-Emotion-Lexicon-Wordlevel-v0.92.txt"
        
        print("Downloading NRC Emotion Lexicon...")
        
        try:
            # Download the zip file
            response = requests.get(nrc_url)
            if response.status_code != 200:
                print(f"Failed to download lexicon. Status code: {response.status_code}")
                return False
                
            # Extract the zip file
            with zipfile.ZipFile(io.BytesIO(response.content)) as z:
                # Find the lexicon file in the zip
                for filename in z.namelist():
                    if filename.endswith(lexicon_path):
                        # Read the lexicon file
                        with z.open(filename) as f:
                            content = f.read().decode('utf-8')
                            
                            # Process each line
                            for line in content.split('\n'):
                                if line.strip():
                                    parts = line.strip().split('\t')
                                    if len(parts) == 3:
                                        word, emotion, value = parts
                                        value = int(value)
                                        
                                        # Add to appropriate set based on emotion
                                        if emotion == "positive" and value == 1:
                                            self.positive_words.add(word.lower())
                                        elif emotion == "negative" and value == 1:
                                            self.negative_words.add(word.lower())
                            
            print(f"Loaded {len(self.positive_words)} positive words and {len(self.negative_words)} negative words.")
            return True
            
        except Exception as e:
            print(f"Error downloading or processing NRC lexicon: {e}")
            return False
    
    def load_nrc_lexicon_from_file(self, file_path):
        """
        Load the NRC lexicon from a local file.
        Expected format: word emotion value
        """
        try:
            if not os.path.exists(file_path):
                print(f"File not found: {file_path}")
                return False
                
            # Read the lexicon file
            with open(file_path, 'r', encoding='utf-8') as f:
                for line in f:
                    if line.strip():
                        parts = line.strip().split('\t')
                        if len(parts) == 3:
                            word, emotion, value = parts
                            value = int(value)
                            
                            # Add to appropriate set based on emotion
                            if emotion == "positive" and value == 1:
                                self.positive_words.add(word.lower())
                            elif emotion == "negative" and value == 1:
                                self.negative_words.add(word.lower())
            
            print(f"Loaded {len(self.positive_words)} positive words and {len(self.negative_words)} negative words.")
            return True
            
        except Exception as e:
            print(f"Error loading NRC lexicon from file: {e}")
            return False
    
    def load_liwc_lexicon(self, liwc_file):
        """
        Load LIWC lexicon from a file.
        Note: LIWC requires a license and has a specific format.
        This is a simplified implementation.
        """
        try:
            # LIWC format varies but typically has categories like 'posemo' and 'negemo'
            liwc_data = pd.read_csv(liwc_file, sep='\t')
            
            # Extract words from positive and negative emotion categories
            # The actual column names and structure will depend on your LIWC file
            if 'word' in liwc_data.columns and 'category' in liwc_data.columns:
                pos_words = liwc_data[liwc_data['category'].str.contains('posemo', na=False)]
                neg_words = liwc_data[liwc_data['category'].str.contains('negemo', na=False)]
                
                self.positive_words = set(pos_words['word'].str.lower())
                self.negative_words = set(neg_words['word'].str.lower())
                
                print(f"Loaded {len(self.positive_words)} positive words and {len(self.negative_words)} negative words.")
                return True
            else:
                print("LIWC file format not recognized.")
                return False
                
        except Exception as e:
            print(f"Error loading LIWC lexicon: {e}")
            return False
    
    def preprocess_text(self, text):
        """Clean and tokenize text."""
        # Convert to lowercase
        text = text.lower()
        
        # Remove special characters and numbers
        text = re.sub(r'[^a-zA-Z\s]', '', text)
        
        # Tokenize
        tokens = word_tokenize(text)
        
        # Remove stopwords (optional)
        tokens = [word for word in tokens if word not in self.stop_words]
        
        return tokens
    
    def analyze_sentiment(self, text, include_stopwords=False):
        """
        Analyze sentiment of the given text and return the positive/negative ratio.
        
        Args:
            text (str): Text to analyze
            include_stopwords (bool): Whether to include stopwords in analysis
            
        Returns:
            dict: Analysis results including counts, percentages and ratios
        """
        # Preprocess text
        text = text.lower()
        text = re.sub(r'[^a-zA-Z\s]', '', text)
        tokens = word_tokenize(text)
        
        if not include_stopwords:
            tokens = [word for word in tokens if word not in self.stop_words]
        
        if not tokens:
            return {
                'total_words': 0,
                'positive_words': 0,
                'negative_words': 0,
                'positive_pct': 0.0,
                'negative_pct': 0.0,
                'neutral_pct': 0.0,
                'ratio': 0.0,
                'sentiment': 'neutral',
                'most_common_positive': [],
                'most_common_negative': []
            }
        
        # Count positive and negative words
        positive_words = [word for word in tokens if word in self.positive_words]
        negative_words = [word for word in tokens if word in self.negative_words]
        
        positive_count = len(positive_words)
        negative_count = len(negative_words)
        neutral_count = len(tokens) - positive_count - negative_count
        
        # Calculate percentages
        total_words = len(tokens)
        positive_pct = (positive_count / total_words * 100) if total_words > 0 else 0
        negative_pct = (negative_count / total_words * 100) if total_words > 0 else 0
        neutral_pct = (neutral_count / total_words * 100) if total_words > 0 else 0
        
        # Calculate ratio (handle division by zero)
        ratio = positive_count / max(negative_count, 1)  # Avoid division by zero
        
        # Determine overall sentiment
        if positive_count > negative_count:
            sentiment = 'positive'
        elif negative_count > positive_count:
            sentiment = 'negative'
        else:
            sentiment = 'neutral'
        
        # Find most common positive and negative words
        positive_counter = Counter(positive_words)
        negative_counter = Counter(negative_words)
        
        return {
            'total_words': total_words,
            'positive_words': positive_count,
            'negative_words': negative_count,
            'neutral_words': neutral_count,
            'positive_pct': positive_pct,
            'negative_pct': negative_pct,
            'neutral_pct': neutral_pct,
            'ratio': ratio,
            'sentiment': sentiment,
            'most_common_positive': positive_counter.most_common(5),
            'most_common_negative': negative_counter.most_common(5)
        }

    def visualize_results(self, results):
        """Return a formatted string of the sentiment analysis results."""
        output = "\n===== SENTIMENT ANALYSIS RESULTS =====\n"
        output += f"Total words analyzed: {results['total_words']}\n"
        output += f"Positive words: {results['positive_words']} ({results['positive_pct']:.2f}%)\n"
        output += f"Negative words: {results['negative_words']} ({results['negative_pct']:.2f}%)\n"
        output += f"Neutral words: {results['neutral_words']} ({results['neutral_pct']:.2f}%)\n"
        output += f"Positive/Negative ratio: {results['ratio']:.2f}\n"
        output += f"Overall sentiment: {results['sentiment'].upper()}\n\n"
        
        if results['most_common_positive']:
            output += "Most common positive words:\n"
            for word, count in results['most_common_positive']:
                output += f"  - {word}: {count}\n"
        
        if results['most_common_negative']:
            output += "\nMost common negative words:\n"
            for word, count in results['most_common_negative']:
                output += f"  - {word}: {count}\n"
        
        return output


# Example usage
if __name__ == "__main__":
    # Initialize analyzer
    analyzer = SentimentAnalyzer()
    
    # Option 1: Download NRC lexicon automatically
    analyzer.download_nrc_lexicon()
    
    # Option 2: Load NRC lexicon from local file
    # analyzer.load_nrc_lexicon_from_file("path/to/NRC-Emotion-Lexicon-Wordlevel-v0.92.txt")
    
    # Option 3: Load LIWC lexicon (if you have it)
    # analyzer.load_liwc_lexicon("path/to/liwc_lexicon.csv")
    
    # Sample text to analyze
    sample_text = """
    I had a wonderful day at the park today. The weather was beautiful and I met some 
    amazing new friends. However, the food from the vendor was terrible and I got a 
    headache from the sun. Despite the few problems, overall it was a fantastic experience 
    that I would absolutely recommend to anyone looking for a fun day out.
    """
    
    # Analyze sentiment
    results = analyzer.analyze_sentiment(sample_text)
    
    # Print formatted results
    print(analyzer.visualize_results(results))