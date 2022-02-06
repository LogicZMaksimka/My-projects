#include <MatrixMul.cuh>

__device__ void SetMatrixElement(float *matrix, int width, int row, int column, float element) {
  matrix[row * width + column] = element;
}

__device__ float GetMatrixElement(float *matrix, int width, int row, int column) {
  return matrix[row * width + column];
}

// NECESSARY REQUIREMENTS:
// 1) blockDim.x * gridDim.x >= max(height_A, height_B)
// 2) blockDim.y * gridDim.y >= max(width_A, width_B)
// 3) blockDim.x == blockDim.

// Algorithm:
// 1) Split matrix A and B into sub matrices with size (blockDim.x, blockDim.y)
// 2) For every block load row and column sub matrices in shared memory
// 3) For every block calculate sum over A_sub_matrix * B_sub_matrix
__global__ void MatrixMul(int height_A,
                          int width_A,
                          int width_B,
                          float *matrix_A,
                          float *matrix_B,
                          float *matrix_result) {
  int block_row = blockIdx.x;
  int block_column = blockIdx.y;
  int block_size = blockDim.x; // blockDim.x == blockDim.y

  // can allocate only 1 extern __shared__ array
  // so we need to split it into 2 arrays
  extern __shared__ float shared_data[];
  float *A_sub_matrix = shared_data;
  float *B_sub_matrix = (float *) &shared_data[block_size * block_size];

  float result_element = 0.0f;
  for (int block_num = 0; block_num < gridDim.y; ++block_num) {
    // load sub matrices in shared memory
    int A_element_row = block_row * block_size + threadIdx.x;
    int A_element_column = block_num * block_size + threadIdx.y;
    int B_element_row = block_num * block_size + threadIdx.x;
    int B_element_column = block_column * block_size + threadIdx.y;

    SetMatrixElement(A_sub_matrix, block_size, threadIdx.x, threadIdx.y, 0.0f);
    SetMatrixElement(B_sub_matrix, block_size, threadIdx.x, threadIdx.y, 0.0f);
    if (A_element_row < height_A && A_element_column < width_A) {
      float A_element = GetMatrixElement(matrix_A, width_A, A_element_row, A_element_column);
      SetMatrixElement(A_sub_matrix, block_size, threadIdx.x, threadIdx.y, A_element);
    }
    if (B_element_row < width_A && B_element_column < width_B) {
      float B_element = GetMatrixElement(matrix_B, width_B, B_element_row, B_element_column);
      SetMatrixElement(B_sub_matrix, block_size, threadIdx.x, threadIdx.y, B_element);
    }
    __syncthreads();

    // calculate result_element
    for (int i = 0; i < block_size; ++i) {
      float A_sub_matrix_element = GetMatrixElement(A_sub_matrix, block_size, threadIdx.x, i);
      float B_sub_matrix_element = GetMatrixElement(B_sub_matrix, block_size, i, threadIdx.y);
      result_element += A_sub_matrix_element * B_sub_matrix_element;
    }
    __syncthreads();
  }

  int result_row = blockIdx.x * blockDim.x + threadIdx.x;
  int result_column = blockIdx.y * blockDim.y + threadIdx.y;
  if (result_row < height_A && result_column < width_B) {
    SetMatrixElement(matrix_result, width_B, result_row, result_column, result_element);
  }
}