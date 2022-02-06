#pragma once


__global__ void KernelMatrixAdd(int height, int width, size_t pitch, float* A, float* B, float* result);
