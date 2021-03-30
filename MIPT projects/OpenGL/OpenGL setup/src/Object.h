#pragma once

#include <GL/glew.h>

#include <GLFW/glfw3.h>

#include <SOIL.h>

#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtc/type_ptr.hpp>

#include "Texture.h"
#include "Shader.h"
#include "Camera.h"


//Класс Object
//неизменяемые параметры
//		- файлы с вершинными и фрагментным шейдером
//		- цвет каждой вершины
//		- текстура
//		- форма объекта

//последние 3 параметра передаются в 1 массиве

//изменяемые параметры:
//		- позиция, размер, ориентация объекта в пространстве


//в указанные при создании объекта шейдеры передауются данные:
//		- матрица модели "model"
//		- матрица вида "view"
//		- матрица проекции "projection"
//		- текстура "texture"



class Object {
	Texture texture;
	Shader shaders;
	GLuint VBO, EBO, VAO;
	glm::mat4 model, view, projection;
	GLfloat size, angle;
	glm::vec3 scaleVector, rotationVector; //отвечают за то, по какой координате и на сколько надо растянуть и повернуть объект соответственно
	bool applyTexture;
public:
	Object(GLFWwindow* window, GLuint objectSize, GLfloat* object, Shader shaders_, Texture texture_); //конструктор для объетов с текстурами
	Object(GLFWwindow* window, GLuint objectSize, GLfloat* object, GLuint objectIndexesSize, GLuint* objectIndexes, Shader shaders_);//конструктор для объектов без текстур
	glm::mat4 getModelMat() const {
		return model;
	}
	glm::mat4 getViewMat() const {
		return view;
	}
	glm::mat4 getProjectionMat() const {
		return projection;
	}
	void scale(GLfloat size_, glm::vec3 scaleVector_) {
		size = size_;
		scaleVector = scaleVector_;
	}
	void setOrientation(GLfloat angle_, glm::vec3 rotationVector_) {
		angle = angle_;
		rotationVector = rotationVector_;
	}
	void draw(GLenum mode, GLuint count, glm::vec3 position_, Camera cam);
};