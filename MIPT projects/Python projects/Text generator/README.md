Генерация текста

Каждый символ пунктуации считается отдельным словом. Всё кроме пунктуации и букво отбрасывается

input_file выступает в роли файла с текстом в режиме calculate_probabilities и файлом с вероятностями в режиме generate_text
также с output_file

В режиме создания файла с вероятностями (calculate_probabilities) обязательные параметры --input_file, --output_file, --depth

Пример: python3 'myprogramm.py' calculate_probabilities --input_file input.txt  --depth 3 --output_file output.txt
Читает файл input.txt, генерирует словарь вероятностей с n-гаммами длины меньше depth в качестве ключей. Значения словаря - это словари с вероятностями выбора следующего за ключом слова. Словарь записывается в output.txt

В режиме создания текста (generate_text) обязательные параметры --input_file, --tokens_count, --depth
Пример: python3 'myprogramm.py' generate_text --input_file input.txt  --depth 3 --tokens_count 1000
Прочитает файл с вероятностями input.txt

В папке Texts лежат исходные файлы, а в папке GeneratedTexts файлы сгенерированные из них командами
python3 'myprogramm.py' calculate_probabilities --input_file Texts/GarryPotter.txt  --depth 5 --output_file out.txt
python3 'myprogramm.py' generate_text --input_file out.txt  --depth 5 -t 10000 -o GarryPotterGenerated.txt

