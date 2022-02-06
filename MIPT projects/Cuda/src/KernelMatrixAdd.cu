#include <KernelMatrixAdd.cuh>

// NECESSARY REQUIREMENTS: blockDim.x * gridDim.x >= height; blockDim.y * gridDim.y >= width
__global__ void KernelMatrixAdd(int height, int width, size_t pitch, float* A, float* B, float* result) {
  int row_index = blockIdx.x * blockDim.x + threadIdx.x;
  int column_index = blockIdx.y * blockDim.y + threadIdx.y;
  if(row_index < height && column_index < width) {
    float *A_row = (float *)((char *)A + row_index * pitch);
    float *B_row = (float *)((char *)B + row_index * pitch);
    float *result_row = (float *)((char *)result + row_index * pitch);
    result_row[column_index] = A_row[column_index] + B_row[column_index];
  }
}
