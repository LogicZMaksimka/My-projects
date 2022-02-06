cmake_minimum_required(VERSION 3.10)

project(CudaTasks)
find_package(CUDA REQUIRED)

include_directories(include)


cuda_add_library(common_kernels src/CommonKernels.cu SHARED)
# You can add files to common_kernels library; this library will be compiled with tests

cuda_add_executable(01-add runners/01-add.cu src/KernelAdd.cu)
cuda_add_executable(02-mul runners/02-mul.cu src/KernelMul.cu)
cuda_add_executable(03-matrix-add runners/03-matrix-add.cu src/KernelMatrixAdd.cu)
cuda_add_executable(04-matrix-vector-mul runners/04-matrix-vector-mul.cu src/MatrixVectorMul.cu)
cuda_add_executable(05-scalar-mul runners/05-scalar-mul.cu src/ScalarMulRunner.cu src/ScalarMul.cu src/CommonKernels.cu  src/KernelMul.cu)
cuda_add_executable(06-cosine-vector runners/06-cosine-vector.cu src/CosineVector.cu src/ScalarMulRunner.cu src/ScalarMul.cu src/CommonKernels.cu  src/KernelMul.cu)
cuda_add_executable(07-matrix-mul runners/07-matrix-mul.cu src/MatrixMul.cu)
cuda_add_executable(08-filter runners/08-filter.cu src/Filter.cu)

target_link_libraries(01-add common_kernels)
target_link_libraries(02-mul common_kernels)
target_link_libraries(03-matrix-add common_kernels)
target_link_libraries(04-matrix-vector-mul common_kernels)
target_link_libraries(05-scalar-mul common_kernels)
target_link_libraries(06-cosine-vector common_kernels)
target_link_libraries(07-matrix-mul common_kernels)
target_link_libraries(08-filter common_kernels)

add_subdirectory(tests)