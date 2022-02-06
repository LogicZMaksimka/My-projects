#include <ScalarMulRunner.cuh>
#include <cstdio>

int main() {
  FILE *file_2reductions = fopen("../time_measurements/dot_product_2_reductions", "w");
  FILE *file_mul_plus_reduction = fopen("../time_measurements/dot_product_mul_plus_reduction", "w");
  for (int vector_length = 1 << 11; vector_length < 1 << 28; vector_length *= 8) {
    for (int block_size = 4; block_size <= 1 << 10; block_size *= 4) {
      printf("vector_length = %d block_size = %d\n", vector_length, block_size);
      float *host_vector1 = (float *) calloc(vector_length, sizeof(float));
      float *host_vector2 = (float *) calloc(vector_length, sizeof(float));

      for (int i = 0; i < vector_length; ++i) {
        host_vector1[i] = (float) rand() / RAND_MAX;
        host_vector2[i] = (float) rand() / RAND_MAX;
      }

      cudaEvent_t start;
      cudaEvent_t stop;
      cudaEventCreate(&start);
      cudaEventCreate(&stop);

      //___________________________________________________________________________
      cudaEventRecord(start);
      float dot_product1 = ScalarMulSumPlusReduction(vector_length, host_vector1, host_vector2, block_size);
      cudaEventRecord(stop);
      cudaEventSynchronize(stop);

      float time_in_milliseconds;
      cudaEventElapsedTime(&time_in_milliseconds, start, stop);
      fprintf(file_mul_plus_reduction, "%.6f,", time_in_milliseconds / 1000.0);
      //___________________________________________________________________________

      cudaEventRecord(start);
      float dot_product2 = ScalarMulTwoReductions(vector_length, host_vector1, host_vector2, block_size);
      cudaEventRecord(stop);
      cudaEventSynchronize(stop);

      cudaEventElapsedTime(&time_in_milliseconds, start, stop);
      fprintf(file_2reductions, "%.6f,", time_in_milliseconds / 1000.0);
      //___________________________________________________________________________

      free(host_vector1);
      free(host_vector2);
    }
    fprintf(file_2reductions, "\n");
    fprintf(file_mul_plus_reduction, "\n");
  }
  fclose(file_2reductions);
  fclose(file_mul_plus_reduction);
}

