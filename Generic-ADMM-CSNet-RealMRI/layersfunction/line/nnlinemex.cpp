// nnlinemexfixed: learned non-linear function with multi layers
// evaluation mode
//   input:
//     Xlab: 1xM matrix
//     Ylab: MxJ matrix
//     Xvar: HxIxJ matrix
//   output:
//     Yvar: HxIxJ matrix
// back propagation mode
//   input:
//     Xlab: 1xM matrix
//     Ylab: MxJ matrix
//     Xvar: HxIxJ matrix
//     Yvar: HxIxJ matrix
//   output:
//     Xgra: HxIxJ matrix
//     Ygra: MxJ matrix
#include "mex.h"
#include "math.h"
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[])
{
    double *Xlab, *Ylab, *Xvar, *Yvar, *Xgra, *Ygra;
    int i, j, k, l, m, n, p, q;
    
    if(nrhs == 3)
    {
        // evaluation mode
        Xlab = mxGetPr(prhs[0]);
        Ylab = mxGetPr(prhs[1]);
        Xvar = mxGetPr(prhs[2]);
        const int M = mxGetNumberOfElements(prhs[0]);
        const mwSize *Dvar = mxGetDimensions(prhs[2]);
        const int H = Dvar[0];
        const int I = Dvar[1];
        const int J = Dvar[2];
        // mexPrintf("%d, %d, %d", H, I, J);
        const double margin = Xlab[1] - Xlab[0];
        
        plhs[0] = mxCreateNumericArray(3, Dvar, mxDOUBLE_CLASS, mxREAL);
        Yvar = mxGetPr(plhs[0]);
        
        for(j=0; j<J; j++)
        {
            for(n=0; n<H*I; n++)
            {
                p = j*H*I + n;
                k = floor((Xvar[p]-Xlab[0]) / margin);
                q = j*M + k;
                // mexPrintf("p=%d, q=%d, k=%d, %f\n", p, q, k, Xvar[p]);
                if(k<0)
                {
                    Yvar[p] = Xvar[p] - Xlab[0] + Ylab[j*M];
                }
                else if(k>=M-1)
                {
                    Yvar[p] = Xvar[p] - Xlab[M-1] + Ylab[j*M + M-1];
                }
                else
                {
                    Yvar[p] = (Ylab[q+1] - Ylab[q]) * (Xvar[p] - Xlab[k]) / margin + Ylab[q];
                }
            }
        }
    }
    else if(nrhs == 4)
    {
        // back propagation mode
        Xlab = mxGetPr(prhs[0]);
        Ylab = mxGetPr(prhs[1]);
        Xvar = mxGetPr(prhs[2]);
        Yvar = mxGetPr(prhs[3]);
        const int M = mxGetNumberOfElements(prhs[0]);
        const mwSize *Dvar = mxGetDimensions(prhs[2]);
        const int H = Dvar[0];
        const int I = Dvar[1];
        const int J = Dvar[2];
        const double margin = Xlab[1] - Xlab[0];
        
        plhs[0] = mxCreateNumericArray(3, Dvar, mxDOUBLE_CLASS, mxREAL);
        plhs[1] = mxCreateDoubleMatrix(M, J, mxREAL);
        Xgra = mxGetPr(plhs[0]);
        Ygra = mxGetPr(plhs[1]);
        
        for(n=0; n<M*J; n++)
        {
            Ygra[n] = 0;
        }
        for(j=0; j<J; j++)
        {
            for(n=0; n<H*I; n++)
            {
                p = j*H*I + n;
                k = floor((Xvar[p]-Xlab[0]) / margin);
                q = j*M + k;
                if(k<0 || k>M-2)
                {
                    Xgra[p] = 1 * Yvar[p];
                }
                else
                {
                    Xgra[p] = ((Ylab[q+1] - Ylab[q]) / margin) * Yvar[p];
                    Ygra[q] += (1 - (Xvar[p] - Xlab[k]) / margin) * Yvar[p];
                    Ygra[q+1] += (Xvar[p] - Xlab[k]) / margin * Yvar[p];
                }
            }
        }
    }
    else
    {
        mexErrMsgTxt("Invalid input variable number.");
    }
    
}