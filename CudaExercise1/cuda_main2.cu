// kernel 함수 호출하기
// kernel 함수가 아직 아무것도 안함

#include "device_launch_parameters.h"
#include <cuda_runtime.h>
#include <stdlib.h>
#include <stdio.h>
#include <iostream>
#define SIZE 1024

__global__ void mykernel(void) {
	// __global__의 의미
	// Device(GPU) 에서 실행됩니다.
	// Host(CPU) 에서 호출됩니다.

	// Device Function(Device에서 실행되는 함수)은 NVIDIA compiler에 의해 처리됩니다.
}

int main() {
	// Host Function(Host에서 실행되는 함수)은 일반 compiler에 의해 처리됩니다.
	// <<< >>> 꺾쇠괄호 3번은 Host가 Device를 호출한다고 마킹하는 것입니다.
	// kernel launch 라고도 합니다.
	// 
	mykernel << <1, 1 >> > ();
	std::cout << "Hello World!" << std::endl;

	system("pause");

	return 0;
}
