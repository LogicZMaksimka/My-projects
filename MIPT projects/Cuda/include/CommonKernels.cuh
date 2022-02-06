#pragma once

// your can write kernels here for your operations

__global__ void ArrayBlockSum(int array_size, float *array, float *block_sum);
