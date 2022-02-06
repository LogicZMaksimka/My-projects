#include <CommonKernels.cuh>

// NECESSARY REQUIREMENT: blockDim.x * gridDim.x >= array_size
__global__ void ArrayBlockSum(int array_size, float *array, float *block_sum) {
  extern __shared__ float shared_array[];
  int index = blockIdx.x * blockDim.x + threadIdx.x;

  if(index < array_size) {
    shared_array[threadIdx.x] = array[index];
  } else {
    shared_array[threadIdx.x] = 0.0f;
  }
  __syncthreads();

  for(int half_size = blockDim.x / 2; half_size > 0; half_size /= 2) {
    if(threadIdx.x < half_size) {
      shared_array[threadIdx.x] += shared_array[threadIdx.x + half_size];
    }
    __syncthreads();
  }

  if(threadIdx.x == 0) {
     block_sum[blockIdx.x] = shared_array[0];
  }
}
