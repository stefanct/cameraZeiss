/*
 * timer.c
 *
 * Functions used to compute computation time
 * calculates the average time on 8 measurements
 *
 *  Created on: 07/09/2011
 *      Author: kimbjerge
 */
#include <cuda_runtime.h>
#include "helper_timer.h"
#include "
#include <stdio.h>
#include <stdlib.h>

#define WINDOW 8
static float timerAverage[WINDOW];
static unsigned int idx;

#define cutilSafeCall(err)    __cudaSafeCall(err,__FILE__,__LINE__)
#define cutilCheckError(err)  __cutilCheckError(err, __FILE__, __LINE__)

inline void __cudaSafeCall(cudaError err,
                           const char *file, const int line){
  if(cudaSuccess != err) {
    printf("%s(%i) : cutilSafeCall() Runtime API error : %s.\n",
           file, line, cudaGetErrorString(err) );
    exit(-1);
  }
}

inline void __cutilCheckError( bool err, const char *file, const int line )
{
    if (!err) {
        fprintf(stderr, "CUTIL CUDA error in file <%s>, line %i.\n",
                file, line);
        exit(-1);
    }
}

////////////////////////////////////////////////////////////////////////////////
// Timer functions
////////////////////////////////////////////////////////////////////////////////
void inline CreateTimer(StopWatchInterface **timer)
{
	idx = 0;
	for (int i = 0; i < WINDOW; i++)
		timerAverage[i] = 0;
	cutilCheckError(sdkCreateTimer(timer));
    cutilCheckError(sdkResetTimer(timer));
}

void inline StartTimer(StopWatchInterface **timer)
{
    cutilSafeCall(cudaThreadSynchronize());
    cutilCheckError(sdkStartTimer(timer));
}

void inline StopTimer(StopWatchInterface **timer)
{
    cutilSafeCall(cudaThreadSynchronize());
    cutilCheckError(sdkStopTimer(timer));
    if (idx < WINDOW)
    	timerAverage[idx++] = sdkGetAverageTimerValue(timer);
}

void inline RestartTimer(StopWatchInterface **timer)
{
    cutilCheckError(sdkResetTimer(timer));
    cutilSafeCall(cudaThreadSynchronize());
    cutilCheckError(sdkStartTimer(timer));
}

float inline GetTimer(StopWatchInterface **timer)
{
	return sdkGetAverageTimerValue(timer);
}

float inline GetAverage(StopWatchInterface **timer)
{
	if (idx == WINDOW)
	{
		float sum = 0;
		for (int i = 0; i < WINDOW; i++)
			sum += timerAverage[i];
		sum /= WINDOW;
		idx = 0;
		return sum;
	}
	return 0;
}

void inline DeleteTimer(StopWatchInterface **timer)
{
	cutilCheckError(sdkDeleteTimer(timer));
}

