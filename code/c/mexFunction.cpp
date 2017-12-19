#include <mex.h>
#include "MatrixAdd.h"
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]){
    if (nrhs != 2){
        mexErrMsgTxt("Two input arguments required.");
    }
    else if (nlhs != 1){
        mexErrMsgTxt("Too many output arguments.");
    }
    int M = mxGetM(prhs[0]);
    int N = mxGetN(prhs[0]);
    if ((M != mxGetM(prhs[1])) || N != mxGetN(prhs[1])){
        mexErrMsgTxt("Matrix dimensions must agree.");
    }
    double *A = mxGetPr(prhs[0]);
    double *B = mxGetPr(prhs[1]);
    plhs[0] = mxCreateDoubleMatrix(M, N, mxREAL);
    double *C = mxGetPr(plhs[0]);
    MatrixAdd(A,B,C,M,N);
}
