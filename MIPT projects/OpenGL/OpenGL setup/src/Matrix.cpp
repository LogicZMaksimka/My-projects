#include <iostream>
#include <cmath>

#define PI 3.14159

using namespace std;

#include "Matrix.h"

Matrix::Matrix() {
	*mat = 0;
	strokeCount = columnCount = 0;
}

Matrix::Matrix(const double* mat_, int strokeCount_, int columnCount_){
	strokeCount = strokeCount_;
	columnCount = columnCount_;
	mat = new double[strokeCount*columnCount];
	for (int i = 0; i < strokeCount * columnCount; ++i) {
		mat[i] = mat_[i];
	}
}

Matrix::Matrix(const Matrix& obj) {
	strokeCount = obj.strokeCount;
	columnCount = obj.columnCount;
	mat = new double[strokeCount * columnCount];
	for (int i = 0; i < strokeCount * columnCount; ++i) {
		mat[i] = obj.mat[i];
	}
}

Matrix::~Matrix() {
	delete[] mat;
}


bool Matrix::validMultiplication(Matrix matrix1, Matrix matrix2) {
	if (matrix1.columnCount == matrix2.strokeCount) return true;
	return false;
}

bool validMultiplication(Matrix matrix, Vector vec) {
	//массив сочетаний квадратной матрицы преобразований(1 столбик) и вектора(2 стобик)
	short int combinations[][2] = {
	{2, 2},
	{3, 2},
	{3, 3},
	{4, 2},
	{4, 3},
	{4, 4}
	};
	if(matrix.columnCount == vec.size) return true; //неквадратна€ матрица умножаетс€ на вектор
	
	/*if (matrix.strokeCount == matrix.columnCount) {
		for (int i = 0; i < 6; ++i) {
			if (matrix.columnCount)
		}
	}*/
}

Matrix Matrix::operator=(Matrix matrix) {
	strokeCount = matrix.strokeCount;
	columnCount = matrix.columnCount;
	int mat_size = strokeCount * columnCount;
	mat = new double[mat_size];
	for (int i = 0; i < mat_size; ++i) {
		mat[i] = matrix.mat[i];
	}
	return *this;
}
Matrix Matrix::operator=(double c) {
	int mat_size = strokeCount * columnCount;
	for (int i = 0; i < mat_size; ++i) {
		mat[i] = c;
	}
	return *this;
}

Matrix Matrix::operator+(Matrix matrix) { //очень важно чтобы return работало нормально и не очищалась одна и та же область пам€ти дважды и чтоб јјјјјјјјјјјјјјјјјјјјј пон€тно да?!
	if (strokeCount == matrix.strokeCount && columnCount == matrix.columnCount) {
		int mat_size = strokeCount * columnCount;
		double* temp = new double[mat_size];
		for (int i = 0; i < mat_size; ++i) {
			temp[i] = mat[i] + matrix.mat[i];
		}
		return Matrix(temp, strokeCount, columnCount);
	}
	else{
		cout << "error::matrix::operation '+'" << endl;
		return *this;
	}
}
Matrix Matrix::operator+(double c){
	int mat_size = strokeCount * columnCount;
	double* temp = new double[mat_size];
	for (int i = 0; i < mat_size; ++i) {
		temp[i] = mat[i] + c;
	}
	return Matrix(temp, strokeCount, columnCount);
}
Matrix operator+(double c, Matrix matrix) {
	return matrix + c;
}

Matrix Matrix::operator-(Matrix matrix) { //очень важно чтобы return работало нормально и не очищалась одна и та же область пам€ти дважды и чтоб јјјјјјјјјјјјјјјјјјјјј пон€тно да?!
	if (strokeCount == matrix.strokeCount && columnCount == matrix.columnCount) {
		int mat_size = strokeCount * columnCount;
		double* temp = new double[mat_size];
		for (int i = 0; i < mat_size; ++i) {
			temp[i] = mat[i] - matrix.mat[i];
		}
		return Matrix(temp, strokeCount, columnCount);
	}
	else {
		cout << "error::matrix::operation '-'" << endl;
		return *this;
	}
}
Matrix Matrix::operator-(double c) {
	int mat_size = strokeCount * columnCount;
	double *temp = new double[mat_size];
	for (int i = 0; i < mat_size; ++i) {
		temp[i] = mat[i] - c;
	}
	return Matrix(temp, strokeCount, columnCount);
}

Matrix Matrix::operator*(Matrix matrix) {
	if (validMultiplication(*this, matrix)) {
		double* temp = new double[strokeCount * matrix.columnCount];
		int counter = 0;
		for (int i = 0; i < strokeCount; ++i) {
			for (int j = 0; j < matrix.columnCount; ++j, ++counter) {
				temp[counter] = 0;
				for (int k = 0; k < columnCount; ++k) {
					temp[counter] += mat[i * columnCount + k] * matrix.mat[k * matrix.columnCount + j];
				}
				cout << temp[counter] << " ";
			}
			cout << endl;
		}
		return Matrix(temp, strokeCount, matrix.columnCount);
	}
	else {
		cout << "error::matrix::operation '*'" << endl;
		return *this;
	}
}
Matrix Matrix::operator*(double c) {
	int mat_size = strokeCount * columnCount;
	double *temp = new double[mat_size];
	for (int i = 0; i < mat_size; ++i) {
		temp[i] = mat[i] * c;
	}
	return Matrix(temp, strokeCount, columnCount);
}
Matrix operator*(double c, Matrix matrix) {
	return matrix * c;
}

