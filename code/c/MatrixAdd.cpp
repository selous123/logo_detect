#include "MatrixAdd.h"
void MatrixAdd(double *A, double *B, double *C, int M, int N){
    for (int i = 0; i < N; i++){
        for (int j = 0; j < M; j++){
            int offset = i * M + j;
            C[offset] = A[offset] + B[offset];
        }
    }
}
