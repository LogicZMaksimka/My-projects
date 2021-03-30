#include <iostream>
#include <fstream>
#include <sstream>

#include "Shader.h"

Shader::Shader(const GLchar* vertexShaderPath, const GLchar* fragmentShaderPath) {	
	std::ifstream vertexShaderFile(vertexShaderPath);
	std::ifstream fragmentShaderFile(fragmentShaderPath);
	if (!vertexShaderFile.is_open()) std::cout << "error in reading vertex shader::" << vertexShaderPath << std::endl;
	if (!fragmentShaderFile.is_open()) std::cout << "error in reading fragment shader::" << fragmentShaderPath << std::endl;

	std::stringstream vertexShaderStream, fragmentShaderStream;
	vertexShaderStream << vertexShaderFile.rdbuf();
	fragmentShaderStream << fragmentShaderFile.rdbuf();
	
	std::string vertexCode = vertexShaderStream.str();
	std::string fragmentCode = fragmentShaderStream.str();

	const GLchar *vertexShaderCode = "", *fragmentShaderCode = "";
	vertexShaderCode = vertexCode.c_str();
	fragmentShaderCode = fragmentCode.c_str();

	//std::cout << "vertexShaderCode:\n" << vertexShaderCode << std::endl;
	//std::cout << "\nfragmentShaderCode:\n" << fragmentShaderCode << std::endl;

	GLuint vertexShader, fragmentShader;
	GLint sucess;
	GLchar infoLog[512];

	vertexShader = glCreateShader(GL_VERTEX_SHADER);
	glShaderSource(vertexShader, 1, &vertexShaderCode, NULL);
	glCompileShader(vertexShader);
	glGetShaderiv(vertexShader, GL_COMPILE_STATUS, &sucess);
	if (!sucess) {
		glGetShaderInfoLog(vertexShader, 512, NULL, infoLog);
		std::cout << "error in compiling vertex shader::" << vertexShaderPath << "::" << infoLog << std::endl;
	}
	
	fragmentShader = glCreateShader(GL_FRAGMENT_SHADER);
	glShaderSource(fragmentShader, 1, &fragmentShaderCode, NULL);
	glCompileShader(fragmentShader);
	glGetShaderiv(fragmentShader, GL_COMPILE_STATUS, &sucess);
	if (!sucess) {
		glGetShaderInfoLog(fragmentShader, 512, NULL, infoLog);
		std::cout << "error in compiling fragment shader::" << fragmentShaderPath << "::" << infoLog << std::endl;
	}


	shaderProgram = glCreateProgram();
	glAttachShader(shaderProgram, vertexShader);
	glAttachShader(shaderProgram, fragmentShader);
	glLinkProgram(shaderProgram);

	glGetShaderiv(vertexShader, GL_LINK_STATUS, &sucess);
	if (!sucess) {
		glGetShaderInfoLog(shaderProgram, 512, NULL, infoLog);
		std::cout << "error in linking shaders::" << vertexShaderPath << " & " << fragmentShaderPath << "::" << infoLog << std::endl;
	}

	glDeleteShader(vertexShader);
	glDeleteShader(fragmentShader);
}

