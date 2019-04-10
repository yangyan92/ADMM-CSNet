#include "mex.h"
#include "gpu/mxGPUArray.h"
#include "math.h"

#define IDX2(X, n1, n2, i1, i2) (X[(i2)*(n1) + (i1)])
#define IDX3(X, n1, n2, n3, i1, i2, i3) (X[(i3)*((n1)*(n2)) + (i2)*(n1) + (i1)])
#define IDX4(X, n1, n2, n3, n4, i1, i2, i3, i4) (X[(i4)*((n1)*(n2)*(n3)) + (i3)*((n1)*(n2)) + (i2)*(n1) + (i1)])

/* nnline_ker evaluate xvar with non-linear functions with control points */
void __global__ nnline_ker(
        const float *xlab, const float *ylab, const float *xvar,
        float *yvar, int M, int N, int D, int P)
{
    int k, l, p, q;
    
    int total_number = M * N * D;
    int n = blockDim.x * blockIdx.x + threadIdx.x;
    int total_threads = gridDim.x * blockDim.x;
    float margin = xlab[1] - xlab[0];
    float margin_inv = 1 / margin;
    for(; n<total_number; n += total_threads)
    {
        // n = idz*MN + idy*M + idx;
        int idx = n % M;
        int idy = (n-idx) % (M*N) / M;
        int idz = (n-idy*M-idx) / (M*N);
       
        k = floor((xvar[n] - xlab[0]) * margin_inv);
        if(k < 0)
        {
            yvar[n] = xvar[n]- xlab[0] + IDX2(ylab, P, D, 0, idz);
        }
        else if(k >= P-1)
        {
            yvar[n] = xvar[n]- xlab[P-1] + IDX2(ylab, P, D, P-1, idz);
        }
        else
        {
            yvar[n] = (IDX2(ylab, P, D, k+1, idz) - IDX2(ylab, P, D, k, idz)) * (xvar[n] - xlab[k]) * margin_inv + IDX2(ylab, P, D, k, idz);
        }
    }
}

/**/
void __global__ nngetp_ker(
        const float *xlab,
        const float *xvar, float *pind,
        int M, int N, int D)
{
    int total_number = M*N*D;
    int n = blockDim.x * blockIdx.x + threadIdx.x;
    int total_threads = gridDim.x * blockDim.x;
    int idx, idy, idz;
    float margin = xlab[1] - xlab[0];
    float margin_inv = 1 / margin;
    for(; n<total_number; n += total_threads)
    {
        idx = n % M;
        idy = (n-idx) % (M*N) / M;
        idz = (n-idy*M-idx) / (M*N);
        
        IDX3(pind, M, N, D, idx, idy, idz) = floor((xvar[n] - xlab[0]) * margin_inv);
    }
}

/* nnback_ker back propagation computing gradients */
void __global__ nnbackx_ker(
        const float *xlab, const float *ylab,
        const float *xvar, const float *yvar,
        float *grad, int M, int N, int D, int P)
{
    int k, l, p, q;
    
    int total_number = M * N * D;
    int n = blockDim.x * blockIdx.x + threadIdx.x;
    int total_threads = gridDim.x * blockDim.x;
    float margin = xlab[1] - xlab[0];
    float margin_inv = 1 / margin;
    for(; n<total_number; n += total_threads)
    {
        // n = idz*MN + idy*M + idx;
        int idx = n % M;
        int idy = (n-idx) % (M*N) / M;
        int idz = (n-idy*M-idx) / (M*N);
     
        k = floor((xvar[n] - xlab[0]) / margin);
        if(k<0 || k>=P-1)
        {
            grad[n] = 1 * yvar[n];
        }
        else
        {
            grad[n] = ((IDX2(ylab, P, D, k+1, idz) - IDX2(ylab, P, D, k, idz)) * margin_inv) * yvar[n];
        }
    }
}

