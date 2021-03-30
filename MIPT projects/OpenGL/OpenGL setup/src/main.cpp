#define GLEW_STATIC
#define PI 3.1415
#include <GL/glew.h>

#include <GLFW/glfw3.h>

#include <SOIL.h>

#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtc/type_ptr.hpp>

#include <iostream>

#include "Shader.h"
#include "Texture.h"
#include "Camera.h"
#include "Object.h"
//#include "Matrix.h"

void mouseTurnCamera(GLFWwindow* window);
void keyboardMoveCamera(GLFWwindow* window);
void keyCallback(GLFWwindow* window, int key, int scancode, int action, int mode);


int main()
{
	//инициализация GLFW и GLEW + задание параметров окна
	//_________________________________________________________________________________________________________________________________________

	glfwInit(); 
	if (!glfwInit()) {
		std::cout << "Failed to initialize GLFW" << std::endl;
		return -1;
	}

	//создаём окно
	GLFWwindow* window = glfwCreateWindow(800, 600, "MainWindow", nullptr, nullptr);
	if (window == nullptr) {
		std::cout << "Can't create window" << std::endl;
		glfwTerminate();
		return -1;
	}
	//настраиваем параметры окна
	glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 4);
	glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 4);
	glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
	glfwWindowHint(GLFW_RESIZABLE, GLFW_FALSE);
	int screenWidth, screenHeight;
	glfwGetFramebufferSize(window, &screenWidth, &screenHeight);
	glViewport(0, 0, screenWidth, screenHeight);
	glfwMakeContextCurrent(window);

	glEnable(GL_DEPTH_TEST);
	glEnable(GL_TEXTURE_2D);
	//glEnableClientState(GL_TEXTURE_COORD_ARRAY);

	glewExperimental = GLFW_TRUE;
	if (glewInit() != GLEW_OK) {
		std::cout << "Failed to initialize GLEW" << std::endl;
		return -1;
	}

	//_________________________________________________________________________________________________________________________________________




	//функции для работы с клавиатурой и мышью
	//_________________________________________________________________________________________________________________________________________

	glfwSetInputMode(window, GLFW_CURSOR, GLFW_CURSOR_DISABLED); //чтоб мышь за экран не уползала
	glfwSetKeyCallback(window, keyCallback); //срабатывает от нажатия на клавиатуру
	//_________________________________________________________________________________________________________________________________________




	//задаём начальные положения объектов
	//_________________________________________________________________________________________________________________________________________

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

	GLfloat cubeBlock[] = {
		//позиции				//цвета				//координаты текстуры

		-1.0f, -1.0f,  1.0f,	1.0f, 0.0f, 0.0f,	0.25f, 0.25f, //1
		-1.0f, -1.0f, -1.0f,	0.0f, 1.0f, 0.0f,	0.25f, 0.5f,  //2
		 1.0f, -1.0f, -1.0f,	0.0f, 0.0f, 1.0f,	0.0f,  0.5f,  //3
		-1.0f, -1.0f,  1.0f,	1.0f, 0.0f, 0.0f,	0.25f, 0.25f, //1
		 1.0f, -1.0f,  1.0f,	0.0f, 1.0f, 0.0f,	0.0f,  0.25f, //4
		 1.0f, -1.0f, -1.0f,	0.0f, 0.0f, 1.0f,	0.0f,  0.5f,  //3

		-1.0f, -1.0f,  1.0f,	1.0f, 0.0f, 0.0f,	0.25f, 0.25f, //1
		-1.0f, -1.0f, -1.0f,	0.0f, 1.0f, 0.0f,	0.25f, 0.5f,  //2
		-1.0f,  1.0f, -1.0f,	0.0f, 1.0f, 0.0f,	0.5f,  0.5f,  //6
		-1.0f, -1.0f,  1.0f,	1.0f, 0.0f, 0.0f,	0.25f, 0.25f, //1
		-1.0f,  1.0f,  1.0f,	1.0f, 0.0f, 0.0f,	0.5f,  0.25f, //5
		-1.0f,  1.0f, -1.0f,	0.0f, 1.0f, 0.0f,	0.5f,  0.5f,  //6

		-1.0f, -1.0f,  1.0f,	1.0f, 0.0f, 0.0f,	0.25f, 0.25f, //1
		 1.0f, -1.0f,  1.0f,	0.0f, 1.0f, 0.0f,	0.0f,  0.25f, //4
		 1.0f,  1.0f,  1.0f,	0.0f, 1.0f, 0.0f,	0.0f,  0.0f,  //8
		-1.0f, -1.0f,  1.0f,	1.0f, 0.0f, 0.0f,	0.25f, 0.25f, //1
		-1.0f,  1.0f,  1.0f,	1.0f, 0.0f, 0.0f,	0.25f, 0.0f,  //5
		 1.0f,  1.0f,  1.0f,	0.0f, 1.0f, 0.0f,	0.0f,  0.0f,  //8

		-1.0f, -1.0f, -1.0f,	0.0f, 1.0f, 0.0f,	0.25f, 0.5f,  //2
		 1.0f, -1.0f, -1.0f,	0.0f, 0.0f, 1.0f,	0.0f,  0.5f,  //3
		 1.0f,  1.0f, -1.0f,	0.0f, 0.0f, 1.0f,	0.0f,  0.75f, //7
		-1.0f, -1.0f, -1.0f,	0.0f, 1.0f, 0.0f,	0.25f, 0.5f,  //2
		-1.0f,  1.0f, -1.0f,	0.0f, 1.0f, 0.0f,	0.25f, 0.75f, //6
		 1.0f,  1.0f, -1.0f,	0.0f, 0.0f, 1.0f,	0.0f,  0.75f, //7

		 1.0f, -1.0f,  1.0f,	0.0f, 1.0f, 0.0f,	1.0f,  0.25f, //4
		 1.0f, -1.0f, -1.0f,	0.0f, 0.0f, 1.0f,	1.0f,  0.5f,  //3
		 1.0f,  1.0f, -1.0f,	0.0f, 0.0f, 1.0f,	0.75f, 0.5f,  //7
		 1.0f, -1.0f,  1.0f,	0.0f, 1.0f, 0.0f,	1.0f,  0.25f, //4
		 1.0f,  1.0f,  1.0f,	0.0f, 1.0f, 0.0f,	0.75f, 0.25f, //8
		 1.0f,  1.0f, -1.0f,	0.0f, 0.0f, 1.0f,	0.75f, 0.5f,  //7

		-1.0f,  1.0f,  1.0f,	1.0f, 0.0f, 0.0f,	0.5f,  0.25f, //5
		-1.0f,  1.0f, -1.0f,	0.0f, 1.0f, 0.0f,	0.5f,  0.5f,  //6
		 1.0f,  1.0f, -1.0f,	0.0f, 0.0f, 1.0f,	0.75f, 0.5f,  //7
		-1.0f,  1.0f,  1.0f,	1.0f, 0.0f, 0.0f,	0.5f,  0.25f, //5
		 1.0f,  1.0f,  1.0f,	0.0f, 1.0f, 0.0f,	0.75f, 0.25f, //8
		 1.0f,  1.0f, -1.0f,	0.0f, 0.0f, 1.0f,	0.75f, 0.5f,  //7
	};

	GLfloat lamp[] = {
		//позиции				//цвета				//координаты текстуры

		-1.0f, -1.0f,  1.0f,	1.0f, 1.0f, 1.0f,	0.0f, 0.0f, //1
		-1.0f, -1.0f, -1.0f,	1.0f, 1.0f, 1.0f,	0.0f, 0.0f,  //2
		 1.0f, -1.0f, -1.0f,	1.0f, 1.0f, 1.0f,	0.0f, 0.0f,  //3
		-1.0f, -1.0f,  1.0f,	1.0f, 1.0f, 1.0f,	0.0f, 0.0f, //1
		 1.0f, -1.0f,  1.0f,	1.0f, 1.0f, 1.0f,	0.0f, 0.0f, //4
		 1.0f, -1.0f, -1.0f,	1.0f, 1.0f, 1.0f,	0.0f, 0.0f,  //3

		-1.0f, -1.0f,  1.0f,	1.0f, 1.0f, 1.0f,	0.0f, 0.0f, //1
		-1.0f, -1.0f, -1.0f,	1.0f, 1.0f, 1.0f,	0.0f, 0.0f,  //2
		-1.0f,  1.0f, -1.0f,	1.0f, 1.0f, 1.0f,	0.0f, 0.0f,  //6
		-1.0f, -1.0f,  1.0f,	1.0f, 1.0f, 1.0f,	0.0f, 0.0f, //1
		-1.0f,  1.0f,  1.0f,	1.0f, 1.0f, 1.0f,	0.0f, 0.0f, //5
		-1.0f,  1.0f, -1.0f,	1.0f, 1.0f, 1.0f,	0.0f, 0.0f,  //6

		-1.0f, -1.0f,  1.0f,	1.0f, 1.0f, 1.0f,	0.0f, 0.0f, //1
		 1.0f, -1.0f,  1.0f,	1.0f, 1.0f, 1.0f,	0.0f, 0.0f, //4
		 1.0f,  1.0f,  1.0f,	1.0f, 1.0f, 1.0f,	0.0f, 0.0f,  //8
		-1.0f, -1.0f,  1.0f,	1.0f, 1.0f, 1.0f,	0.0f, 0.0f, //1
		-1.0f,  1.0f,  1.0f,	1.0f, 1.0f, 1.0f,	0.0f, 0.0f,  //5
		 1.0f,  1.0f,  1.0f,	1.0f, 1.0f, 1.0f,	0.0f, 0.0f,  //8

		-1.0f, -1.0f, -1.0f,	1.0f, 1.0f, 1.0f,	0.0f, 0.0f,  //2
		 1.0f, -1.0f, -1.0f,	1.0f, 1.0f, 1.0f,	0.0f, 0.0f,  //3
		 1.0f,  1.0f, -1.0f,	1.0f, 1.0f, 1.0f,	0.0f, 0.0f, //7
		-1.0f, -1.0f, -1.0f,	1.0f, 1.0f, 1.0f,	0.0f, 0.0f,  //2
		-1.0f,  1.0f, -1.0f,	1.0f, 1.0f, 1.0f,	0.0f, 0.0f, //6
		 1.0f,  1.0f, -1.0f,	1.0f, 1.0f, 1.0f,	0.0f, 0.0f, //7

		 1.0f, -1.0f,  1.0f,	1.0f, 1.0f, 1.0f,	0.0f, 0.0f, //4
		 1.0f, -1.0f, -1.0f,	1.0f, 1.0f, 1.0f,	0.0f, 0.0f,  //3
		 1.0f,  1.0f, -1.0f,	1.0f, 1.0f, 1.0f,	0.0f, 0.0f,  //7
		 1.0f, -1.0f,  1.0f,	1.0f, 1.0f, 1.0f,	0.0f, 0.0f, //4
		 1.0f,  1.0f,  1.0f,	1.0f, 1.0f, 1.0f,	0.0f, 0.0f, //8
		 1.0f,  1.0f, -1.0f,	1.0f, 1.0f, 1.0f,	0.0f, 0.0f,  //7

		-1.0f,  1.0f,  1.0f,	1.0f, 1.0f, 1.0f,	0.0f, 0.0f, //5
		-1.0f,  1.0f, -1.0f,	1.0f, 1.0f, 1.0f,	0.0f, 0.0f,  //6
		 1.0f,  1.0f, -1.0f,	1.0f, 1.0f, 1.0f,	0.0f, 0.0f,  //7
		-1.0f,  1.0f,  1.0f,	1.0f, 1.0f, 1.0f,	0.0f, 0.0f, //5
		 1.0f,  1.0f,  1.0f,	1.0f, 1.0f, 1.0f,	0.0f, 0.0f, //8
		 1.0f,  1.0f, -1.0f,	1.0f, 1.0f, 1.0f,	0.0f, 0.0f,  //7
	};

	GLfloat cubeLamp[] = {
		//позиции				//цвета
		-1.0f, -1.0f,  1.0f,	1.0f, 1.0f, 1.0f,
		-1.0f, -1.0f, -1.0f,	1.0f, 1.0f, 1.0f,
		 1.0f, -1.0f, -1.0f,	1.0f, 1.0f, 1.0f,
		 1.0f, -1.0f,  1.0f,	1.0f, 1.0f, 1.0f,
		-1.0f,  1.0f,  1.0f,	1.0f, 1.0f, 1.0f,
		-1.0f,  1.0f, -1.0f,	1.0f, 1.0f, 1.0f,
		 1.0f,  1.0f, -1.0f,	1.0f, 1.0f, 1.0f,
		 1.0f,  1.0f,  1.0f,	1.0f, 1.0f, 1.0f
	};

	GLuint cubeLampIndexes[] = {
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

	//задаём позиции фигур
	glm::vec3 cubePositions[] = {
	  glm::vec3(0.0f,  0.0f,  0.0f),
	  glm::vec3(1.0f,  0.0f,  0.0f),
	  glm::vec3(0.0f,  1.0f,  0.0f),
	  glm::vec3(0.0f,  0.0f,  1.0f),
	  /*glm::vec3(2.0f,  5.0f, -15.0f),
	  glm::vec3(-1.5f, -2.2f, -2.5f),
	  glm::vec3(-3.8f, -2.0f, -12.3f),
	  glm::vec3(2.4f, -0.4f, -3.5f),
	  glm::vec3(-1.7f,  3.0f, -7.5f),
	  glm::vec3(1.3f, -2.0f, -2.5f),
	  glm::vec3(1.5f,  2.0f, -2.5f),
	  glm::vec3(1.5f,  0.2f, -1.5f),
	  glm::vec3(-1.3f,  1.0f, -1.5f)*/
	};

	//_________________________________________________________________________________________________________________________________________



	//создаём VBO, EBO и сохраняем настройки в VAO
	//_________________________________________________________________________________________________________________________________________

	

	/*
	//VAO и VBO для блоков
	GLuint blockVBO; //вершинный буфер
	glGenBuffers(1, &blockVBO);

	GLuint blockVAO;
	glGenVertexArrays(1, &blockVAO);
	glBindVertexArray(blockVAO);

	glBindBuffer(GL_ARRAY_BUFFER, blockVBO);
	glBufferData(GL_ARRAY_BUFFER, sizeof(cubeBlock), cubeBlock, GL_STATIC_DRAW);

	//glVertexAttribPointer:
	//1 - позиция в вершинном шейдере (layout)
	//2 - кол-во передаваемых значений (напрмер 3 координаты)
	//3 - тип передаваемых значений
	//4 - нужно ли нормаллизовать значения (принимает тип bool)
	//5 - шаг (расстояние между наборами данных)
	//6 - сдвиг (смещение начала данных в буфере)

	//позиция
	glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 8 * sizeof(GLfloat), (GLvoid*)(0 * sizeof(GLfloat)));
	glEnableVertexAttribArray(0);

	//цвет
	glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 8 * sizeof(GLfloat), (GLvoid*)(3 * sizeof(GLfloat)));
	glEnableVertexAttribArray(1);

	//координаты на текстуре
	glVertexAttribPointer(2, 2, GL_FLOAT, GL_FALSE, 8 * sizeof(GLfloat), (GLvoid*)(6 * sizeof(GLfloat)));
	glEnableVertexAttribArray(2);

	glBindVertexArray(0);
	*/


	//VAO, VBO и EBO для источников света
	GLuint lightVBO;
	glGenBuffers(1, &lightVBO);

	GLuint lightEBO; //буфер для индексов вершин
	glGenBuffers(1, &lightEBO);

	GLuint lightVAO;
	glGenVertexArrays(1, &lightVAO);
	glBindVertexArray(lightVAO);

	glBindBuffer(GL_ARRAY_BUFFER, lightVBO);
	glBufferData(GL_ARRAY_BUFFER, sizeof(cubeLamp), cubeLamp, GL_STATIC_DRAW);

	glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, lightEBO);
	glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(cubeLampIndexes), cubeLampIndexes, GL_STATIC_DRAW);

	glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(GLfloat), (void*)(0 * sizeof(GLfloat)));
	glEnableVertexAttribArray(0);

	glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(GLfloat), (void*)(3 * sizeof(GLfloat)));
	glEnableVertexAttribArray(1);

	glBindVertexArray(0);
	
	//_________________________________________________________________________________________________________________________________________



	//создаём шейдеры
	Shader blockShaders("src/Shaders/blockVertexShader.txt", "src/Shaders/blockFragmentShader.txt");
	Shader lightingSourceShaders("src/Shaders/lightingSourceVertexShader.txt", "src/Shaders/lightingSourceFragmentShader.txt");

	//создаём тестуры
	Texture minecraftGrassTexture("res/grass.png", GL_TEXTURE0);
	//todo: хранить текстуры в dds формате и прогружатьвсе мипмапы до начала работы кода, чтобы работало всё быстрее
	
	glm::vec3 camPos(-10.0f, 0.0f, 0.0f);
	glm::vec3 camDir(1.0f, 0.0f, 0.0f);
	glm::vec3 camUp(0.0f, 1.0f, 0.0f);

	Camera mainCam(window, camPos, camDir, camUp);

	glm::mat4 model(1.0f), view(1.0f), projection;
	projection = glm::perspective(100.0f, (float)screenWidth / screenHeight, 0.1f, 100.0f);

	GLfloat deltaTime = 0.0f; //время прогрузки 1 кадра
	GLfloat lastFrame = glfwGetTime(); //чтоб не было рывков в начале

	Object grassBlock(window, sizeof(cubeBlock), cubeBlock, blockShaders, minecraftGrassTexture);
	//Object lampBlock(window, sizeof(cubeLamp), cubeLamp, sizeof(cubeLampIndexes), cubeLampIndexes, lightingSourceShaders, minecraftGrassTexture);
	Object lampBlock(window, sizeof(lamp), lamp, blockShaders, minecraftGrassTexture);
	while (!glfwWindowShouldClose(window)) {
		deltaTime = glfwGetTime() - lastFrame;
		lastFrame = glfwGetTime();

		glfwPollEvents();
		mainCam.keyboardMoveMinecraftCamera(deltaTime);
		mainCam.mouseTurnCamera(deltaTime);

		//отрисовка
		glClearColor(0.5f, 0.5f, 0.5f, 0.0f);
		glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

		
		//рисуем источник света
		/*
		lightingSourceShaders.use();
		glBindVertexArray(lightVAO);
		model = glm::scale(glm::mat4(1.0f), glm::vec3(0.5f, 0.5f, 0.5f)); //можно сильно ускорить программу если не просчитывать все подобные матрицы в цикле
		view = glm::lookAt(mainCam.getPos(), mainCam.getPos() + mainCam.getDir(), mainCam.getUp());
		view = glm::translate(view, glm::vec3(0.0f, -3.0f, 0.0f));
		glUniformMatrix4fv(glGetUniformLocation(lightingSourceShaders.getShaderProgramId(), "model"), 1, GL_FALSE, glm::value_ptr(model));
		glUniformMatrix4fv(glGetUniformLocation(lightingSourceShaders.getShaderProgramId(), "view"), 1, GL_FALSE, glm::value_ptr(view));
		glUniformMatrix4fv(glGetUniformLocation(lightingSourceShaders.getShaderProgramId(), "projection"), 1, GL_FALSE, glm::value_ptr(projection));
		glDrawElements(GL_TRIANGLES, 36, GL_UNSIGNED_INT, 0);
		glBindVertexArray(0);

		
		//рисуем блоки
		blockShaders.use();
		minecraftGrassTexture.use();
		glBindVertexArray(blockVAO);
		for (GLint i = 0; i < 4; ++i) {
			model = glm::scale(glm::mat4(1.0f), glm::vec3(0.5f, 0.5f, 0.5f));//приводит куб к размеру 1x1x1
			model = glm::rotate(model, (float)PI, glm::vec3(0.0f, 0.0f, 1.0f));//переворачивает куб чтобы верх был сверху
			view = glm::lookAt(mainCam.getPos(), mainCam.getPos() + mainCam.getDir(), mainCam.getUp());
			view = glm::translate(view, cubePositions[i]);
			
			glUniformMatrix4fv(glGetUniformLocation(blockShaders.getShaderProgramId(), "model"), 1, GL_FALSE, glm::value_ptr(model));
			glUniformMatrix4fv(glGetUniformLocation(blockShaders.getShaderProgramId(), "view"), 1, GL_FALSE, glm::value_ptr(view));
			glUniformMatrix4fv(glGetUniformLocation(blockShaders.getShaderProgramId(), "projection"), 1, GL_FALSE, glm::value_ptr(projection));
			glUniform1i(glGetUniformLocation(blockShaders.getShaderProgramId(), "curTexture"), 0);
			glDrawArrays(GL_TRIANGLES, 0, 36);
		}
		glBindVertexArray(0);
		*/
		grassBlock.setOrientation(PI, glm::vec3(0.0f, 0.0f, 1.0f));
		grassBlock.scale(2, glm::vec3(1.0f));
		grassBlock.draw(GL_TRIANGLES, 36, glm::vec3(4.0f, 4.0f, 4.0f), mainCam);

		lampBlock.draw(GL_TRIANGLES, 36, glm::vec3(0.0f), mainCam);
		
		glfwSwapBuffers(window);
	}
	glfwTerminate();
	minecraftGrassTexture.deleteTexture();
	return 0;
}




void keyCallback(GLFWwindow* window, int key, int scancode, int action, int mode) {
	if (key == GLFW_KEY_ESCAPE && action == GLFW_PRESS) {
		glfwSetWindowShouldClose(window, GLFW_TRUE);
	}
}