#define PI 3.1415f

#include "Object.h"

Object::Object(GLFWwindow* window, GLuint objectSize, GLfloat* object,Shader shaders_, Texture texture_) : shaders(shaders_), texture(texture_), size(1.0f), angle(0.0f), scaleVector(glm::vec3(1.0f)), rotationVector(glm::vec3(1.0f)), applyTexture(true){
	int screenWidth, screenHeight;
	glfwGetFramebufferSize(window, &screenWidth, &screenHeight);

	model = glm::mat4(1.0f);
	view = glm::mat4(1.0f);
	projection = glm::perspective(100.0f, (float)screenWidth / screenHeight, 0.1f, 100.0f);
	//создаём VBO, EBO и сохраняем настройки в VAO
	//_________________________________________________________________________________________________________________________________________

	glGenBuffers(1, &VBO);
	glGenVertexArrays(1, &VAO);


	glBindVertexArray(VAO);

	glBindBuffer(GL_ARRAY_BUFFER, VBO);
	glBufferData(GL_ARRAY_BUFFER, objectSize, object, GL_STATIC_DRAW);

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
	//_________________________________________________________________________________________________________________________________________
}

Object::Object(GLFWwindow* window, GLuint objectSize, GLfloat* object, GLuint objectIndexesSize, GLuint* objectIndexes, Shader shaders_) : shaders(shaders_),size(1.0f), angle(0.0f), scaleVector(glm::vec3(1.0f)), rotationVector(glm::vec3(1.0f)), applyTexture(false) {
	int screenWidth, screenHeight;
	glfwGetFramebufferSize(window, &screenWidth, &screenHeight);

	model = glm::mat4(1.0f);
	view = glm::mat4(1.0f);
	projection = glm::perspective(100.0f, (float)screenWidth / screenHeight, 0.1f, 100.0f);


	glGenBuffers(1, &VBO);
	glGenBuffers(1, &EBO);
	glGenVertexArrays(1, &VAO);


	glBindVertexArray(VAO);

	glBindBuffer(GL_ARRAY_BUFFER, VBO);
	glBufferData(GL_ARRAY_BUFFER, objectSize, object, GL_STATIC_DRAW);

	glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, EBO);
	glBufferData(GL_ELEMENT_ARRAY_BUFFER, objectIndexesSize, objectIndexes, GL_STATIC_DRAW);

	glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(GLfloat), (void*)(0 * sizeof(GLfloat)));
	glEnableVertexAttribArray(0);

	glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(GLfloat), (void*)(3 * sizeof(GLfloat)));
	glEnableVertexAttribArray(1);

	glBindVertexArray(0);
}



void Object::draw(GLenum mode, GLuint count, glm::vec3 position, Camera cam) {
	shaders.use();
	if (applyTexture) {
		texture.use();
	}

	glBindVertexArray(VAO);
	model = glm::scale(glm::mat4(size), scaleVector);
	model = glm::rotate(model, angle, rotationVector);
	view = glm::lookAt(cam.getPos(), cam.getPos() + cam.getDir(), cam.getUp());
	view = glm::translate(view, position);

	glUniformMatrix4fv(glGetUniformLocation(shaders.getShaderProgramId(), "model"), 1, GL_FALSE, glm::value_ptr(model));
	glUniformMatrix4fv(glGetUniformLocation(shaders.getShaderProgramId(), "view"), 1, GL_FALSE, glm::value_ptr(view));
	glUniformMatrix4fv(glGetUniformLocation(shaders.getShaderProgramId(), "projection"), 1, GL_FALSE, glm::value_ptr(projection));
	if (applyTexture) {
		glUniform1i(glGetUniformLocation(shaders.getShaderProgramId(), "curTexture"), 0);
		glDrawArrays(mode, 0, count);
	}
	else {
		glDrawElements(mode, count, GL_UNSIGNED_INT, 0);
	}
	glBindVertexArray(0);
}