#include <ScalarMul.cuh>

/*
 * Calculates scalar multiplication for block
 */
__global__
void ScalarMulBlock(int numElements, float* vector1, float* vector2, float *result) {
  extern __shared__ float thread_sum[];
  int index = blockIdx.x * blockDim.x + threadIdx.x;
  int stride = blockDim.x * gridDim.x;
  float sum = 0.0f;
  for(int i = index; i < numElements; i += stride) {
    sum += vector1[i] * vector2[i];
  }
  thread_sum[threadIdx.x] = sum;
  __syncthreads();

  //reduction
  for(int half_size = blockDim.x / 2; half_size > 0; half_size /= 2) {
    if(threadIdx.x < half_size) {
      thread_sum[threadIdx.x] += thread_sum[threadIdx.x + half_size];
    }
    __syncthreads();
  }
  if(threadIdx.x == 0) {
    result[blockIdx.x] = thread_sum[0];
  }
}

