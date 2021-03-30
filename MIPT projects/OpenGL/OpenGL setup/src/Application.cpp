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
	
	//�����!!!!!!										� � � � �
	//������� � ������� �������� ����� �� ����� ��������� (������ ��-�� 1 �������������� ���������) ������� ����� �������� ��� 2 ������ � ������ �����
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

	

	glfwInit(); //������������� GLFW
	if (!glfwInit()) {
		cout<< "Failed to initialize GLFW" << endl;
		return -1;
	}
	
	//������ ���������� ���������� �������� ������������� ���������, ������� ������������ ���������,
	//� ������ ���������� ���������� ��������

	//�������� ����������� ��������� ������ OpenGL
	glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 4);
	glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 4);
	//��������� �������� ��� �������� ��������� ��������
	glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE); //CORE_PROFILE - ��� ���������� �����
	//���������� ����������� ��������� ������� ����
	glfwWindowHint(GLFW_RESIZABLE, GLFW_FALSE);
	
	GLFWwindow* window = glfwCreateWindow(800, 600, "MainWindow", nullptr, nullptr);
	if (window == nullptr) {
		cout << "Can't create window" << endl;
		glfwTerminate(); //�������� ����, �������� ��������
		return -1;
	}

	//������ �������� ����, �.�. ��� ���������� ������, ��� ��� ��������� ����� ������������� ������ � ���� ����
	glfwMakeContextCurrent(window);

	//����� ������ ���-�� �������� � ������ �� ������� ����� ���-�� ���������
	// ����� ��������� ���� ����� � ��������������� ����������� GLEW ����� ��-����������� ���������� � �������� GLFW

	//���������� GLEW
	glewExperimental = GLFW_TRUE; //��������� GLEW ������������ �������� ������� ��� ���������� ������������ OpenGL
	if (glewInit() != GLEW_OK) {
		cout << "Failed to initialize GLEW" << endl;
		return -1;
	}

	//�������� openGL ���������� ��������������� ����
	int screenWidth, screenHeight; //GLsizei width, height;
	//�������� ������� ���� � px
	glfwGetFramebufferSize(window, &screenWidth, &screenHeight);
	//�������� ���������� ������ ������� ����, ������ � ������ ����
	glViewport(0, 0, screenWidth, screenHeight);
	//����� �� ����� ������ ������� �������� ��� viewport
	//� ����� ������, ��� �������������� ���������� ����� ������� ��������
	//�� ������, � �������, ������������ ������ ����� ���������� ��� viewport

	//������� glfw ������� �������� ���� �� ������� �� ������� esc
	glfwSetKeyCallback(window, keyCallback);

	
	//������� � ������������ - ��� 3 ����� ���� float �� -1.0 �� 1.0
	GLfloat triangle[] = {
	0.0f, 0.5f, 0.0f,
	-0.5f, -0.5f, 0.0f,
	0.5f, -0.5f, 0.0f
	};

	GLfloat square[] = {
		 //�������				//�����				 //���������� ��������
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
		//�������				//�����				//���������� ��������
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
	/*�� ��������� ���� ������� �����, ��� ����������, ������� ���������� ������(vertex buffer objects(VBO)),
	������� ����� ������� ������� ���������� ������ � ������ GPU.������������ ������������� ����� �������� ������,
	��� �� ����� �������� � ���������� ������� ���������� ������� ������ �� ���� ���,
	��� ������������� ���������� �� ����� ������� �� ���.�������� ������ � CPU �� GPU �������� ���������,
	������� �� ����� ��������� ���������� ��� ����� ������� ������ �� ���� ���.
	�� ��� ������ ������ �������� � GPU, ��������� ������ ������� �� ����������� ���������.*/

	//������ VBO � ������� ������� glGenBuffers
	GLuint VBO;
	glGenBuffers(1, &VBO);

	GLuint EBO;
	glGenBuffers(1, &EBO);
	

	/*� OpenGL ���� ������� ���������� ��������� ����� �������� �������.
	��� VBO � GL_ARRAY_BUFFER. OpenGL ��������� ����������� ��������� �������,
	���� � ��� ������ ����. �� ����� ��������� GL_ARRAY_BUFFER � ������ ������ � ������� glBindBuffer.
	������� ����� ������� 100 ������� (GLuint VBO;	glGenBuffers(1, &VBO);) � ������ ������ ��� ����� GL_ARRAY_BUFFER
	(������ ���, ������� ����� �� ������� ������������ ������ �������)*/
	//glBindBuffer(GL_ARRAY_BUFFER, VBO);

	//� ����� ������� ����� �����, ������������ �����, ����� �������� � VBO

	/*glBufferData ��� �������, ���� ������� � ����������� ������ ������������ � ��������� �����.
	������ �� �������� � ��� ��� ������ � ������� �� ����� ����������� ������(��� VBO ������ �������� � GL_ARRAY_BUFFER).
	������ �������� ���������� ���������� ������(� ������), ������� �� ����� �������� ������.
	������ �������� � ��� ���� ������.
	��������� �������� ���������� ��� �� ����� ����� ���������� �������� � ����������� �� �������.

	���������� 3 ������:
	GL_STATIC_DRAW: ������ ���� ������� �� ����� ����������, ���� ����� ���������� ����� �����;
	GL_DYNAMIC_DRAW: ������ ����� �������� �������� �����;
	GL_STREAM_DRAW: ������ ����� �������� ��� ������ ���������.*/

	//�������� ��������� ������ � ����� VBO
	//glBufferData(GL_ARRAY_BUFFER, sizeof(triangle), triangle, GL_STATIC_DRAW);


	//������ �������
	Shader shaders(
		"C:/Users/user/Saved Games/Desktop/�����������/VisualStudio Graphycal Progects/Trying to install OpenGL/Trying to install OpenGL/OpenGL setup/OpenGL setup/src/vertexShaderCode.txt",
		"C:/Users/user/Saved Games/Desktop/�����������/VisualStudio Graphycal Progects/Trying to install OpenGL/Trying to install OpenGL/OpenGL setup/OpenGL setup/src/fragmentShaderCode.txt"
	);

	//											Vertex Array Object

	/*
	������ ���������� ������� (VAO) ����� ���� ����� �������� ��� � VBO � ����� ����� ��� ����������� ������ ��������� ��������� ����� ��������� � VAO.
	������������ ����� ������ � ���, ��� ��� ��������� ��������� �������� ���� ��������, � ��� ����������� ���� ����� ������������ ������������ VAO.
	����� ����� ����� �������� ����� ��������� ������ � ������������ ��������� ������� ������������� ��������� VAO.
	*/

	/*
	VAO ������ ��������� ������:

	������ glEnableVertexAttribArray ��� glDisableVertexAttribArray.
	������������ ���������, ����������� ����� glVertexAttribPointer.
	VBO ��������������� � ���������� ���������� � ������� glVertexAttribPointer
	*/

	//������ ���� ����� ������ ��� ������ �������� ����� ���� ��� ��������� ����-����,
	//�� ������ ����������� VAO � ������� �����������

	//������ VAO
	GLuint VAO;
	glGenVertexArrays(1, &VAO);

	glBindVertexArray(VAO);
	// 2. �������� ���� ������� � ����� ��� OpenGL
	glBindBuffer(GL_ARRAY_BUFFER, VBO);
	glBufferData(GL_ARRAY_BUFFER, sizeof(cube), cube, GL_STATIC_DRAW);
	// 3. �������� ���� ������� � � ����� ��� OpenGL
	glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, EBO);
	glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(cubeIndexes), cubeIndexes, GL_STATIC_DRAW);
	// 3. ������������� ��������� �� ��������� ��������
	
	//�������
	glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 8 * sizeof(GLfloat), (GLvoid*)(0 * sizeof(GLfloat)));
	glEnableVertexAttribArray(0);

	//����
	glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 8 * sizeof(GLfloat), (GLvoid*)(3 * sizeof(GLfloat)));
	glEnableVertexAttribArray(1);

	//���������� �� ��������
	glVertexAttribPointer(2, 2, GL_FLOAT, GL_FALSE, 8 * sizeof(GLfloat), (GLvoid*)(6 * sizeof(GLfloat)));
	glEnableVertexAttribArray(2);

	// 4. ���������� VAO (�� EBO)
	glBindVertexArray(0);
	//� OpenGL ����������� �������� ��� ������� ����.��� ������� ������ ��� ����, ����� �������� �� ��������� ������������.
	//�� ��� ���������? ���? � ���? ����������� �����!!!!!!!!!!!!!
	
	/*
	��������, ����� � ��� ���� ������������� ������� ��� ��������� �� � ������ ���������� � ������������� VAO � ��������� �� ��� ������������ �������������.
	� ����� ���� ����� ���������� ���� �� ����� �������� �� ������ ���������� ����������� VAO.
	*/

	//											Element Buffer Object - ��������� �� ��������
	//�������� ������ ������ �������, �� �.�. openGl ��������� ������������ ������ ������������
	//��������� ������ ������� � ������� ��� ������� ����� �����������
	//EBO � ��� �����, ����� VBO, �� �� ������ �������, ������� OpenGL ����������, ����� ������ ����� ������� ����������
	//������� � ������ ����������� ������ ���������� �������

	//���, ������ ����� ������� ��������
	int imageWidth, imageHeight;
	unsigned char* image = SOIL_load_image(
		"C:/Users/user/Saved Games/Desktop/�����������/VisualStudio Graphycal Progects/Trying to install OpenGL/Trying to install OpenGL/OpenGL setup/OpenGL setup/res/grass.png",
		&imageWidth, &imageHeight, 0, SOIL_LOAD_RGB
	);

	//������ ��������
	GLuint texture;
	//1 �������� - ���-�� �������, ������ - ��������� �� ������ �������
	glGenTextures(1, &texture);
	//����� ��� ��� �� ��������
	
	//����������� �������� � � �����������
	glBindTexture(GL_TEXTURE_2D, texture);
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, imageWidth, imageHeight, 0, GL_RGB, GL_UNSIGNED_BYTE, image);
	//���������� �������
	glGenerateMipmap(GL_TEXTURE_2D);
	
	//����������� ������
	//���������� ������ ��������
	SOIL_free_image_data(image);
	glBindTexture(GL_TEXTURE_2D, 0);

	glEnable(GL_DEPTH_TEST);//�������� �������� �������

	glm::mat4 model(1.0f), view(1.0f), projection(1.0f);
	
	projection = glm::perspective(100.0f, (float)screenWidth / screenHeight, 0.1f, 100.0f);

	//������ ������� ����
	//������������ ����������� �� ��� ��� ���� ���� �� �������
	while (!glfwWindowShouldClose(window)) {

		//glfwPollEvents ��������� ���� �� ������� ����� ���� ������� (����� ����� � ���������� ��� ����������� ����)
		//� �������� ������������� ������� (������� �� ����� ���������� ����� ������� ��������� ������ (glfwSetKeyCallback))
		glfwPollEvents();



		//���������
		glClearColor(0.5f, 0.0f, 0.4f, 0.1f); //����� �� �������
		glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

		glBindTexture(GL_TEXTURE_2D, texture);

		
		
		shaders.use();

		//��� ��� �������� ��� ��� ������������� 2-x � ����� ������� � �������
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

		//������ �������� �����, ����� �� ���� ������� ��-�� ������������ ������������ ���������
		//���� �������� ����� ������������ ������������, �� ������ ������ ���������
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
