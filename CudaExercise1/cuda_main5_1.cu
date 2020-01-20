// 이번엔 2차원 행렬 곱에 대해 gpu연산을 수행해서 cpu 대비 시간을 측정해보자
// cpu 행렬곱 연산 코드가 너무 지저분해서 수정한 코드

#include "device_launch_parameters.h"
#include <cuda_runtime.h>
#include <stdlib.h>
#include <stdio.h>
#include <iostream>

// ns 단위의 시간 측정을 위해
#include <chrono>

// matrix 계산을 위해
#include <vector>
// vector 쓰지말고 그냥 직접 메모리 주소로 접근하자

using namespace std;

// cpu 
int *MakeSquareMatrix(int matrix_size) {
	// 2차원 벡터 생성
	int *a = new int[matrix_size * matrix_size];

	// 2차원 벡터 초기화
	for (int i = 0; i < matrix_size*matrix_size; i++) {
		*(a + i) = i + 1;
	}
	cout << "a의 주소값 : " << a << endl;
	return a;
}

int *MatrixMul(int* matrix_A, int* matrix_B, int _matrix_size) {			// 2차원 vector 같은거 쓰지 않고 포인터로 입력받고 출력했다.
	int matrix_size = _matrix_size;
	int *matrix_C = new int[matrix_size*matrix_size];
	for (int i = 0; i < matrix_size*matrix_size; i++) {
		*(matrix_C + i) = 0;
	}

	int temp1, temp2;
	for (int i = 0; i < matrix_size; i++) {
		for (int j = 0; j < matrix_size; j++) {
			int sum = 0;
			for (int k = 0; k < matrix_size; k++) {
				//sum += (matrix_A[i][k] * matrix_B[k][j]);
				sum += (*(matrix_A + (i*matrix_size) + k) * *(matrix_B + (k*matrix_size) + j));
			}
			//matrix_C[i][j] = sum;
			*(matrix_C + (i*matrix_size)+j) = sum;
		}
	}

	return matrix_C;
}

void PrintMatrix(int* matrix, int _matrix_size) {
	// 2차원 벡터 출력
	int matrix_size = _matrix_size;
	for (int i = 0; i < matrix_size * matrix_size; i++) {
		cout << *(matrix + i) << " ";
		if ((i + 1) % _matrix_size == 0)
			cout << endl;
	}
}



// gpu

__global__ void KernelMatrixMul(int* matrix_A, int* matrix_B, int* matrix_C, int matrix_size) {
	int ROW = blockIdx.y*blockDim.y + threadIdx.y;
	int COL = blockIdx.x*blockDim.x + threadIdx.x;

	if (ROW < matrix_size && COL < matrix_size) {
		int temp = 0;
		for (int i = 0; i < matrix_size; i++) {
			temp = matrix_A[ROW*matrix_size + i] * matrix_B[COL*matrix_size + i];
		}
		matrix_C[ROW*matrix_size + COL] = temp;
	}
}


int main(void) {
	// cpu
	// 우선 cpu를 이용한 행렬 곱 연산에 대해 구현합니다.
	// 시간이 얼마나 걸릴지 확인해봅시다.
	int matrix_size = 800;
	int* matrix_A = new int[matrix_size * matrix_size];
	int* matrix_B = new int[matrix_size * matrix_size];
	int* matrix_C = new int[matrix_size * matrix_size];
	matrix_A = MakeSquareMatrix(matrix_size);
	matrix_B = MakeSquareMatrix(matrix_size);

	auto start_cpu = std::chrono::high_resolution_clock::now();
	matrix_C = MatrixMul(matrix_A, matrix_B, matrix_size);
	auto end_cpu = std::chrono::high_resolution_clock::now();
	int result_cpu = (int)(end_cpu - start_cpu).count();
	//cout << " Matrix A" << endl;
	//PrintMatrix(matrix_A, matrix_size);
	//cout << " Matrix B" << endl;
	//PrintMatrix(matrix_B, matrix_size);
	//cout << " Matrix C" << endl;
	//PrintMatrix(matrix_C, matrix_size);

	// gpu
	int *dev_matrix_A = new int[matrix_size*matrix_size];
	int *dev_matrix_B = new int[matrix_size*matrix_size];
	int *dev_matrix_C = new int[matrix_size*matrix_size];

	cudaMemcpy(dev_matrix_A, matrix_A, matrix_size*matrix_size, cudaMemcpyHostToDevice);
	cudaMemcpy(dev_matrix_B, matrix_B, matrix_size*matrix_size, cudaMemcpyHostToDevice);

	auto start_gpu = std::chrono::high_resolution_clock::now();
	KernelMatrixMul <<<matrix_size, matrix_size >>> (dev_matrix_A, dev_matrix_B, dev_matrix_C, matrix_size);
	auto end_gpu = std::chrono::high_resolution_clock::now();
	int result_gpu = (int)(end_gpu - start_gpu).count();

	cudaMemcpy(matrix_C, dev_matrix_C, matrix_size*matrix_size, cudaMemcpyDeviceToHost);

	std::cout << "cpu 시간	gpu 시간" << std::endl;
	std::cout << result_cpu << "ns	" << result_gpu << "ns" << std::endl;
	std::cout << std::endl;
	std::cout << "gpu가 cpu보다 " << ((double)result_cpu / result_gpu) << "배 빠름" << std::endl;

	system("pause");
	return 0;
}