#pragma once


__global__
void MatrixMul(int heightA, int widthA, int widthB, float *matrixA, float *matrixB, float *matrixResult);
