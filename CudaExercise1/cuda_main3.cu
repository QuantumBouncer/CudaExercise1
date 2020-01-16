// kernel �Լ� ȣ���ϱ�
// kernel �Լ��� ������ �����Ѵ�.
// blockIdx�� ����Ͽ� ���� ������ �����ϴ� ���� ��������.

#include "device_launch_parameters.h"
#include <cuda_runtime.h>
#include <stdlib.h>
#include <stdio.h>
#include <iostream>

#define SIZE 100

__global__ void kernel_add(int *a, int *b, int *c) {
	//*c = *a + *b;
	// (###)
	c[blockIdx.x] = a[blockIdx.x] + b[blockIdx.x];
	printf("%d + %d = %d\n", a[blockIdx.x], b[blockIdx.x], c[blockIdx.x]);

}

int main(void) {
	// Host���� ����� �ν��Ͻ���
	//int a, b, c;
	// (###)
	int *a = new int[SIZE];
	int *b = new int[SIZE];
	int *c = new int[SIZE];

	// Device���� ����� �ν��Ͻ���
	int *d_a, *d_b, *d_c;

	// Device�� �޸𸮸� �Ҵ��մϴ�.
	//cudaMalloc((void**)&d_a, sizeof(int));
	//cudaMalloc((void**)&d_b, sizeof(int));
	//cudaMalloc((void**)&d_c, sizeof(int));
	cudaMalloc((void**)&d_a, sizeof(int) * SIZE);
	cudaMalloc((void**)&d_b, sizeof(int) * SIZE);
	cudaMalloc((void**)&d_c, sizeof(int) * SIZE);

	// �Է� ���� �����մϴ�.
	//a = 2;
	//b = 7;
	// (###)
	for (int i = 0; i < SIZE; i++) {
		a[i] = i;
		b[i] = i;
		std::cout << a[i] << " " << b[i] << std::endl;
	}


	// �Է� ���� Device memory ������ �����մϴ�.
	//cudaMemcpy(d_a, &a, sizeof(int), cudaMemcpyHostToDevice);
	//cudaMemcpy(d_b, &b, sizeof(int), cudaMemcpyHostToDevice);
	// (###)
	cudaMemcpy(d_a, a, sizeof(int) * SIZE, cudaMemcpyHostToDevice);
	cudaMemcpy(d_b, b, sizeof(int) * SIZE, cudaMemcpyHostToDevice);

	// kernel_add �Լ��� GPU���� �����մϴ�.
	//kernel_add <<< 1, 1 >>> (d_a, d_b, d_c);
	// ������ ���ڸ� 1,1 ���� N,1�� �ٲ㺾�ô�.
	//kernel_add <<< N, 1 >>> (d_a, d_b, d_c);
	// kernel_add �Լ��� N�� �����϶�� �ǹ��Դϴ�.
	// ���� N�� �����ϰ� �Ǹ� N�� ����� ������ �Լ��� ������ block�̶�� ������ ������ �˴ϴ�.
	// �� �Լ��� ����Ǵ� ������ grid ó�� �и��Ǿ� �ְ�, �̸� block��� �մϴ�.
	// �� �Լ� ���ο����� blockIdx.x�� �ڽ��� block ��ȣ�� Ȯ���� �� �ֽ��ϴ�.
	// �Լ��� ������ ���������� ȣ���Ͽ� ����ϱ� ���� �ڵ带 �ణ �����غ��ô�.(###)
	// (###)
	kernel_add << <SIZE, 1 >> > (d_a, d_b, d_c);
	
	// �Լ��� ����� Device ���� Host Memory�� �����մϴ�.
	//cudaMemcpy(&c, d_c, sizeof(int), cudaMemcpyDeviceToHost);
	// (###)
	cudaMemcpy(c, d_c, sizeof(int) * SIZE, cudaMemcpyDeviceToHost);

	// ��� ����� ����մϴ�.
	std::cout << "a b c" << std::endl;
	std::cout << a << " " << b << " " << c << std::endl;
	//std::cout << *a << " " << *b << " " << *c << std::endl;
	//std::cout << &a << " " << &b << " " << &c << std::endl;
	for (int i = 0; i < SIZE; ++i)
		printf("c[%d] = %d\n", i, c[i]);

	// (###)
	// cpu �޸𸮸� �����մϴ�.
	delete[] a;
	delete[] b;
	delete[] c;

	// gpu �޸𸮸� �����մϴ�.
	cudaFree(d_a);
	cudaFree(d_b);
	cudaFree(d_c);

	system("pause");

	return 0;

}