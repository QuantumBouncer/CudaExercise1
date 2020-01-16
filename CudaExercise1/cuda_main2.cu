// kernel �Լ� ȣ���ϱ�
// kernel �Լ��� ���� �ƹ��͵� ����

#include "device_launch_parameters.h"
#include <cuda_runtime.h>
#include <stdlib.h>
#include <stdio.h>
#include <iostream>
#define SIZE 1024

__global__ void mykernel(void) {
	// __global__�� �ǹ�
	// Device(GPU) ���� ����˴ϴ�.
	// Host(CPU) ���� ȣ��˴ϴ�.

	// Device Function(Device���� ����Ǵ� �Լ�)�� NVIDIA compiler�� ���� ó���˴ϴ�.
}

int main() {
	// Host Function(Host���� ����Ǵ� �Լ�)�� �Ϲ� compiler�� ���� ó���˴ϴ�.
	// <<< >>> �����ȣ 3���� Host�� Device�� ȣ���Ѵٰ� ��ŷ�ϴ� ���Դϴ�.
	// kernel launch ��� �մϴ�.
	// 
	mykernel << <1, 1 >> > ();
	std::cout << "Hello World!" << std::endl;

	system("pause");

	return 0;
}
