import argparse
import sys
import pickle
import random
from functools import wraps
from string import punctuation


def file_opening_checker(func):
    @wraps(func)
    def check_opening(*args, **kwargs):
        try:
            return func(*args, **kwargs)
        except IOError as e:
            print(f'{e} error')
    return check_opening


def get_brackets_indexes(text_str):
    """
    Бьём текст по скобкам
    возвращает list с индексами начала и конца провильных скобочных последовательностей"""
    brackets = {
        '(': ')',
        '[': ']',
        '{': '}'
    }
    closing_brackets = ')}]'
    brackets_indexes = list()
    stack = list()
    for counter, sym in enumerate(text_str):
        if sym in brackets:
            if not stack:
                brackets_indexes.append(counter)
                stack.append(sym)
            elif stack[-1] == sym:
                stack.append(sym)
        elif sym in closing_brackets:
            if brackets[stack[-1]] == sym:
                stack.pop()
            if not stack:
                brackets_indexes.append(counter)
    return brackets_indexes


def get_quoters_indexes(text_str):
    """
    Бьём текст по кавычкам
    возвращает list с индексами начала и конца провильных последовательностей кавычек"""
    quoters = '\'\"'
    quoter_indexes = list()
    quoter_open = False
    quoter_type = ''
    counter = 0
    for sym in text_str:
        if sym in quoters:
            if quoter_open:
                if quoter_type == sym:
                    quoter_open = False
                    quoter_indexes.append(counter)
            else:
                quoter_open = True
                quoter_type = sym
                quoter_indexes.append(counter)
        counter += 1
    return quoter_indexes


def add_not_intersecting_indexes(indexes, start_of_not_intersection):
    """
    Начиная с номера start_of_not_intersection находит первый открывающий
    и последний закрывающий символ (кавычку или скобку)
    Причём делает это лениво : как только находит первую корректную языковую конструкцию
    добавляет пару индексов к ответу"""
    residual_indexes = []
    open_count = 0
    while start_of_not_intersection < len(indexes):
        current_index = start_of_not_intersection
        split_index = indexes[start_of_not_intersection]
        start_of_not_intersection += 1
        if open_count == 0:
            residual_indexes.append(split_index)
        if current_index % 2 == 0:
            open_count += 1
        else:
            open_count -= 1
        if open_count == 0:
            residual_indexes.append(split_index)
    return residual_indexes


def join_indexes(brackets_indexes, quoter_indexes):
    """
    накладывает один набор индексов на другой так,
    что если одна пара (начало, конец) полностью содержится в другой, остаётся только большая пара
    Скобочные последовательности в тексте правильные,
    поэтому пара (начало, конец) никогда ЧАСТИЧНО не наложиться на другую
    Они могут только одна содержаться в другой или не пересекаться
    Функция возвращает полученый list из индексов"""
    splitting_indexes = list()
    open_count = 0
    first_brackets_iterator = 0
    second_brackets_iterator = 0
    while first_brackets_iterator < len(brackets_indexes) and second_brackets_iterator < len(quoter_indexes):
        if brackets_indexes[first_brackets_iterator] < quoter_indexes[second_brackets_iterator]:
            current_index = first_brackets_iterator
            split_index = brackets_indexes[first_brackets_iterator]
            first_brackets_iterator += 1
        else:
            current_index = second_brackets_iterator
            split_index = quoter_indexes[second_brackets_iterator]
            second_brackets_iterator += 1

        if open_count == 0:
            splitting_indexes.append(split_index)

        if current_index % 2 == 0:
            open_count += 1
        else:
            open_count -= 1

        if open_count == 0:
            splitting_indexes.append(split_index)

    for additional_indexes in add_not_intersecting_indexes(brackets_indexes, first_brackets_iterator):
        splitting_indexes.append(additional_indexes)

    for additional_indexes in add_not_intersecting_indexes(quoter_indexes, second_brackets_iterator):
        splitting_indexes.append(additional_indexes)

    return splitting_indexes


def split_by_quoters_and_brackets(func):
    """
    Разбивает каждое слово в list по блокам с кавычками/скобками
    Оборачивает функцию, которая возвращает list из слов, которые нужно разбить"""
    @wraps(func)
    def wrapper(*args, **kwargs):
        text = func(*args, **kwargs)
        brackets_and_quoters_splitted_text = list()
        for text_str in text:
            brackets_indexes = get_brackets_indexes(text_str)
            quoter_indexes = get_quoters_indexes(text_str)
            splitting_indexes = join_indexes(brackets_indexes, quoter_indexes)

            # разбиваем текст по получившимся индексам
            result_indexes = list()
            for i in range(0, len(splitting_indexes), 2):
                result_indexes.append(splitting_indexes[i] - 1)
                result_indexes.append(splitting_indexes[i])
                result_indexes.append(splitting_indexes[i + 1])
                result_indexes.append(splitting_indexes[i + 1] + 1)
            result_indexes.insert(0, 0)
            result_indexes.append(len(text_str) - 1)

            for i in range(0, len(result_indexes), 2):
                word = text_str[result_indexes[i]:result_indexes[i + 1] + 1]
                if word != '':
                    brackets_and_quoters_splitted_text.append(word)
        return brackets_and_quoters_splitted_text
    return wrapper


