/*=================================================================
 *
 * \file fastWHtrans.cpp
 *
 *
 * This code computes the (real) fast discrete Walsh-Hadamard transform with sequency order according to the K.G. Beauchamp's book -- Applications of Walsh and Related Functions.
 *
 *
 * This file is written by Chengbo Li from Computational and Applied Mathematics Department of Rice University.
 *
 *
 * This is a MEX-file for MATLAB.  
 *
 *=================================================================*/
#include <math.h>
#include "mex.h"
#include "matrix.h"
//#include <stdlib.h>
//#include <malloc.h>
//#include <stack>


#if !defined(MAX)
#define	MAX(A, B)	((A) > (B) ? (A) : (B))
#endif

#if !defined(MIN)
#define	MIN(A, B)	((A) < (B) ? (A) : (B))
#endif

//! Matlab entry function
/*!
	\param nlhs number of left-hand-side output arguments
	\param plhs mxArray of output arguments
	\param nrhs number of right-hand-side input arguments
	\param prhs mxArray of input arguments
*/
void mexFunction( int nlhs, mxArray *plhs[], 
		  int nrhs, const mxArray*prhs[] )
     
{ 
	int p, nStage, L, flag;
	int i, j, m, n, N, J, K, M;
	double *v_in, *v_out, *v_ext, *v_final, *temp;

	/* Check for proper number of arguments */    
    if (nrhs != 1) { 
		mexErrMsgTxt("Only one input arguments required."); 
	} 
	else if (nlhs > 1) {
		mexErrMsgTxt("Too many output arguments."); 
    }

	/* Get the size and pointers to input data. */
	m  = mxGetM(prhs[0]);
	n  = mxGetN(prhs[0]);


	if (MIN(m,n) != 1) {
		mexErrMsgTxt("Only vectors accepted as input right now."); 
	}

	/* flag == 1, row vector; flag == 0, column vector. */
	flag = 1;
	if ( m != 1) {
		flag = 0;
	}

    /* Make sure that both input and output vectors have the length with 2^p where p is some integer. */ 
	n = MAX(m,n);
	p = (int) ceil(log((double)n)/log(2.0));
    N = 1 << p;	  // pow(2, p)
    // sqrtN = sqrt(N);
	if ( flag == 1) {
		plhs[0] = mxCreateDoubleMatrix(1, N, mxREAL);
	}
	else {
		plhs[0] = mxCreateDoubleMatrix(N, 1, mxREAL);
	}
	v_final = mxGetPr(plhs[0]);
	v_in = mxGetPr(prhs[0]);
	
	/* Extend the input vector if necessary. */
	v_ext = (double*) mxCalloc (N,sizeof(double));
	v_out = (double*) mxCalloc (N,sizeof(double));
	for (j = 0; j <n; j++){
		v_ext[j] = v_in[j];
	}
	// mxDestroyArray(prhs[0]);

	
	for (i=0; i<N-1; i = i+2) {
		v_ext[i] = v_ext[i] + v_ext[i+1];
		v_ext[i+1] = v_ext[i] - v_ext[i+1] * 2;
	}
	L = 1;
    
	/* main loop */
	for (nStage = 2; nStage<=p; ++nStage){
		M = 1 << L;     // pow(2, L)
		J = 0;
		K = 0; // difference between Matlab and C++
		while (K<N-1){
			for (j = J;j < J+M-1; j = j+2){
				/* sequency order  */
				v_out[K] = v_ext[j] + v_ext[j+M];
				v_out[K+1] = v_ext[j] - v_ext[j+M];
				v_out[K+2] = v_ext[j+1] - v_ext[j+1+M];
				v_out[K+3] = v_ext[j+1] + v_ext[j+1+M];

				K = K+4;
			}

			J = J+2*M;
		}

		// for ( i =0; i<N; ++i){
		// 	v_ext[i] = v_out[i];
		// }

		// mxFree(v_ext);
		temp = v_ext;
		v_ext = v_out;
		v_out = temp;
		// v_out = (double*) mxMalloc (N,sizeof(double));

		L = L+1;
	}

	/* Perform scaling of coefficients. */
	for ( i =0; i<N; ++i){
			v_final[i] = v_ext[i]/N;
	}
	
	/* Set free the memory. */
	mxFree(v_out);
	mxFree(v_ext);

    return;
}
