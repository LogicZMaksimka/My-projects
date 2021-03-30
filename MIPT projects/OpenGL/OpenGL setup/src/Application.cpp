#define GLEW_STATIC
#define PI 3.14159265359
#include <GL/glew.h>

#include <GLFW/glfw3.h>

#include <SOIL.h>

#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtc/type_ptr.hpp>

#include <iostream>
using namespace std;

#include "Shader.h"
//#include "Matrix.h"

void keyCallback(GLFWwindow* window, int key, int scancode, int action, int mode);


int main()
{
	
	//ВАЖНО!!!!!!										В А Ж Н О
	//матрицы и векторы возможно вовсе не нужно совмещать (только из-за 1 перегруженного оператора) поэтому стоит разнести эти 2 класса в разные файлы
	double arr1[] = {
		4, 2, 0,
		0, 8, 1,
		0, 1, 0
	};
	double arr2[] = {
		4, 2, 1,
		2, 0 ,4,
		9, 4, 2
	};

	

	glfwInit(); //инициализация GLFW
	if (!glfwInit()) {
		cout<< "Failed to initialize GLFW" << endl;
		return -1;
	}
	
	//первым аргументом необходимо передать идентификатор параметра, который подвергается изменению,
	//а вторым параметром передается значение

	//Задается минимальная требуемая версия OpenGL
	glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 4);
	glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 4);
	//Установка профайла для которого создается контекст
	glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE); //CORE_PROFILE - для хардкорной проги
	//Выключение возможности изменения размера окна
	glfwWindowHint(GLFW_RESIZABLE, GLFW_FALSE);
	
	GLFWwindow* window = glfwCreateWindow(800, 600, "MainWindow", nullptr, nullptr);
	if (window == nullptr) {
		cout << "Can't create window" << endl;
		glfwTerminate(); //удаление окна, очищение ресурсов
		return -1;
	}

	//создаём контекст окна, т.е. даём библиотеке понять, что вся отрисовка будет производиться именно в этом окне
	glfwMakeContextCurrent(window);

	//чтобы начать что-то рисовать и дожить до момента когда что-то заработае
	// нужно упростить себе жизнь и воспользоваться библиотекой GLEW чтобы по-человечески обращаться к функциям GLFW

	//настраивам GLEW
	glewExperimental = GLFW_TRUE; //позволяет GLEW использовать новейшие техники для управления функционалом OpenGL
	if (glewInit() != GLEW_OK) {
		cout << "Failed to initialize GLEW" << endl;
		return -1;
	}

	//сообщаем openGL координаты отрисовываемого окна
	int screenWidth, screenHeight; //GLsizei width, height;
	//получаем размеры окна в px
	glfwGetFramebufferSize(window, &screenWidth, &screenHeight);
	//сообщаем координаты левого нижнего края, высоту и длинну окна
	glViewport(0, 0, screenWidth, screenHeight);
	//Также мы можем задать меньшие значения для viewport
	//В таком случае, вся отрисовываемая информация будет меньших размеров
	//Мы сможем, к примеру, отрисовывать другую часть приложения вне viewport

	//передаём glfw функцию закрытия окна по нажатию на клавишу esc
	glfwSetKeyCallback(window, keyCallback);

	
	//позиция в пространстве - это 3 числа типа float от -1.0 до 1.0
	GLfloat triangle[] = {
	0.0f, 0.5f, 0.0f,
	-0.5f, -0.5f, 0.0f,
	0.5f, -0.5f, 0.0f
	};

	GLfloat square[] = {
		 //позиции				//цвета				 //координаты текстуры
		 1.0f,  1.0f, 0.0f,		1.0f, 0.0f, 0.0f,	 1.0f, 1.0f,
		 1.0f, -1.0f, 0.0f,		0.0f, 1.0f, 0.0f,	 1.0f, 0.0f,
		-1.0f, -1.0f, 0.0f,		0.0f, 0.0f, 1.0f,	 0.0f, 0.0f,
		-1.0f,  1.0f, 0.0f,		0.0f, 1.0f, 0.0f,	 0.0f, 1.0f
	};

	GLuint squareIndexes[] = {
		3, 0, 1,
		3, 2, 1
	};

	GLfloat cube[] = {
		//позиции				//цвета				//координаты текстуры
		-1.0f, -1.0f,  1.0f,	1.0f, 0.0f, 0.0f,	0.25f, 0.25f,
		-1.0f, -1.0f, -1.0f,	0.0f, 1.0f, 0.0f,	0.25f, 0.5f,
		 1.0f, -1.0f, -1.0f,	0.0f, 0.0f, 1.0f,	1.0f,  0.5f,
		 1.0f, -1.0f,  1.0f,	0.0f, 1.0f, 0.0f,	1.0f,  0.25f,
		-1.0f,  1.0f,  1.0f,	1.0f, 0.0f, 0.0f,	0.5f,  0.25f,
		-1.0f,  1.0f, -1.0f,	0.0f, 1.0f, 0.0f,	0.5f,  0.5f,
		 1.0f,  1.0f, -1.0f,	0.0f, 0.0f, 1.0f,	0.75f, 0.5f,
		 1.0f,  1.0f,  1.0f,	0.0f, 1.0f, 0.0f,	0.75f, 0.25f,
	};

	GLuint cubeIndexes[] = {
		0, 1, 2,
		0, 3, 2,

		3, 2, 6,
		3, 7, 6,

		0, 4, 7,
		0, 3, 7,

		0, 1, 5,
		0, 4, 5,

		4, 5, 6,
		4, 7, 6,

		1, 5, 6,
		1, 2, 6
	};

	glm::vec3 cubePositions[] = {
	  glm::vec3(0.0f,  0.0f,  0.0f),
	  glm::vec3(2.0f,  5.0f, -15.0f),
	  glm::vec3(-1.5f, -2.2f, -2.5f),
	  glm::vec3(-3.8f, -2.0f, -12.3f),
	  glm::vec3(2.4f, -0.4f, -3.5f),
	  glm::vec3(-1.7f,  3.0f, -7.5f),
	  glm::vec3(1.3f, -2.0f, -2.5f),
	  glm::vec3(1.5f,  2.0f, -2.5f),
	  glm::vec3(1.5f,  0.2f, -1.5f),
	  glm::vec3(-1.3f,  1.0f, -1.5f)
	};
	/*Мы управляем этой памятью через, так называемые, объекты вершинного буфера(vertex buffer objects(VBO)),
	которые могут хранить большое количество вершин в памяти GPU.Преимущество использования таких объектов буфера,
	что мы можем посылать в видеокарту большое количество наборов данных за один раз,
	без необходимости отправлять по одной вершине за раз.Отправка данных с CPU на GPU довольно медленная,
	поэтому мы будем стараться отправлять как можно большое данных за один раз.
	Но как только данные окажутся в GPU, вершинный шейдер получит их практически мгновенно.*/

	//создаём VBO с помощью функции glGenBuffers
	GLuint VBO;
	glGenBuffers(1, &VBO);

	GLuint EBO;
	glGenBuffers(1, &EBO);
	

	/*У OpenGL есть большое количество различных типов объектов буферов.
	Тип VBO — GL_ARRAY_BUFFER. OpenGL позволяет привязывать множество буферов,
	если у них разные типы. Мы можем привязать GL_ARRAY_BUFFER к нашему буферу с помощью glBindBuffer.
	Условно можно создать 100 буферов (GLuint VBO;	glGenBuffers(1, &VBO);) и каждый задать как буфер GL_ARRAY_BUFFER
	(тоесть тот, который будет по порядку отрисовывать каждую вершину)*/
	//glBindBuffer(GL_ARRAY_BUFFER, VBO);

	//С этого момента любой вызов, использующий буфер, будет работать с VBO

	/*glBufferData это функция, цель которой — копирование данных пользователя в указанный буфер.
	Первый ее аргумент — это тип буфера в который мы хотим скопировать данные(наш VBO сейчас привязан к GL_ARRAY_BUFFER).
	Второй аргумент определяет количество данных(в байтах), которые мы хотим передать буферу.
	Третий аргумент — это сами данные.
	Четвертый аргумент определяет как мы хотим чтобы видеокарта работала с переданными ей данными.

	Существует 3 режима:
	GL_STATIC_DRAW: данные либо никогда не будут изменяться, либо будут изменяться очень редко;
	GL_DYNAMIC_DRAW: данные будут меняться довольно часто;
	GL_STREAM_DRAW: данные будут меняться при каждой отрисовке.*/

	//копируем вершинные данные в буфер VBO
	//glBufferData(GL_ARRAY_BUFFER, sizeof(triangle), triangle, GL_STATIC_DRAW);


	//создаём шейдеры
	Shader shaders(
		"C:/Users/user/Saved Games/Desktop/Максимилиан/VisualStudio Graphycal Progects/Trying to install OpenGL/Trying to install OpenGL/OpenGL setup/OpenGL setup/src/vertexShaderCode.txt",
		"C:/Users/user/Saved Games/Desktop/Максимилиан/VisualStudio Graphycal Progects/Trying to install OpenGL/Trying to install OpenGL/OpenGL setup/OpenGL setup/src/fragmentShaderCode.txt"
	);

	//											Vertex Array Object

	/*
	Объект вершинного массива (VAO) может быть также привязан как и VBO и после этого все последующие вызовы вершинных атрибутов будут храниться в VAO.
	Преимущество этого метода в том, что нам требуется настроить атрибуты лишь единожды, а все последующие разы будет использована конфигурация VAO.
	Также такой метод упрощает смену вершинных данных и конфигураций атрибутов простым привязыванием различных VAO.
	*/

	/*
	VAO хранит следующие вызовы:

	Вызовы glEnableVertexAttribArray или glDisableVertexAttribArray.
	Конфигурация атрибутов, выполненная через glVertexAttribPointer.
	VBO ассоциированные с вершинными атрибутами с помощью glVertexAttribPointer
	*/

	//вместо того чтобы каждый раз писать триллион строк кода для отрисовки чего-либо,
	//мы просто привязываем VAO с нужными настройками

	//создаём VAO
	GLuint VAO;
	glGenVertexArrays(1, &VAO);

	glBindVertexArray(VAO);
	// 2. Копируем наши вершины в буфер для OpenGL
	glBindBuffer(GL_ARRAY_BUFFER, VBO);
	glBufferData(GL_ARRAY_BUFFER, sizeof(cube), cube, GL_STATIC_DRAW);
	// 3. Копируем наши индексы в в буфер для OpenGL
	glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, EBO);
	glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(cubeIndexes), cubeIndexes, GL_STATIC_DRAW);
	// 3. Устанавливаем указатели на вершинные атрибуты
	
	//позиция
	glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 8 * sizeof(GLfloat), (GLvoid*)(0 * sizeof(GLfloat)));
	glEnableVertexAttribArray(0);

	//цвет
	glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 8 * sizeof(GLfloat), (GLvoid*)(3 * sizeof(GLfloat)));
	glEnableVertexAttribArray(1);

	//координаты на текстуре
	glVertexAttribPointer(2, 2, GL_FLOAT, GL_FALSE, 8 * sizeof(GLfloat), (GLvoid*)(6 * sizeof(GLfloat)));
	glEnableVertexAttribArray(2);

	// 4. Отвязываем VAO (НЕ EBO)
	glBindVertexArray(0);
	//В OpenGL отвязывание объектов это обычное дело.Как минимум просто для того, чтобы случайно не испортить конфигурацию.
	//ну что полегчало? нет? и что? треугольник рисуй!!!!!!!!!!!!!
	
	/*
	Зачастую, когда у нас есть множественные объекты для отрисовки мы в начале генерируем и конфигурируем VAO и сохраняем их для последующего использования.
	И когда надо будет отрисовать один из наших объектов мы просто используем сохраненный VAO.
	*/

	//											Element Buffer Object - отрисовка по индексам
	//задаются только нужные вершины, но т.к. openGl нормально отрисовывает только треугольники
	//требуется задать порядок в котором эти вершины будут отрисованны
	//EBO — это буфер, вроде VBO, но он хранит индексы, которые OpenGL использует, чтобы решить какую вершину отрисовать
	//поэтому в начале указываются только уникальные вершины

	//ура, теперь нужно скачать текстуры
	int imageWidth, imageHeight;
	unsigned char* image = SOIL_load_image(
		"C:/Users/user/Saved Games/Desktop/Максимилиан/VisualStudio Graphycal Progects/Trying to install OpenGL/Trying to install OpenGL/OpenGL setup/OpenGL setup/res/grass.png",
		&imageWidth, &imageHeight, 0, SOIL_LOAD_RGB
	);

	//создаём текстуру
	GLuint texture;
	//1 аргумент - кол-во текстур, второй - указатель на массив текстур
	glGenTextures(1, &texture);
	//пишем что это за текстура
	
	//привязываем текстуру и её изображение
	glBindTexture(GL_TEXTURE_2D, texture);
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, imageWidth, imageHeight, 0, GL_RGB, GL_UNSIGNED_BYTE, image);
	//генерируем мипмапы
	glGenerateMipmap(GL_TEXTURE_2D);
	
	//освобождаем память
	//отвязываем объект текстуры
	SOIL_free_image_data(image);
	glBindTexture(GL_TEXTURE_2D, 0);

	glEnable(GL_DEPTH_TEST);//включаем проверку глубины

	glm::mat4 model(1.0f), view(1.0f), projection(1.0f);
	
	projection = glm::perspective(100.0f, (float)screenWidth / screenHeight, 0.1f, 100.0f);

	//создаём игровой цикл
	//обрабатываем изображения до тех пор пока окно не закрыто
	while (!glfwWindowShouldClose(window)) {

		//glfwPollEvents проверяет были ли вызваны какие либо события (вроде ввода с клавиатуры или перемещение мыши)
		//и вызывает установленные функции (которые мы можем установить через функции обратного вызова (glfwSetKeyCallback))
		glfwPollEvents();



		//отрисовка
		glClearColor(0.5f, 0.0f, 0.4f, 0.1f); //нафиг всё стираем
		glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

		glBindTexture(GL_TEXTURE_2D, texture);

		
		
		shaders.use();

		//вот так выглядит код для использования 2-x и более текстур в шейдере
		/*
		glActiveTexture(GL_TEXTURE0);
		glBindTexture(GL_TEXTURE_2D, texture1);
		glUniform1i(glGetUniformLocation(shaders.getShaderProgramId(), "ourTexture1"), 0);
		glActiveTexture(GL_TEXTURE1);
		glBindTexture(GL_TEXTURE_2D, texture2);
		glUniform1i(glGetUniformLocation(shaders.getShaderProgramId(), "ourTexture2"), 1);
		*/

		
		//view = glm::translate(view, glm::vec3(0.0f, 0.0f, sin(glfwGetTime()) / -1000.0f));


		
		glUniformMatrix4fv(glGetUniformLocation(shaders.getShaderProgramId(), "projection"), 1, GL_FALSE, glm::value_ptr(projection));
		glUniform3f(glGetUniformLocation(shaders.getShaderProgramId(), "myColor"), (sin(glfwGetTime()) + 1) / 2.0f, 1.0, (cos(glfwGetTime()) + 1) / 2.0f);

		glBindVertexArray(VAO);
		for (GLint i = 0; i < 10; ++i) {
			model = glm::scale(glm::mat4(1.0f), glm::vec3(0.5f, 0.5f, 0.5f));
			if (i % 3) model = glm::rotate(model, (float)sin(glfwGetTime()) * 2.0f, glm::vec3(1.0f, 1.0f, 0.0f));
			view = glm::translate(glm::mat4(1.0f), glm::vec3(0.0f, 0.0f, -10.0f));
			view = glm::translate(view, cubePositions[i]);
			glUniformMatrix4fv(glGetUniformLocation(shaders.getShaderProgramId(), "model"), 1, GL_FALSE, glm::value_ptr(model));
			glUniformMatrix4fv(glGetUniformLocation(shaders.getShaderProgramId(), "view"), 1, GL_FALSE, glm::value_ptr(view));
			glDrawElements(GL_TRIANGLES, 36, GL_UNSIGNED_INT, 0);
		}
		glBindVertexArray(0);

		//меняем цветовой буфер, чтобы не было проблем из-за немгновенной попиксельной отрисовки
		//пока передний буфер показывается пользователю, на задний ведётся отрисовка
		glfwSwapBuffers(window);
	}

	glfwTerminate();
	return 0;
}


void keyCallback(GLFWwindow* window, int key, int scancode, int action, int mode) {
	if (key == GLFW_KEY_ESCAPE && action == GLFW_PRESS) {
		glfwSetWindowShouldClose(window, GLFW_TRUE);
	}
}