def split_by_spaces(func):
    """
    Разбивает каждое слово в list по пробелам
    Оборачивает функцию, которая возвращает list из слов, которые нужно разбить"""
    @wraps(func)
    def wrapper(*args, **kwargs):
        text = func(*args, **kwargs)
        space_splitted_text = list()
        for word in text:
            if word[0] not in '\'\"({[':
                for sub_word in word.split():
                    space_splitted_text.append(sub_word)
            else:
                space_splitted_text.append(word)
        return space_splitted_text
    return wrapper


@split_by_spaces
@split_by_quoters_and_brackets
@file_opening_checker
def formate_text(input_file):
    """
    Удаляет из текста всё кроме букв и знаков препинания
    и разбивает текст на слова и правильные скобочно-кавычечные последовательности"""
    with input_file as file:
        text_str = ''
        for line in file:
            for sym in line:
                if sym == '\n':
                    text_str += ' '
                elif sym in punctuation or sym.isalpha() or sym == ' ':
                    text_str += sym
        text = [text_str]
        return text


def get_probabilities_part(dictionary, input_n_grammas):
    """
    Получает на вход словарь в который нужно записывать вероятности для мн-ва из слов длины length
    и добавляет в словарь вероятности встречи очередного слова после последовательности слов длины length - 1"""
    if input_n_grammas:
        # в каждый эл-т словаря записываем словарь с количеством слов каждого типа
        for n_gramma in input_n_grammas:
            dictionary.setdefault(n_gramma[:-1], dict())
            dictionary[n_gramma[:-1]].setdefault(n_gramma[-1], 0)
            dictionary[n_gramma[:-1]][n_gramma[-1]] += 1
        # нормируем вероятности для каждого слова принадлежащего данной в n-грамме
        for n_gramma in dictionary.values():
            sum_count = sum(n_gramma.values())
            for symbol in n_gramma:
                n_gramma[symbol] /= sum_count


def get_default_probabilities_dict(text):
    """
    Возращает словарь с вероятностями для пустой истории
    его можно было бы добавить в общий словарь, но тогда придётся отказаться от использования set-a
    который значительно ускоряет генерацию словаря"""
    dictionary = dict()
    words_count = 0
    for word in text:
        if word in punctuation:
            continue
        words_count += 1
        dictionary.setdefault(word, 0)
        dictionary[word] += 1
    for word in set(dictionary.keys()):
        dictionary[word] /= words_count
    return dictionary


def get_next_word(probabilities_dict, current_n_gramma):
    current_n_gramma_words_count = 0
    while not current_n_gramma[current_n_gramma_words_count:] in probabilities_dict:
        current_n_gramma_words_count += 1
    new_n_gramma = current_n_gramma[current_n_gramma_words_count:]
    next_word_probability_dict = probabilities_dict[new_n_gramma]
    new_probability = random.random()
    for symbol, probability in next_word_probability_dict.items():
        new_probability -= probability
        if new_probability <= 0:
            return symbol


# режим calculate_probabilities
@file_opening_checker
def generate_probabilities_dict(input_file, depth):
    with input_file as file:
        text = formate_text(file)
        current_length_n_grammas = set(tuple(text[i:i+depth]) for i in range(len(text) - depth + 1))
        # не достаточно только этих depth-грамм т.к. остались n-граммы меньшего размера в конце теста
        # их нужно рассмотреть отдельно, иначе они не будут учитываться при создании текста
        # если depth << длины текста то их можно игнорировать для упрощения логики
        additional_n_grammas = [tuple(text[-i:]) for i in range(depth - 1, 0, -1)]
        probabilities_dict = dict()
        for length in range(depth - 1):
            get_probabilities_part(probabilities_dict, current_length_n_grammas)
            current_length_n_grammas = set(word[:-1] for word in current_length_n_grammas)
            current_length_n_grammas.add(additional_n_grammas[length])
        probabilities_dict[()] = get_default_probabilities_dict(text)
        return probabilities_dict


@file_opening_checker
def saveprobabilities_dict(output_file, dictionary):
    with output_file as file:
        pickle.dump(dictionary, file)


# режим generate_text
@file_opening_checker
def get_probabilities_dict(input_file):
    with input_file as file:
        return pickle.load(file)


