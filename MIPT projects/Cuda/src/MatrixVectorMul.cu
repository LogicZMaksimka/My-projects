#include <MatrixVectorMul.cuh>

// NECESSARY REQUIREMENT: blockDim.x * gridDim.x >= height
__global__ void MatrixVectorMul(int height, int width, float* matrix, float* vector, float* result) {
  int row_index = blockIdx.x * blockDim.x + threadIdx.x;
  result[row_index] = 0.0f;
  if(row_index < height) {
    for(int column_index = 0; column_index < width; ++column_index) {
     result[row_index] += matrix[row_index * width + column_index] * vector[column_index];
    }
  }
}

