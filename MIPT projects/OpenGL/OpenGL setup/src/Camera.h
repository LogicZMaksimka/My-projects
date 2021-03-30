#pragma once
#define GLEW_STATIC
#include <GL/glew.h>

#include <GLFW/glfw3.h>

#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtc/type_ptr.hpp>

class Camera {
	GLFWwindow* window;
	glm::vec3 cameraPos, cameraDir, cameraUp, cameraRight;
	glm::vec3 up;
	GLfloat pitch, yaw, roll; //углы крена
	GLfloat lastX, lastY; //положение мыши
public:
	Camera(GLFWwindow* win, glm::vec3 camPos, glm::vec3 camDir, glm::vec3 camUp);
	void keyboardMoveCamera(GLfloat deltaTime);
	void keyboardMoveMinecraftCamera(GLfloat deltaTime);
	void mouseTurnCamera(GLfloat deltaTime);
	glm::vec3 getPos();
	glm::vec3 getDir();
	glm::vec3 getUp();
};