//эта фугкци€ возможно вовсе не нужна, т.к. главное - это передать сформированную матрицу в шейдер
Vector operator*(Matrix matrix, Vector vec) { //фигово, очень нужно что-то с этим сделать !!!!!!!!!!!!!!!!!!!!!!!!!!!!
	if (validMultiplication(matrix, vec)) { //<- !!!!!!!!!!!!!!!!
		double arr[4] = { vec.x, vec.y, vec.z, vec.w };
		Matrix vecCopy(arr, matrix.columnCount, 1);
		Matrix result = vecCopy * matrix;
		return Vector(result.mat[0], result.mat[1], result.mat[2], result.mat[3]);
	}
	else {
		cout << "error::matrix::operation '*'" << endl;
		return vec;
	}
}

//вот тут € сдалс€, такой хрени мне никгда видеть не доводилось
//€ просто не знаю как правильно сочетать формат Matrix и Vector
Matrix getScalingMatrix(Matrix matrix, Vector vec) {
	if (matrix.strokeCount == matrix.columnCount && matrix.strokeCount == vec.getSize() && 2 <= matrix.strokeCount && matrix.strokeCount <= 4) {
	}
	else {
		cout << "error::matrix::operation 'getScalingMatrix'" << endl;
		return matrix;
	}
}



Vector Vector::operator=(Vector vec) {
	if (size != vec.size) {
		cout << "error::vector::operation '='" << endl;
		return *this;
	}
	x = vec.x;
	y = vec.y;
	switch (size)
	{
	case 3:
		z = vec.z;
		break;
	case 4:
		z = vec.z;
		w = vec.w;
		break;
	}
	return *this;
}
Vector Vector::operator=(double c) {
	x = y = c;
	switch (size)
	{
	case 3:
		z = c;
		break;
	case 4:
		z = c;
		w = c;
		break;
	}
	return *this;
}

Vector Vector::operator+(Vector vec) {
	if (size != vec.size) {
		cout << "error::vector::operation '+'" << endl;
		return *this;
	}
	return Vector(x + vec.x, y + vec.y, z + vec.z, w + vec.w);
}
Vector Vector::operator+(double c) {
	return Vector(x + c, y + c, z + c, w + c);
}
Vector operator+(double c, Vector vec) {
	return Vector(vec.x + c, vec.y + c, vec.z + c, vec.w + c);
}

Vector Vector::operator-(Vector vec) {
	if (size != vec.size) {
		cout << "error::vector::operation '-'" << endl;
		return *this;
	}
	return Vector(x - vec.x, y - vec.y, z - vec.z, w - vec.w);
}
Vector Vector::operator-(double c) {
	return Vector(x - c, y - c, z - c, w - c);
}

Vector Vector::operator*(double c) {
	return Vector(x * c, y * c, z * c, w * c);
}
Vector operator*(double c, Vector vec) {
	return Vector(vec.x * c, vec.y * c, vec.z * c, vec.w * c);
}

Vector Vector::add(Vector vec) {
	if (size != vec.size) {
		cout << "error::vector::operation 'add'" << endl;
		return *this;
	}
	x += vec.x;
	y += vec.y;
	switch (size)
	{
	case 3:
		z += vec.z;
		break;
	case 4:
		z += vec.z;
		w += vec.w;
		break;
	}
	return *this;
}
Vector Vector::add(double c) {
	x += c;
	y += c;
	switch (size)
	{
	case 3:
		z += c;
		break;
	case 4:
		z += c;
		w += c;
		break;
	}
	return *this;
}

Vector Vector::sub(Vector vec) {
	if (size != vec.size) {
		cout << "error::vector::operation 'sub'" << endl;
		return *this;
	}
	x -= vec.x;
	y -= vec.y;
	switch (size)
	{
	case 3:
		z -= vec.z;
		break;
	case 4:
		z -= vec.z;
		w -= vec.w;
		break;
	}
	return *this;
}
Vector Vector::sub(double c) {
	x -= c;
	y -= c;
	switch (size)
	{
	case 3:
		z -= c;
		break;
	case 4:
		z -= c;
		w -= c;
		break;
	}
	return *this;
}

Vector Vector::mult(double c) {
	x *= c;
	y *= c;
	switch (size)
	{
	case 3:
		z *= c;
		break;
	case 4:
		z *= c;
		w *= c;
		break;
	}
	return *this;
}

double Vector::mag() {
	return sqrt(x * x + y * y + z * z + w * w);
}

Vector Vector::normalize() {
	this->mult(1 / this->mag());
	return *this;
}

Vector Vector::setMag(double c) {
	this->mult(c / this->mag());
	return *this;
}

double scalarProduct(Vector A, Vector B) {
	if (A.size == B.size && A.size < 4) {
		return A.x * B.x + A.y * B.y + A.z * B.z;
	}
	else {
		cout << "error::vector::operation 'scalarProduct'" << endl;
		return 0;
	}
}

Vector vectorProduct(Vector A, Vector B) {
	if (A.size == B.size && A.size == 3) {
		return Vector(A.y * B.z - A.z * B.y, A.z * B.x - A.x * B.z, A.x * B.y - A.y * B.x);
	}
	cout << "error::vector::operation 'vectorProduct'" << endl;
	return Vector(0, 0);
}

double wedgeProduct(Vector A, Vector B) {
	if (A.size == B.size && A.size == 2) {
		return A.x * B.y - B.x * A.y;
	}
	cout << "error::vector::operation 'wedgeProduct'" << endl;
	return 0;
}

double angleBetween(Vector A, Vector B) {
	if (A.size == B.size && A.size < 4) {
		return acos(scalarProduct(A, B) / (A.mag() * B.mag()));
	}
	cout << "error::vector::operation 'angleBetween'" << endl;
	return 0;
}

double radians(double degrees) {
	return degrees * PI / 180.0;
}

double degrees(double radians) {
	return radians * 180.0 / PI;
}