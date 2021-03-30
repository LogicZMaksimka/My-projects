#include "Camera.h"

Camera::Camera(GLFWwindow* window_, glm::vec3 camPos, glm::vec3 camDir, glm::vec3 camUp) {
	window = window_;
	cameraPos = camPos;
	cameraDir = camDir;
	cameraUp = camUp;
	up = glm::vec3(0.0f, 1.0f, 0.0f);
	pitch = atan(cameraDir.y / sqrt(cameraDir.x * cameraDir.x + cameraDir.z * cameraDir.z));
	yaw = atan(cameraDir.z / cameraDir.x);
	roll = 0.0f;
	double mouseX, mouseY;
	glfwGetCursorPos(window, &mouseX, &mouseY);
	lastX = (float)mouseX;
	lastY = (float)mouseY;
}


void Camera::keyboardMoveCamera(GLfloat deltaTime) {
	GLfloat cameraVelocity = 7 * deltaTime;
	if (glfwGetKey(window, GLFW_KEY_W) == GLFW_PRESS) {
		cameraPos += cameraVelocity * cameraDir;
	}
	if (glfwGetKey(window, GLFW_KEY_S) == GLFW_PRESS) {
		cameraPos -= cameraVelocity * cameraDir;
	}
	if (glfwGetKey(window, GLFW_KEY_A) == GLFW_PRESS) {
		cameraPos -= glm::normalize(glm::cross(cameraUp, cameraDir)) * cameraVelocity; //из-за такого формата игрок не может смотреть строго вверх
	}
	if (glfwGetKey(window, GLFW_KEY_D) == GLFW_PRESS) {
		cameraPos += glm::normalize(glm::cross(cameraUp, cameraDir)) * cameraVelocity;
	}
	if (glfwGetKey(window, GLFW_KEY_SPACE) == GLFW_PRESS) {
		cameraPos -= cameraUp * cameraVelocity;
	}
	if (glfwGetKey(window, GLFW_KEY_LEFT_SHIFT) == GLFW_PRESS) {
		cameraPos += cameraUp * cameraVelocity;
	}
}

void Camera::keyboardMoveMinecraftCamera(GLfloat deltaTime) {
	GLfloat cameraVelocity = 7 * deltaTime;
	glm::vec3 leftVec = glm::cross(glm::vec3(cameraDir.x, 0.0f, cameraDir.z), up);
	if (glfwGetKey(window, GLFW_KEY_W) == GLFW_PRESS) {
		cameraPos += glm::normalize(glm::vec3(cameraDir.x, 0.0f, cameraDir.z)) * cameraVelocity;
	}
	if (glfwGetKey(window, GLFW_KEY_S) == GLFW_PRESS) {
		cameraPos -= glm::normalize(glm::vec3(cameraDir.x, 0.0f, cameraDir.z)) * cameraVelocity;
	}
	if (glfwGetKey(window, GLFW_KEY_A) == GLFW_PRESS) {
		cameraPos += glm::normalize(leftVec) * cameraVelocity;
	}
	if (glfwGetKey(window, GLFW_KEY_D) == GLFW_PRESS) {
		cameraPos -= glm::normalize(leftVec) * cameraVelocity;
	}
	if (glfwGetKey(window, GLFW_KEY_SPACE) == GLFW_PRESS) {
		cameraPos -= cameraVelocity * up;
	}
	if (glfwGetKey(window, GLFW_KEY_LEFT_SHIFT) == GLFW_PRESS) {
		cameraPos += cameraVelocity * up;
	}
}


void Camera::mouseTurnCamera(GLfloat deltaTime) {
	GLfloat sensitivity = 100 * deltaTime;

	double mouseX, mouseY;
	glfwGetCursorPos(window, &mouseX, &mouseY);

	GLfloat xOffset = lastX - mouseX;
	GLfloat yOffset = mouseY - lastY; //обратный порядок вычитания т.к. "y" возрастанет с верху вниз

	lastX = mouseX;
	lastY = mouseY;

	pitch += yOffset * sensitivity;
	yaw += xOffset * sensitivity;

	
	if (pitch >= 89.0f) {
		pitch = 89.0f;
	}
	if (pitch <= -89.0f) {
		pitch = -89.0f;
	}

	GLfloat radPitch = glm::radians(pitch);
	GLfloat radYaw = glm::radians(yaw);

	cameraDir.x = cos(radPitch) * cos(radYaw);
	cameraDir.y = sin(radPitch);
	cameraDir.z = cos(radPitch) * sin(radYaw);

	//вроде не нужно нормаллизировать вектор направления
}

glm::vec3 Camera::getPos() {
	return cameraPos;
}
glm::vec3 Camera::getDir() {
	return cameraDir;
}
glm::vec3 Camera::getUp() {
	return cameraUp;
}