#include <CosineVector.cuh>

#include <ScalarMulRunner.cuh>

float CosineVector(int num_elements, float* vector1, float* vector2, int block_size) {
  float dot_product = ScalarMulTwoReductions(num_elements, vector1, vector2, block_size);
  float vector1_length = sqrt(ScalarMulTwoReductions(num_elements, vector1, vector1, block_size));
  float vector2_length = sqrt(ScalarMulTwoReductions(num_elements, vector2, vector2, block_size));

  return dot_product / (vector1_length * vector2_length);
}
