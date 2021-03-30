#ifndef MATRIX_H
#define MATRIX_H

//сделать перечисление и указать в нём все возможные типы матриц
enum matrixType {NORMAL, TRANSFORMATION};
//матрицу транформации не может создать пользователь,
//иначе получится так, что пользователю можно умножать матрицу 4x4 на двумерный вектор 

class Vector;

class Matrix {
	double* mat;
	int strokeCount, columnCount;
	matrixType matType;
	bool validMultiplication(Matrix matrix1, Matrix matrix2);
public:
	Matrix();
	Matrix(const double *mat_, int strokeCount_, int columnCount_);
	Matrix(const Matrix& obj);
	~Matrix();

	friend bool validMultiplication(Matrix matrix, Vector vec);
	
	Matrix operator=(Matrix mat);
	Matrix operator=(double c);
	Matrix operator+(Matrix mat);
	Matrix operator+(double c);
	friend Matrix operator+(double c, Matrix mat);
	Matrix operator-(Matrix mat);
	Matrix operator-(double c);
	Matrix operator*(Matrix mat);
	Matrix operator*(double c);
	friend Matrix operator*(double c, Matrix mat);
	friend Vector operator*(Matrix matrix, Vector vec); //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	friend Vector operator*(Vector vec, Matrix matrix); //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	
	
	//первый параметр - объект такого же типа, как и тот объект в который нужно записать матрицу
	//хочешь получить матрицу вращения размером 3x3 передай в первый параметр матрицу 3x3
	friend Matrix getScalingMatrix(Matrix matrix, Vector vec);
	friend Matrix getRotationMatrix(Matrix matrix, double angle, Vector vec); //в радианах
	friend Matrix getShiftMatix(Matrix matrix, Vector vec);
};


//узелок на память
//все функции в которых оперируем и классом vector и matrix - дружественные для обоих классов !!!


class Vector {
	int size;
public:
	double x, y, z, w;
	Vector() { x = y = z = w = 0; size = 4; }
	Vector(double x_, double y_) { x = x_; y = y_; z = w = 0; size = 2; }
	Vector(double x_, double y_, double z_) { x = x_; y = y_; z = z_; w = 0; size = 3; }
	Vector(double x_, double y_, double z_, double w_) { x = x_; y = y_; z = z_; w = w_; size = 4; }

	friend bool validMultiplication(Matrix matrix, Vector vec);
	friend bool validMultiplication(Vector vec, Matrix matrix);

	Vector operator=(Vector vec);
	Vector operator=(double c);
	Vector operator+(Vector vec);
	Vector operator+(double c);
	friend Vector operator+(double c, Vector vec);
	Vector operator-(Vector vec);
	Vector operator-(double c);
	Vector operator*(double c);
	friend Vector operator*(double c, Vector vec);
	friend Vector operator*(Matrix matrix, Vector vec); //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	friend Vector operator*(Vector vec, Matrix matrix); //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

	Vector add(Vector vec);
	Vector add(double c);
	Vector sub(Vector vec);
	Vector sub(double c);
	Vector mult(double c);
	Vector setMag(double c);
	double mag();
	Vector normalize();

	int getSize() { return size; } //!!!!!!!!!!!!!!!!!!!!!!!!!!!!! <- возможно это уже нужно убрать

	friend double scalarProduct(Vector A, Vector B); //скалярное 2D и 3D
	friend Vector vectorProduct(Vector A, Vector B); //векторное 3D
	friend double wedgeProduct(Vector A, Vector B);  //косое 2D
	friend double angleBetween(Vector A, Vector B);  //в радианах (2D и 3D)
};

double radians(double degrees);
double degrees(double radians);
#endif MATRIX_H