#pragma once
#include <cuda_runtime.h>
#include "header.h"

#if 1

class CudaTest
{
public:
	CudaTest(void);
	virtual ~CudaTest(void);
	int sum_cuda(int a, int b, int* c);
	int add_cuda(int a, int b, int* c);
};

#endif