void __global__ nnbackw_ker(
        const float *xlab, const float *ylab,
        const float *xvar, const float *yvar, const float *pind,
        float *grad, int M, int N, int D, int P)
{
  //  __shared__ float INDP[128][128];
  //  __shared__ float L[41];
  //  __shared__ float Y[128][128];
  //  __shared__ float X[128][128];
    
    int m, n, p, q;
    int total_number = D * P;
    int k = blockDim.x * blockIdx.x + threadIdx.x;
    int total_threads = gridDim.x * blockDim.x;
    float margin = xlab[1] - xlab[0];
    float margin_inv = 1 / (margin);
    
    // load global memory to shared memory
    
    
    
    // do computation
    for(; k<total_number; k+=total_threads)
    {
        int idp = k % P;
        int idd = (k-idp) / P;
        float sum = 0;
        for(m=0; m<M; m++)
        {
            for(n=0; n<N; n++)
            {   
                //float temp = ;
                p = (IDX3(pind, M, N, D, m, n, idd));//floor((temp - xlab[0]) / margin);
                //if(p>=0 && p<P-1)
                //{
                    if(p == idp-1 && p>=0 ) //&& p<P-1
                    {
                        // IDX2(grad, P, D, idp, idk) += (1-(IDX3(xvar, M, N, D, m, n, k) - xlab[p]) / margin) * IDX3(yvar, M, N, D, m, n, k);
                        // IDX2(grad, P, D, idp+1, idk) += (IDX3(xvar, M, N, D, m, n, k) - xlab[p]) / margin * IDX3(yvar, M, N, D, m, n, k);
                        sum += (IDX3(xvar, M, N, D, m, n, idd)- xlab[p]) * margin_inv * IDX3(yvar, M, N, D, m, n, idd);
                    }
                    else if(p == idp && p<P-1)
                    {
                        sum += (1 - (IDX3(xvar, M, N, D, m, n, idd) - xlab[p]) * margin_inv) * IDX3(yvar, M, N, D, m, n, idd);
                    }
                //}
                 
            }
        }
        IDX2(grad, P, D, idp, idd) = sum;
    } 
}

void __global__ nnbackw_ker2(
        const float *xlab, const float *ylab,
        const float *xvar, const float *yvar, const float *pind,
        float *grad, int M, int N, int D, int P)
{
    //__shared__ float INDP[128*128];
    __shared__ float L[41];
    //__shared__ float Y[128*128];
    //__shared__ float X[128*128];
    
    int m, n, p, q;
    int total_number = D * P;
    int k = blockDim.x * blockIdx.x + threadIdx.x;
    int total_threads = gridDim.x * blockDim.x;
    float margin = xlab[1] - xlab[0];
    float margin_inv = 1 / (margin);
    
    // load global memory to shared memory
    int idd = blockIdx.x; // t-th channel
    /*for(int t = threadIdx.x; t < M * N; t += blockDim.x)
    {  
       INDP[t] = pind[idd * M * N + t];
    }
    __syncthreads();*/
    
    for(int t = threadIdx.x; t < P; t += blockDim.x)
    {
       L[t] = 0;
    }
    __syncthreads();
    
    // do computation
    for(int t = threadIdx.x; t < M * N; t += blockDim.x)
    {  
       m = t % M;
       n = (t - m) / M; 
       p = pind[idd * M * N + t];
       if(p>=0 && p<P-1)
       {
            float t1 = IDX3(xvar, M, N, D, m, n, idd);
            float t2 = IDX3(yvar, M, N, D, m, n, idd);
            
            L[p] += 1; //(1 - (t1 - xlab[p]) * margin_inv) * t2;
            L[p+1] += 1; //(t1 - xlab[p]) * margin_inv * t2;
       }
    }
    __syncthreads();
    
    for(int t = threadIdx.x; t < P; t += blockDim.x)
    {
       IDX2(grad, P, D, t, idd) = L[t];
    }
    
    /*
    for(; k<total_number; k+=total_threads)
    {
        int idp = k % P;
        int idd = (k-idp) / P;
        float sum = 0;
        for(m=0; m<M; m++)
        {
            for(n=0; n<N; n++)
            {   
                //float temp = ;
                p = INDP; //(IDX3(pind, M, N, D, m, n, idd));//floor((temp - xlab[0]) / margin);
                //if(p>=0 && p<P-1)
                //{
                    if(p == idp-1 && p>=0 ) //&& p<P-1
                    {
                        // IDX2(grad, P, D, idp, idk) += (1-(IDX3(xvar, M, N, D, m, n, k) - xlab[p]) / margin) * IDX3(yvar, M, N, D, m, n, k);
                        // IDX2(grad, P, D, idp+1, idk) += (IDX3(xvar, M, N, D, m, n, k) - xlab[p]) / margin * IDX3(yvar, M, N, D, m, n, k);
                        sum += (IDX3(xvar, M, N, D, m, n, idd)- xlab[p]) * margin_inv * IDX3(yvar, M, N, D, m, n, idd);
                    }
                    else if(p == idp && p<P-1)
                    {
                        sum += (1 - (IDX3(xvar, M, N, D, m, n, idd) - xlab[p]) * margin_inv) * IDX3(yvar, M, N, D, m, n, idd);
                    }
                //}
                 
            }
        }
        IDX2(grad, P, D, idp, idd) = sum;
    } */
}


