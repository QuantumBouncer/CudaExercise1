// kernel 함수 호출하기
// kernel 함수가 덧셈을 수행한다.
// blockIdx를 사용하여 병렬 연산을 수행하는 것을 연습하자.

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
	// Host에서 사용할 인스턴스들
	//int a, b, c;
	// (###)
	int *a = new int[SIZE];
	int *b = new int[SIZE];
	int *c = new int[SIZE];

	// Device에서 사용할 인스턴스들
	int *d_a, *d_b, *d_c;

	// Device에 메모리를 할당합니다.
	//cudaMalloc((void**)&d_a, sizeof(int));
	//cudaMalloc((void**)&d_b, sizeof(int));
	//cudaMalloc((void**)&d_c, sizeof(int));
	cudaMalloc((void**)&d_a, sizeof(int) * SIZE);
	cudaMalloc((void**)&d_b, sizeof(int) * SIZE);
	cudaMalloc((void**)&d_c, sizeof(int) * SIZE);

	// 입력 값을 설정합니다.
	//a = 2;
	//b = 7;
	// (###)
	for (int i = 0; i < SIZE; i++) {
		a[i] = i;
		b[i] = i;
		std::cout << a[i] << " " << b[i] << std::endl;
	}


	// 입력 값을 Device memory 영역에 복사합니다.
	//cudaMemcpy(d_a, &a, sizeof(int), cudaMemcpyHostToDevice);
	//cudaMemcpy(d_b, &b, sizeof(int), cudaMemcpyHostToDevice);
	// (###)
	cudaMemcpy(d_a, a, sizeof(int) * SIZE, cudaMemcpyHostToDevice);
	cudaMemcpy(d_b, b, sizeof(int) * SIZE, cudaMemcpyHostToDevice);

	// kernel_add 함수를 GPU에서 실행합니다.
	//kernel_add <<< 1, 1 >>> (d_a, d_b, d_c);
	// 꺾쇠의 인자를 1,1 에서 N,1로 바꿔봅시다.
	//kernel_add <<< N, 1 >>> (d_a, d_b, d_c);
	// kernel_add 함수를 N번 실행하라는 의미입니다.
	// 만약 N번 실행하게 되면 N번 실행된 각각의 함수가 고유의 block이라는 참조를 가지게 됩니다.
	// 각 함수가 실행되는 영역이 grid 처럼 분리되어 있고, 이를 block라고 합니다.
	// 각 함수 내부에서는 blockIdx.x로 자신의 block 번호를 확인할 수 있습니다.
	// 함수를 여러번 병렬적으로 호출하여 계산하기 위해 코드를 약간 수정해봅시다.(###)
	// (###)
	kernel_add << <SIZE, 1 >> > (d_a, d_b, d_c);
	
	// 함수의 결과를 Device 에서 Host Memory로 복사합니다.
	//cudaMemcpy(&c, d_c, sizeof(int), cudaMemcpyDeviceToHost);
	// (###)
	cudaMemcpy(c, d_c, sizeof(int) * SIZE, cudaMemcpyDeviceToHost);

	// 계산 결과를 출력합니다.
	std::cout << "a b c" << std::endl;
	std::cout << a << " " << b << " " << c << std::endl;
	//std::cout << *a << " " << *b << " " << *c << std::endl;
	//std::cout << &a << " " << &b << " " << &c << std::endl;
	for (int i = 0; i < SIZE; ++i)
		printf("c[%d] = %d\n", i, c[i]);

	// (###)
	// cpu 메모리를 해제합니다.
	delete[] a;
	delete[] b;
	delete[] c;

	// gpu 메모리를 해제합니다.
	cudaFree(d_a);
	cudaFree(d_b);
	cudaFree(d_c);

	system("pause");

	return 0;

}