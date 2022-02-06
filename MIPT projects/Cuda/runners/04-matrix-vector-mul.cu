#include <MatrixVectorMul.cuh>
#include <cstdio>

void MultiplyMatrixByVector(int height,
                            int width,
                            float *host_matrix,
                            float *host_vector,
                            float *host_result,
                            int block_size) {
  int total_elements_count = width * height;

  float *device_matrix;
  float *device_vector;
  float *device_result;

  cudaMalloc(&device_matrix, total_elements_count * sizeof(float));
  cudaMalloc(&device_vector, width * sizeof(float));
  cudaMalloc(&device_result, height * sizeof(float));

  cudaMemcpy(device_matrix, host_matrix, total_elements_count * sizeof(float), cudaMemcpyHostToDevice);
  cudaMemcpy(device_vector, host_vector, width * sizeof(float), cudaMemcpyHostToDevice);

  int blocks_count = (height + block_size - 1) / block_size;

  MatrixVectorMul<<<blocks_count, block_size>>>(height, width, device_matrix, device_vector, device_result);
  cudaMemcpy(host_result, device_result, height * sizeof(float), cudaMemcpyDeviceToHost);

  cudaFree(device_matrix);
  cudaFree(device_vector);
  cudaFree(device_result);
}

int main() {
  FILE *file = fopen("../time_measurements/multiply_matrix_by_vector", "w");
  for (int matrix_size = 1 << 5; matrix_size < 1 << 14; matrix_size *= 2) {
    for (int block_size = 4; block_size <= 1 << 10; block_size *= 4) {
      printf("matrix_size = %d block_size = %d\n", matrix_size, block_size);
      int height = matrix_size;
      int width = matrix_size;
      int total_elements_count = width * height;

      float *host_matrix = (float *) calloc(total_elements_count, sizeof(float));
      float *host_vector = (float *) calloc(width, sizeof(float));
      float *host_result = (float *) calloc(height, sizeof(float));

      for (int i = 0; i < total_elements_count; ++i) {
        host_matrix[i] = (float) rand() / RAND_MAX;
      }
      for (int i = 0; i < width; ++i) {
        host_vector[i] = (float) rand() / RAND_MAX;
      }

      cudaEvent_t start;
      cudaEvent_t stop;
      cudaEventCreate(&start);
      cudaEventCreate(&stop);

      cudaEventRecord(start);

      MultiplyMatrixByVector(height, width, host_matrix, host_vector, host_result, block_size);

      cudaEventRecord(stop);
      cudaEventSynchronize(stop);

      float time_in_milliseconds = 0;
      cudaEventElapsedTime(&time_in_milliseconds, start, stop);
      float time_in_seconds = time_in_milliseconds / 1000.0;
      fprintf(file, "%.6f,", time_in_seconds);

      free(host_matrix);
      free(host_vector);
      free(host_result);
    }
    fprintf(file, "\n");
  }

  fclose(file);
}
