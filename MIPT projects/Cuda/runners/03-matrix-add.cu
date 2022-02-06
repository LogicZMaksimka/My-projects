#include <KernelMatrixAdd.cuh>
#include <cstdio>

void AddMatrices(int height, int width, float *host_matrix_x, float *host_matrix_y, float *host_matrix_sum, int block_size) {
  float *device_matrix_x;
  float *device_matrix_y;
  float *device_matrix_sum;

  size_t pitch;

  size_t host_pitch = width * sizeof(float);

  cudaMallocPitch(&device_matrix_x, &pitch, width * sizeof(float), height);
  cudaMallocPitch(&device_matrix_y, &pitch, width * sizeof(float), height);
  cudaMallocPitch(&device_matrix_sum, &pitch, width * sizeof(float), height);

  cudaMemcpy2D(device_matrix_x,
               pitch,
               host_matrix_x,
               host_pitch,
               width * sizeof(float),
               height,
               cudaMemcpyHostToDevice);
  cudaMemcpy2D(device_matrix_y,
               pitch,
               host_matrix_y,
               host_pitch,
               width * sizeof(float),
               height,
               cudaMemcpyHostToDevice);

  dim3 block_dim(block_size, block_size);
  dim3 grid_dim((height + block_dim.x - 1) / block_dim.x, (width + block_dim.y - 1) / block_dim.y);

  KernelMatrixAdd<<<grid_dim, block_dim>>>(height,
                                           width,
                                           pitch,
                                           device_matrix_x,
                                           device_matrix_y,
                                           device_matrix_sum);
  cudaMemcpy2D(host_matrix_sum,
               host_pitch,
               device_matrix_sum,
               pitch,
               width * sizeof(float),
               height,
               cudaMemcpyDeviceToHost);

  cudaFree(device_matrix_x);
  cudaFree(device_matrix_y);
  cudaFree(device_matrix_sum);
}

int main() {
  FILE *file = fopen("../time_measurements/add_matrices", "w");
  for (int matrix_size = 1 << 5; matrix_size < 1 << 14; matrix_size *= 2) {
    for (int block_size = 2; block_size <= 1 << 5; block_size *= 2) {
      printf("matrix_size = %d block_size = %d\n", matrix_size, block_size);
      int height = matrix_size;
      int width = matrix_size;
      int matrix_size = width * height;

      float *host_matrix_x = (float *) calloc(matrix_size, sizeof(float));
      float *host_matrix_y = (float *) calloc(matrix_size, sizeof(float));
      float *host_matrix_sum = (float *) calloc(matrix_size, sizeof(float));

      for (int i = 0; i < matrix_size; ++i) {
        host_matrix_x[i] = (float) rand() / RAND_MAX;
        host_matrix_y[i] = (float) rand() / RAND_MAX;
      }

      cudaEvent_t start;
      cudaEvent_t stop;
      cudaEventCreate(&start);
      cudaEventCreate(&stop);

      cudaEventRecord(start);

      AddMatrices(height, width, host_matrix_x, host_matrix_y, host_matrix_sum, block_size);

      cudaEventRecord(stop);
      cudaEventSynchronize(stop);

      float time_in_milliseconds = 0;
      cudaEventElapsedTime(&time_in_milliseconds, start, stop);
      float time_in_seconds = time_in_milliseconds / 1000.0;
      fprintf(file, "%.6f,", time_in_seconds);

      free(host_matrix_x);
      free(host_matrix_y);
      free(host_matrix_sum);
    }
    fprintf(file, "\n");
  }

  fclose(file);
  return 0;
}