def cut_excess_symbols(generated_text, tokens_count):
    """
    После разбиения текста каждый токен это обычное слово
    или правильная скобочно-кавычечная последовательность
    соответственно после генерации текста получим больше токенов чем нужно
    поэтому обрезам получившийся текст до нужной длины"""
    real_tokens_count = 0
    cur_word_index = 0
    previous_word = ''
    text_with_correct_words_count = []
    while real_tokens_count < tokens_count:
        sym = generated_text[cur_word_index]
        cur_word_index += 1
        if sym in punctuation or sym == ' ':
            if previous_word != '':
                real_tokens_count += 1
                text_with_correct_words_count.append(previous_word)
            if sym != ' ':
                real_tokens_count += 1
            text_with_correct_words_count.append(sym)
            previous_word = ''
        else:
            previous_word += sym
    return text_with_correct_words_count


def fix_punctuation_and_grammar(text_str):
    # стираем начало теста до первой буквы
    # и делаем первую букву заглавной
    incorrect_symbols_in_beginning_count = 0
    for sym in text_str:
        if not sym.isalpha():
            incorrect_symbols_in_beginning_count += 1
        else:
            break

    correct_beginning_str = text_str[incorrect_symbols_in_beginning_count].upper()
    correct_beginning_str += text_str[incorrect_symbols_in_beginning_count + 1:]

    # удаляем символы которые не могут встречаться друг за другом
    not_paired_symbols = '.?!,:-'
    previous_sym = '*'
    correct_punctuation_str = ''
    for sym in correct_beginning_str:
        if previous_sym not in not_paired_symbols or sym not in not_paired_symbols:
            correct_punctuation_str += sym
        previous_sym = sym

    # делаем заглавными буквы стоящие в начале предложения
    sentence_end_symbols = '.?!'
    correct_grammar_str = ''
    for counter, sym in enumerate(correct_punctuation_str):
        if counter >= 2 and sym.isalpha() and correct_punctuation_str[counter - 2] in sentence_end_symbols:
            correct_grammar_str += sym.upper()
        else:
            correct_grammar_str += sym
    return correct_grammar_str


@file_opening_checker
def generate_new_text(output_file, dictionary, depth, tokens_count):
    with output_file as file:
        generated_text = ''
        current_n_gramma = []
        for _ in range(tokens_count):
            if len(current_n_gramma) > depth:
                current_n_gramma.pop(0)
            next_word = get_next_word(dictionary, tuple(current_n_gramma))
            if next_word not in punctuation:
                generated_text += ' '
            generated_text += next_word
            current_n_gramma.append(next_word)
        text_with_correct_words_count = cut_excess_symbols(generated_text, tokens_count)
        text_with_correct_punctuation_and_grammar = fix_punctuation_and_grammar(''.join(text_with_correct_words_count))
        file.write(text_with_correct_punctuation_and_grammar)


# 2 главные функции
def calculate_probabilities(args):
    """
    Читает файл, генерирует словарь с вероятностями и записывает его в файл"""
    probabilities_dict = generate_probabilities_dict(args.input_file, args.depth)
    saveprobabilities_dict(args.output_file, probabilities_dict)


def read_probabilities_and_generate_text(args):
    """
    Читает словарь с вероятностями, генерирует текст и записывает его в файл"""
    probabilities_dict = get_probabilities_dict(args.input_file)
    generate_new_text(args.output_file, probabilities_dict, args.depth, args.tokens_count)


def main():
    parser = argparse.ArgumentParser()
    subparsers = parser.add_subparsers()

    parser_calcprob = subparsers.add_parser('calculate_probabilities')
    parser_calcprob.add_argument('-i', '--input_file', type=argparse.FileType('r', errors='ignore'), required=True,
                                 help="файл по которому будет сгенерирован текст")
    parser_calcprob.add_argument('-o', '--output_file', type=argparse.FileType('wb'), required=True,
                                 help="файл в который будет загружен словарь с вероятностями")
    parser_calcprob.add_argument('-d', '--depth', type=int, required=True,
                                 help="количество предыдущих слово, которые будут учитываться при генерации следующего")
    parser_calcprob.set_defaults(func=calculate_probabilities)

    parser_gentext = subparsers.add_parser('generate_text')
    parser_gentext.add_argument('-i', '--input_file', type=argparse.FileType('rb'), required=True,
                                help="файл в который записан словарь с вероятностями")
    parser_gentext.add_argument('-o', '--output_file', type=argparse.FileType('w'), default=sys.stdout,
                                help="файл в который будет записан сгенерированный текст (консоль по умолчанию)")
    parser_gentext.add_argument('-t', '--tokens_count', type=int, required=True,
                                help="количество слов которые нужно сгенерировать")
    parser_gentext.add_argument('-d', '--depth', type=int, required=True,
                                help="количество предыдущих слово, которые будут учитываться при генерации следующего")
    parser_gentext.set_defaults(func=read_probabilities_and_generate_text)

    args = parser.parse_args()
    args.func(args)


if __name__ == '__main__':
    main()
