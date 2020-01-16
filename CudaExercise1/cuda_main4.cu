// cpu�� gpu �ð� ���� �� �غ���
// �ڵ忡 #if�� �����ߴµ�, ����� �̷��� �ڵ� ¥�� ����.
// ����� ���� �Ұ����ϰ� �Դ���������.

#include "device_launch_parameters.h"
#include <cuda_runtime.h>
#include <stdlib.h>
#include <stdio.h>
#include <iostream>

#define SIZE 1024 * 1024 * 10
#define DEBUG 0
#define TIME_INSTANCE 0

#if TIME_INSTANCE
// �ð� ������ ���� �������
#include <time.h>
#else
// time.h�� ms ������ ������ִµ� �ʹ� ������ Ŀ�� �̼��� �ð��� �� �𸣰ڴ�.
#include <chrono>
#endif

__global__ void kernel_add(int *a, int *b, int *c) {
	//*c = *a + *b;
	// (###)
	c[blockIdx.x] = a[blockIdx.x] + b[blockIdx.x];
#if DEBUG
	printf("%d + %d = %d\n", a[blockIdx.x], b[blockIdx.x], c[blockIdx.x]);
#endif
}

void host_add(int *a, int *b, int *c) {
	for (int i = 0; i < SIZE; i++) {
		c[i] = a[i] + b[i];
	}
}

int main(void) {
#if TIME_INSTANCE
	clock_t start_cpu, end_cpu;
	clock_t start_gpu, end_gpu;
	double result_cpu, result_gpu;
#endif


	int *a = new int[SIZE];
	int *b = new int[SIZE];
	int *c = new int[SIZE];
	int *cpu_a = new int[SIZE];
	int *cpu_b = new int[SIZE];
	int *cpu_c = new int[SIZE];

	int *d_a, *d_b, *d_c;

	cudaMalloc((void**)&d_a, sizeof(int) * SIZE);
	cudaMalloc((void**)&d_b, sizeof(int) * SIZE);
	cudaMalloc((void**)&d_c, sizeof(int) * SIZE);

	for (int i = 0; i < SIZE; i++) {
		a[i] = i;
		b[i] = i;
		cpu_a[i] = i;
		cpu_b[i] = i;
#if DEBUG
		std::cout << a[i] << " " << b[i] << std::endl;
#endif
	}

	// cpu
#if TIME_INSTANCE
	start_cpu = clock();
#else
	auto start_cpu = std::chrono::high_resolution_clock::now();
#endif
	host_add(cpu_a, cpu_b, cpu_c);
#if TIME_INSTANCE
	end_cpu = clock();
	result_cpu = (double)(end_cpu - start_cpu);
#else
	auto end_cpu = std::chrono::high_resolution_clock::now();
	int result_cpu = (int)(end_cpu - start_cpu).count();
#endif

	// gpu
	cudaMemcpy(d_a, a, sizeof(int) * SIZE, cudaMemcpyHostToDevice);
	cudaMemcpy(d_b, b, sizeof(int) * SIZE, cudaMemcpyHostToDevice);

#if TIME_INSTANCE
	start_gpu = clock();
#else
	auto start_gpu = std::chrono::high_resolution_clock::now();
#endif
	kernel_add <<<SIZE, 1 >>> (d_a, d_b, d_c);
#if TIME_INSTANCE
	end_gpu = clock();
	result_gpu = (double)(end_gpu - start_gpu);
#else
	auto end_gpu = std::chrono::high_resolution_clock::now();
	int result_gpu = (int)(end_gpu - start_gpu).count();
#endif

	cudaMemcpy(c, d_c, sizeof(int) * SIZE, cudaMemcpyDeviceToHost);

#if DEBUG
	// ��� ����� ����մϴ�.
	std::cout << "a b c" << std::endl;
	std::cout << a << " " << b << " " << c << std::endl;
	//std::cout << *a << " " << *b << " " << *c << std::endl;
	//std::cout << &a << " " << &b << " " << &c << std::endl;
	for (int i = 0; i < SIZE; ++i)
		printf("c[%d] = %d\n", i, c[i]);
#endif

	// ��� ��� Ȯ��
	for (int i = 0; i < SIZE; i++) {
		if (cpu_c[i] != c[i]) {
			std::cout << " ��� ����Ȯ�� " << i << " Ȯ�� �ʿ� "  << std::endl;
			break;
		}
	}

	std::cout << "### ��� ��Ȯ�� ###" << std::endl;
	std::cout << "cpu �ð�	gpu �ð�" << std::endl;
	std::cout << result_cpu << "ns	" << result_gpu << "ns" << std::endl;
	std::cout << std::endl;
	std::cout << "gpu�� cpu���� " << (result_cpu / result_gpu) << "�� ����" << std::endl;

	delete[] a;
	delete[] b;
	delete[] c;

	cudaFree(d_a);
	cudaFree(d_b);
	cudaFree(d_c);

	system("pause");

	return 0;

}