#pragma once

enum OperationFilterType {
  GT,
  LT
};

__global__ void Filter( int numElements, float* array, OperationFilterType type, float* value, float* result);