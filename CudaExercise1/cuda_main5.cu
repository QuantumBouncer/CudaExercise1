// �̹��� 2���� ��� ���� ���� gpu������ �����ؼ� cpu ��� �ð��� �����غ���

#include "device_launch_parameters.h"
#include <cuda_runtime.h>
#include <stdlib.h>
#include <stdio.h>
#include <iostream>

// ns ������ �ð� ������ ����
#include <chrono>

// matrix ����� ����
#include <vector>

using namespace std;

// cpu 
vector<vector<int>> MakeSquareMatrix(int matrix_size) {
	// 2���� ���� ����
	vector<vector<int>> a;
	for (int i = 0; i < matrix_size; i++) {
		vector<int> vector_1d(matrix_size);
		a.push_back(vector_1d);
	}

	// 2���� ���� �ʱ�ȭ
	for (int i = 0; i < matrix_size; i++) {
		for (int j = 0; j < matrix_size; j++) {
			a[i][j] = (j + 1) + (i * matrix_size);
		}
	}

	//// 2���� ���� ��� -> �Լ� ������
	//for (int i = 0; i < matrix_size; i++) {
	//	for (int j = 0; j < matrix_size; j++) {
	//		cout << a[i][j] << " ";
	//	}
	//	cout << endl;
	//}

	return a;
}

vector<vector<int>> MatrixMul(vector<vector<int>> matrix_A, vector<vector<int>> matrix_B) {			// �� ���� �Ẹ�ϱ� �����ͷ� �Է� �ִ� �ɷ� �ٲٰ� �ʹ�... �� �ٲ���
	vector<vector<int>> matrix_C;
	int matrix_size = matrix_A.size();
	for (int i = 0; i < matrix_size; i++) {
		vector<int> vector_1d(matrix_size);
		matrix_C.push_back(vector_1d);
	}

	int temp1, temp2;
	for (int i = 0; i < matrix_size; i++) {
		for (int j = 0; j < matrix_size; j++) {
			int sum = 0;
			for (int k = 0; k < matrix_size; k++) {
				sum += (matrix_A[i][k] * matrix_B[k][j]);
			}
			matrix_C[i][j] = sum;
		}
	}

	return matrix_C;
}

void PrintMatrix(vector<vector<int>> matrix) {
	// 2���� ���� ���
	int matrix_size = matrix.size();
	for (int i = 0; i < matrix_size; i++) {
		for (int j = 0; j < matrix_size; j++) {
			cout << matrix[i][j] << " ";
		}
		cout << endl;
	}
	cout << endl;
}



// gpu

__global__ vector<vector<int>> KernelMatrixMul(vector<vector<int>> matrix_A, vector<vector<int>> matrix_B) {

}


int main(void) {
	// cpu
	// �켱 cpu�� �̿��� ��� �� ���꿡 ���� �����մϴ�.
	// �ð��� �󸶳� �ɸ��� Ȯ���غ��ô�.
	int matrix_size = 7;
	vector<vector<int>> matrix_A;
	vector<vector<int>> matrix_B;
	vector<vector<int>> matrix_C;
	matrix_A = MakeSquareMatrix(matrix_size);
	matrix_B = MakeSquareMatrix(matrix_size);
	
	auto start_cpu = std::chrono::high_resolution_clock::now();
	matrix_C = MatrixMul(matrix_A, matrix_B);
	auto end_cpu = std::chrono::high_resolution_clock::now();
	int result_cpu = (int)(end_cpu - start_cpu).count();
	PrintMatrix(matrix_A);
	PrintMatrix(matrix_B);
	PrintMatrix(matrix_C);
	
	// gpu



	system("pause");
	return 0;
}