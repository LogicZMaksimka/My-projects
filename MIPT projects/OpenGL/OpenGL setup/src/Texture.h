#pragma once
#define GLEW_STATIC

#include <GL/glew.h>
#include <GLFW/glfw3.h>
#include "SOIL.h"

#include <cassert>

class Texture {
	GLuint texture;
	GLuint textureUnit;
public:
	Texture() : texture(NULL), textureUnit(NULL) {}
	Texture(const char* image, GLuint textureUnit);
	Texture operator=(Texture tex) {
		texture = tex.texture;
		return *this;
	}
	void use() {
		assert(texture && textureUnit);
		glActiveTexture(textureUnit);
		glBindTexture(GL_TEXTURE_2D, texture);
	}
	GLuint getTextureId() const{
		return texture;
	}
	void deleteTexture() {
		glDeleteTextures(1, &texture);
	}
};