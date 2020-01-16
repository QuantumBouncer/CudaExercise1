// cuda ���α׷��� ù ������ �ϱ� ���� �⺻ default �ڵ带 �����Դ�.
// ������ �����̴� �켱 c++��Ÿ�� �ڵ��̳� ������, SIZE ���ڸ� �ٲ㰡�� ������ ����� ���캸��
// ���� ���⼭ ��� ���� ���� cuda_main2.cu ���� �ϳ��� �������� ¤� ����

#include "device_launch_parameters.h"
#include <cuda_runtime.h>
#include <stdlib.h>
#include <stdio.h>
#include <iostream>
#define SIZE 1024

// __global__�� ���ؼ� Ŀ������ ǥ���Ѵ�. host���� ȣ��ȴ�.
__global__ void VectorAdd(int *a, int *b, int *c, int n) {
	// ������ �����尡 ���ÿ� ó���Ѵ�.
	// ���� threadIdx(������ �ε���)�� ���ؼ� ��������� �����Ѵ�.
	int i = threadIdx.x;

	printf("threadIdx.x : %d, n : %d\n", i, n);

	for (i = 0; i < n; i++) {
		c[i] = a[i] + b[i];
		printf("%d = %d + %d\n", c[i], a[i], b[i]);
	}
}

int main() {
	//int *a, *b, *c;
	int *d_a, *d_b, *d_c;

	// ȣ��Ʈ�� �޸𸮿� �Ҵ��Ѵ�.
	// = CPU �޸𸮿� �Ҵ�
	//a = (int *)malloc(SIZE * sizeof(int));
	//b = (int *)malloc(SIZE * sizeof(int));
	//c = (int *)malloc(SIZE * sizeof(int));
	//int *a = new int[SIZE * sizeof(int)];
	//int *b = new int[SIZE * sizeof(int)];
	//int *c = new int[SIZE * sizeof(int)];
	int *a = new int[SIZE];
	int *b = new int[SIZE];
	int *c = new int[SIZE];

	//std::cout << a << " " << &a << " " << *a << std::endl;
	//std::cout << b << " " << &b << " " << *b << std::endl;
	//std::cout << c << " " << &c << " " << *c << std::endl;
	//system("pause");

	// cudaMalloc(destination, number of byte)�� device�� �޸𸮸� �Ҵ��Ѵ�.
	// = GPU �޸𸮿� �Ҵ�
	cudaMalloc(&d_a, SIZE * sizeof(int));
	cudaMalloc(&d_b, SIZE * sizeof(int));
	cudaMalloc(&d_c, SIZE * sizeof(int)); 

	// �ʱ�ȭ
	for (int i = 0; i < SIZE; ++i)
	{
		a[i] = i;
		b[i] = 10;
		c[i] = 0;
	} 

	// cudaMemcpy(destination, source, number of byte, cudaMemcpyHostToDevice)�� ȣ��Ʈ���� ����̽��� �޸𸮸� ī���Ѵ�.
	cudaMemcpy(d_a, a, SIZE * sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(d_b, b, SIZE * sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(d_c, c, SIZE * sizeof(int), cudaMemcpyHostToDevice);

	// �Լ� ȣ���� ���ؼ� ���ο� ���ؽ� ��Ҹ� �߰��� �ʿ䰡 �ִ�.
	// ù��° parameter�� ���� ���̴�. ���������� ������ ���� �ϳ��̴�.
	// SIZE�� 1024���� �����带 �ǹ��Ѵ�.
	VectorAdd <<< 1, SIZE >>> (d_a, d_b, d_c, SIZE);

	//cudaMemcpy(source, destination, number of byte, cudaMemDeviceToHost)�� ����̽��� �޸�(���� ��� ������)�� ȣ��Ʈ�� ī���Ѵ�.
	cudaMemcpy(a, d_a, SIZE * sizeof(int), cudaMemcpyDeviceToHost);
	cudaMemcpy(b, d_b, SIZE * sizeof(int), cudaMemcpyDeviceToHost);
	cudaMemcpy(c, d_c, SIZE * sizeof(int), cudaMemcpyDeviceToHost);
	for (int i = 0; i < SIZE; ++i)
		printf("c[%d] = %d\n", i, c[i]);

	// ȣ��Ʈ�� �޸� �Ҵ� ����
	free(a);
	free(b);
	free(c);
	//delete[] a;
	//delete[] b;
	//delete[] c;

	// cudaFree(d_a)�� ���� ����̽��� �޸𸮸� �Ҵ� ����
	cudaFree(d_a);
	cudaFree(d_b);
	cudaFree(d_c);

	system("pause");

	return 0;
}