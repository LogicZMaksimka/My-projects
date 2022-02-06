#include "KernelAdd.cuh"
#include <stdio.h>
#include <stdlib.h>

void AddVectors(int array_size, float *host_array_x, float *host_array_y, float *host_array_sum, int block_size) {
  int array_memory_size = array_size * sizeof(float);

  float *device_array_x;
  float *device_array_y;
  float *device_array_sum;

  cudaMalloc(&device_array_x, array_memory_size);
  cudaMalloc(&device_array_y, array_memory_size);
  cudaMalloc(&device_array_sum, array_memory_size);

  cudaMemcpy(device_array_x, host_array_x, array_memory_size, cudaMemcpyHostToDevice);
  cudaMemcpy(device_array_y, host_array_y, array_memory_size, cudaMemcpyHostToDevice);

  cudaEvent_t start;
  cudaEvent_t stop;
  cudaEventCreate(&start);
  cudaEventCreate(&stop);

  int blocks_count = (array_size + block_size - 1) / block_size;

  KernelAdd<<<blocks_count, block_size>>>(array_size, device_array_x, device_array_y, device_array_sum);
  cudaMemcpy(host_array_sum, device_array_sum, array_memory_size, cudaMemcpyDeviceToHost);

  cudaFree(device_array_x);
  cudaFree(device_array_y);
  cudaFree(device_array_sum);
}

int main() {
  FILE *file = fopen("../time_measurements/vectors_sum", "w");
  for (int array_size = 1 << 11; array_size < 1 << 28; array_size *= 8) {
    for (int block_size = 4; block_size <= 1 << 10; block_size *= 4) {
      printf("array_size = %d block_size = %d\n", array_size, block_size);
      float *host_array_x = (float *) calloc(array_size, sizeof(float));
      float *host_array_y = (float *) calloc(array_size, sizeof(float));
      float *host_array_sum = (float *) calloc(array_size, sizeof(float));

      for (int i = 0; i < array_size; ++i) {
        host_array_x[i] = (float) rand() / RAND_MAX;
        host_array_y[i] = (float) rand() / RAND_MAX;
      }

      cudaEvent_t start;
      cudaEvent_t stop;
      cudaEventCreate(&start);
      cudaEventCreate(&stop);

      cudaEventRecord(start);

      AddVectors(array_size, host_array_x, host_array_y, host_array_sum, block_size);

      cudaEventRecord(stop);
      cudaEventSynchronize(stop);

      float time_in_milliseconds = 0;
      cudaEventElapsedTime(&time_in_milliseconds, start, stop);
      float time_in_seconds = time_in_milliseconds / 1000.0;
      fprintf(file, "%.6f,", time_in_seconds);

      free(host_array_x);
      free(host_array_y);
      free(host_array_sum);
    }
    fprintf(file, "\n");
  }

  fclose(file);
  return 0;
}
