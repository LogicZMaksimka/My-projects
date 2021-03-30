from flask import Flask, redirect, request
from textAnalyzer import TextAnalyzer
import os


PROJECT_ROOT = os.path.dirname(__file__)
TEMPLATE_PATH = os.path.join(PROJECT_ROOT, './')
ALLOWED_FILE_EXTENSIONS = {'txt', 'doc', 'cpp', 'py'}
app = Flask(__name__, template_folder=TEMPLATE_PATH)
analyzer = TextAnalyzer()


def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_FILE_EXTENSIONS


@app.route('/', methods=['GET'])
def get():
    return analyzer.render_site()


@app.route('/analyzeText', methods=['POST'])
def analyze_text():
    """
    Рассчитывает:
    - кол-во самых частых слов
    - общее число слов
    - общее число знаков препинания

    Если пользователь добавил файл, то в случае если он правильного разрешения
    программа будет обрабатывать его содержимое, а после запишет его в поле с текстом
    Если файла нет или расширение файла некорректное - предпочтение отдаётся полю с текстом"""
    text = request.form.get('input_text')
    if 'file' in request.files:
        file = request.files['file']
        if allowed_file(file.filename):
            text = file.read().decode('utf-8')
    analyzer.most_common_words_count = int(request.form.get('words_count'))
    analyzer.text = text
    analyzer.calculate_frequencies(analyze_in_lowercase=request.form.get('in_lowercase'))
    analyzer.calculate_words_count()
    analyzer.calculate_punctuation_marks_count()
    return redirect('/')


if __name__ == "__main__":
    app.run()
