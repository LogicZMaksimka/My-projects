import unittest
from textAnalyzer import TextAnalyzer


class simpleAppTests(unittest.TestCase):
    def setUp(self):
        self.testing_analyzer = TextAnalyzer()

    def test_words_count(self):
        self.testing_analyzer.most_common_words_count = 42
        self.assertEqual(self.testing_analyzer.most_common_words_count, 42)

    def test_simple_numbers(self):
        self.testing_analyzer.text = '1 1 1 2 2 3'
        self.testing_analyzer.most_common_words_count = 3
        sorted_words = self.testing_analyzer.calculate_frequencies()
        self.assertEqual(sorted_words, [('1', 3), ('2', 2), ('3', 1)])

    def test_simple_words(self):
        self.testing_analyzer.text = '''
            Светить Светить всегда, светить везде,
            До дней последних донца,
            Светить - и никаких гвоздей!
            Вот лозунг мой - и солнца!'''
        self.testing_analyzer.most_common_words_count = 1
        sorted_words = self.testing_analyzer.calculate_frequencies()
        self.assertEqual(sorted_words, [('Светить', 3)])

    def test_incorrect_punctuation(self):
        self.testing_analyzer.text = '''
            .. \"I will go to the club\" ,, said Tom
            (he always talks bullshit).
             \"Ok,, i agree\", said said Bob (he agrees) ..'''
        self.testing_analyzer.most_common_words_count = 2
        sorted_words = self.testing_analyzer.calculate_frequencies()
        self.assertEqual(sorted_words, [('said', 3), ('he', 2)])

    def test_simple_words_count(self):
        self.testing_analyzer.text = """
            придумал еще одну - галочка нужно ли приводить весь текст к lower или учитывать регистр"""
        self.assertEqual(self.testing_analyzer.calculate_words_count(), 14)

    def test_simple_punctuation_marks_count(self):
        self.testing_analyzer.text = """
            def test_simple_numbers(self):
                self.testing_analyzer.text = '1 1 1 2 2 3'
                self.testing_analyzer.most_common_words_count = 3
                sorted_words = self.testing_analyzer.calculate_frequencies()
                self.assertEqual(sorted_words, [('1', 3), ('2', 2), ('3', 1)])"""
        self.assertEqual(self.testing_analyzer.calculate_punctuation_marks_count(), 50)

    def test_lowercase_mode(self):
        self.testing_analyzer.text = "ANIME AnIme AnimE aNime anime"
        self.testing_analyzer.most_common_words_count = 1
        sorted_words = self.testing_analyzer.calculate_frequencies(True)
        self.assertEqual(sorted_words, [('anime', 5)])


if __name__ == '__main__':
    unittest.main(argv=['', '-v'], defaultTest='simpleAppTests', exit=False)
