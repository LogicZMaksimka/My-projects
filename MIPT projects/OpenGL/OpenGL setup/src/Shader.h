#ifndef SHADER_H
#define SHADER_H

#include <GL/glew.h>

class Shader {
	GLuint shaderProgram;
public:
	Shader();
	Shader(const GLchar* vertexShader, const GLchar* fragmentShader);
	GLuint getShaderProgramId() {
		return shaderProgram;
	}
	void use() { 
		glUseProgram(shaderProgram);
	}
};

#endif SHADER_H
