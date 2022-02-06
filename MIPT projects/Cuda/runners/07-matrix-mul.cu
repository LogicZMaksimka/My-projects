#include <MatrixMul.cuh>

#include <cmath>
#include <cstdio>

void MultiplyMatrices(int height_A,
                      int width_A,
                      int width_B,
                      float *host_matrix_A,
                      float *host_matrix_B,
                      float *host_matrix_result,
                      int block_size) {
  int height_B = width_A;
  int A_elements_count = height_A * width_A;
  int B_elements_count = height_B * width_B;
  int result_elements_count = height_A * width_B;

  float *device_matrix_A;
  float *device_matrix_B;
  float *device_matrix_result;

  cudaMalloc(&device_matrix_A, A_elements_count * sizeof(float));
  cudaMalloc(&device_matrix_B, B_elements_count * sizeof(float));
  cudaMalloc(&device_matrix_result, result_elements_count * sizeof(float));

  cudaMemcpy(device_matrix_A, host_matrix_A, A_elements_count * sizeof(float), cudaMemcpyHostToDevice);
  cudaMemcpy(device_matrix_B, host_matrix_B, B_elements_count * sizeof(float), cudaMemcpyHostToDevice);

  dim3 block_dim(block_size, block_size);
  dim3 grid_dim((max(height_A, height_B) + block_dim.x - 1) / block_dim.x,
                (max(width_A, width_B) + block_dim.y - 1) / block_dim.y);
  size_t shared_memory_size = (2 * block_dim.x * block_dim.y + 1) * sizeof(float);

  MatrixMul<<<grid_dim, block_dim, shared_memory_size>>>(
      height_A,
      width_A,
      width_B,
      device_matrix_A,
      device_matrix_B,
      device_matrix_result);
  cudaMemcpy(host_matrix_result, device_matrix_result, result_elements_count * sizeof(float), cudaMemcpyDeviceToHost);

  cudaFree(device_matrix_A);
  cudaFree(device_matrix_B);
  cudaFree(device_matrix_result);
}

int main() {
  FILE *file = fopen("../time_measurements/product_of_matrices", "w");
  for (int matrix_size = 1 << 5; matrix_size < 1 << 14; matrix_size *= 4) {
    for (int block_size = 2; block_size <= 1 << 5; block_size *= 2) {
      printf("matrix_size = %d block_size = %d\n", matrix_size, block_size);
      int height_A = matrix_size;
      int width_A = matrix_size;
      int height_B = width_A;
      int width_B = matrix_size;

      int A_elements_count = height_A * width_A;
      int B_elements_count = height_B * width_B;
      int result_elements_count = height_A * width_B;

      float *host_matrix_A = (float *) calloc(A_elements_count, sizeof(float));
      float *host_matrix_B = (float *) calloc(B_elements_count, sizeof(float));
      float *host_matrix_result = (float *) calloc(result_elements_count, sizeof(float));

      for (int i = 0; i < A_elements_count; ++i) {
        host_matrix_A[i] = (float) rand() / RAND_MAX;
      }
      for (int i = 0; i < B_elements_count; ++i) {
        host_matrix_B[i] = (float) rand() / RAND_MAX;
      }

      cudaEvent_t start;
      cudaEvent_t stop;
      cudaEventCreate(&start);
      cudaEventCreate(&stop);

      cudaEventRecord(start);

      MultiplyMatrices(height_A, width_A, width_B, host_matrix_A, host_matrix_B, host_matrix_result, block_size);

      cudaEventRecord(stop);
      cudaEventSynchronize(stop);

      float time_in_milliseconds;
      cudaEventElapsedTime(&time_in_milliseconds, start, stop);
      fprintf(file, "%.6f,", time_in_milliseconds / 1000.0);

      free(host_matrix_A);
      free(host_matrix_B);
      free(host_matrix_result);
    }
    fprintf(file, "\n");
  }
  fclose(file);
}

