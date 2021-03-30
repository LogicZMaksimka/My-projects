from flask import Flask, render_template
from string import punctuation
from collections import Counter
import re


class TextAnalyzer:
    _TEMPLATE_PATH = 'templates/analyzer.html'

    def __init__(self):
        self._most_common_words_count = 1
        self._sorted_words = []
        self._input_text = ''
        self._words_count = 0
        self._punctuation_marks_count = 0
        self._analyze_in_lowercase = False

    def render_site(self):
        return render_template(self._TEMPLATE_PATH,
                               start_words_count=self._most_common_words_count,
                               start_text=self._input_text,
                               sorted_words=self._sorted_words,
                               analyze_in_lowercase=self._analyze_in_lowercase,
                               words_count=self._words_count,
                               punctuation_marks_count=self._punctuation_marks_count,
                               )

    @property
    def most_common_words_count(self):
        return self._most_common_words_count

    @most_common_words_count.setter
    def most_common_words_count(self, value):
        self._most_common_words_count = value

    @property
    def text(self):
        return self._input_text

    @most_common_words_count.setter
    def text(self, text):
        self._input_text = text

    def calculate_words_count(self):
        words = re.findall(r'\w+', self._input_text)
        self._words_count = len(words)
        return self._words_count

    def calculate_punctuation_marks_count(self):
        self._punctuation_marks_count = 0
        for sym in self._input_text:
            if sym in punctuation:
                self._punctuation_marks_count += 1
        return self._punctuation_marks_count

    def calculate_frequencies(self, analyze_in_lowercase=False):
        text = self._input_text
        if analyze_in_lowercase:
            self.analyze_in_lowercase = analyze_in_lowercase
            text = text.lower()
        words = re.findall(r'\w+', text)
        word_counter = Counter(words)
        self._sorted_words = word_counter.most_common(self._most_common_words_count)
        return self._sorted_words