void mexFunction(int nlhs, mxArray *plhs[], int nrhs, mxArray const *prhs[])
{
    /**/
    mxGPUArray const *xlab;
    mxGPUArray const *ylab;
    mxGPUArray const *xvar;
    float const *d_xlab;
    float const *d_ylab;
    float const *d_xvar;
    int M, N, D, P;
    double margin;
    int i, j, k, l, m, n;
    char const * const errId = "parallel:gpu:mexGPUExample:InvalidInput";
    char const * const errMsg = "Invalid input to MEX file.";
    
    /**/
    int const threadsPerBlock = 256;
    int blocksPerGrid;
    
    /* Initialize the MathWorks GPU API. */
    mxInitGPU();
    
    /**/
    xlab = mxGPUCreateFromMxArray(prhs[0]);
    ylab = mxGPUCreateFromMxArray(prhs[1]);
    xvar = mxGPUCreateFromMxArray(prhs[2]);
    if(mxGPUGetClassID(xlab) != mxSINGLE_CLASS || mxGPUGetClassID(ylab) != mxSINGLE_CLASS || mxGPUGetClassID(xvar) != mxSINGLE_CLASS)
    {
        mexErrMsgIdAndTxt(errId, errMsg);
    }
    d_xlab = (const float *)(mxGPUGetDataReadOnly(xlab));
    d_ylab = (const float *)(mxGPUGetDataReadOnly(ylab));
    d_xvar = (const float *)(mxGPUGetDataReadOnly(xvar));
    
    /* get dimensions */
    const mwSize *xlabdim = mxGPUGetDimensions(xlab);
    const mwSize *ylabdim = mxGPUGetDimensions(ylab);
    const mwSize *xvardim = mxGPUGetDimensions(xvar);
    M = xvardim[0];
    N = xvardim[1];
    D = xvardim[2];
    P = ylabdim[0];
    if(nrhs == 3 && mxIsGPUArray(prhs[0]))
    {
        mxGPUArray *yvar;
        float *d_yvar;
        yvar = mxGPUCreateGPUArray(3, xvardim, mxSINGLE_CLASS, mxREAL, MX_GPU_INITIALIZE_VALUES);
        d_yvar = (float *)(mxGPUGetData(yvar));
        
        /**/
        blocksPerGrid = (N + threadsPerBlock - 1) / threadsPerBlock;
        nnline_ker<<<blocksPerGrid, threadsPerBlock>>>(d_xlab, d_ylab, d_xvar, d_yvar, M, N, D, P);
        plhs[0] = mxGPUCreateMxArrayOnGPU(yvar);
        
        mxGPUDestroyGPUArray(yvar);
    }
    else if(nrhs ==4 && mxIsGPUArray(prhs[0]))
    {
        mxGPUArray const *yvar;
        float const *d_yvar;
        mxGPUArray *xgra;
        mxGPUArray *ygra;
        float *d_xgra;
        float *d_ygra;
        yvar = mxGPUCreateFromMxArray(prhs[3]);
        d_yvar = (const float *)(mxGPUGetDataReadOnly(yvar));
        xgra = mxGPUCreateGPUArray(3, xvardim, mxSINGLE_CLASS, mxREAL, MX_GPU_INITIALIZE_VALUES);
        ygra = mxGPUCreateGPUArray(2, ylabdim, mxSINGLE_CLASS, mxREAL, MX_GPU_INITIALIZE_VALUES);
        d_xgra = (float *)(mxGPUGetData(xgra));
        d_ygra = (float *)(mxGPUGetData(ygra));
        
        /**/
        blocksPerGrid = (N * M * D + threadsPerBlock - 1) / threadsPerBlock;
        nnbackx_ker<<<blocksPerGrid, threadsPerBlock>>>(d_xlab, d_ylab, d_xvar, d_yvar, d_xgra, M, N, D, P);
        mxGPUArray *pind;
        pind = mxGPUCreateGPUArray(3, xvardim, mxSINGLE_CLASS, mxREAL, MX_GPU_INITIALIZE_VALUES);
        float *d_pind;
        d_pind = (float *)(mxGPUGetData(pind));
        nngetp_ker<<<blocksPerGrid, threadsPerBlock>>>(d_xlab, d_xvar, d_pind, M, N, D);
        
        int threadsPerBlock2 = threadsPerBlock;
        blocksPerGrid = (D * P + threadsPerBlock2 - 1) / threadsPerBlock2;
        nnbackw_ker<<<blocksPerGrid, threadsPerBlock2>>>(d_xlab, d_ylab, d_xvar, d_yvar, d_pind, d_ygra, M, N, D, P);
        
        
        plhs[0] = mxGPUCreateMxArrayOnGPU(xgra);
        plhs[1] = mxGPUCreateMxArrayOnGPU(ygra);
        mxGPUDestroyGPUArray(xgra);
        mxGPUDestroyGPUArray(ygra);
        mxGPUDestroyGPUArray(yvar);
        mxGPUDestroyGPUArray(pind);
    }
    else
    {
        mexErrMsgIdAndTxt(errId, errMsg);
    }
    
    mxGPUDestroyGPUArray(xlab);
    mxGPUDestroyGPUArray(ylab);
    mxGPUDestroyGPUArray(xvar);
    
}
















