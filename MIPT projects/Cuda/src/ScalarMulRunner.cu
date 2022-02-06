#include <ScalarMulRunner.cuh>

#include <CommonKernels.cuh>

#include <KernelMul.cuh>

#include <ScalarMul.cuh>

#include <cstdio>

float ScalarMulTwoReductions(int num_elements, float *vector1, float *vector2, int block_size) {
  int blocks_count = (num_elements + block_size - 1) / block_size;

  float *device_vector1;
  float *device_vector2;
  float *device_block_sum;

  float *host_block_sum = (float *) calloc(blocks_count, sizeof(float));

  cudaMalloc(&device_vector1, num_elements * sizeof(float));
  cudaMalloc(&device_vector2, num_elements * sizeof(float));
  cudaMalloc(&device_block_sum, blocks_count * sizeof(float));

  cudaMemcpy(device_vector1, vector1, num_elements * sizeof(float), cudaMemcpyHostToDevice);
  cudaMemcpy(device_vector2, vector2, num_elements * sizeof(float), cudaMemcpyHostToDevice);

  ScalarMulBlock<<<blocks_count, block_size, block_size * sizeof(float)>>>(num_elements,
                                                                           device_vector1,
                                                                           device_vector2,
                                                                           device_block_sum);

  cudaDeviceSynchronize();
  cudaMemcpy(host_block_sum, device_block_sum, blocks_count * sizeof(float), cudaMemcpyDeviceToHost);

  cudaFree(device_vector1);
  cudaFree(device_vector2);
  cudaFree(device_block_sum);

  float total_sum = 0.0f;
  for (int i = 0; i < blocks_count; ++i) {
    total_sum += host_block_sum[i];
  }
  return total_sum;
}

float ScalarMulSumPlusReduction(int num_elements, float *vector1, float *vector2, int block_size) {
  int blocks_count = (num_elements + block_size - 1) / block_size;

  float *device_vector1;
  float *device_vector2;
  float *device_product_vector;
  float *device_block_sum;

  float *host_block_sum = (float *) calloc(blocks_count, sizeof(float));

  cudaMalloc(&device_vector1, num_elements * sizeof(float));
  cudaMalloc(&device_vector2, num_elements * sizeof(float));
  cudaMalloc(&device_product_vector, num_elements * sizeof(float));
  cudaMalloc(&device_block_sum, blocks_count * sizeof(float));

  cudaMemcpy(device_vector1, vector1, num_elements * sizeof(float), cudaMemcpyHostToDevice);
  cudaMemcpy(device_vector2, vector2, num_elements * sizeof(float), cudaMemcpyHostToDevice);

  KernelMul<<<blocks_count, block_size>>>(num_elements, device_vector1, device_vector2, device_product_vector);
  ArrayBlockSum<<<blocks_count, block_size, block_size * sizeof(float)>>>(num_elements,
                                                                          device_product_vector,
                                                                          device_block_sum);

  cudaMemcpy(host_block_sum, device_block_sum, blocks_count * sizeof(float), cudaMemcpyDeviceToHost);

  cudaFree(device_vector1);
  cudaFree(device_vector2);
  cudaFree(device_product_vector);
  cudaFree(device_block_sum);

  float total_sum = 0.0f;
  for (int i = 0; i < blocks_count; ++i) {
    total_sum += host_block_sum[i];
  }
  return total_sum;
}
