// 67d7842dbbe25473c3c32b93c0da8047785f30d78e8a024de1b57352245f9689
/*****************************************************************************
 *
 *     Author: Xilinx, Inc.
 *
 *     This text contains proprietary, confidential information of
 *     Xilinx, Inc. , is distributed by under license from Xilinx,
 *     Inc., and may be used, copied and/or disclosed only pursuant to
 *     the terms of a valid license agreement with Xilinx, Inc.
 *
 *     XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS"
 *     AS A COURTESY TO YOU, SOLELY FOR USE IN DEVELOPING PROGRAMS AND
 *     SOLUTIONS FOR XILINX DEVICES.  BY PROVIDING THIS DESIGN, CODE,
 *     OR INFORMATION AS ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE,
 *     APPLICATION OR STANDARD, XILINX IS MAKING NO REPRESENTATION
 *     THAT THIS IMPLEMENTATION IS FREE FROM ANY CLAIMS OF INFRINGEMENT,
 *     AND YOU ARE RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE
 *     FOR YOUR IMPLEMENTATION.  XILINX EXPRESSLY DISCLAIMS ANY
 *     WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE
 *     IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR
 *     REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF
 *     INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 *     FOR A PARTICULAR PURPOSE.
 *
 *     Xilinx products are not intended for use in life support appliances,
 *     devices, or systems. Use in such applications is expressly prohibited.
 *
 *     (c) Copyright 2013-2019 Xilinx Inc.
 *     All rights reserved.
 *
 *****************************************************************************/

#include "matrix_multiply.h"

// The top-level function to synthesize
//
void matrix_multiply_top(const MATRIX_T A [A_ROWS][A_COLS],
                    const MATRIX_T B [B_ROWS][B_COLS],
                    MATRIX_T C[C_ROWS][C_COLS]){

  MATRIX_T a_i [A_ROWS][A_COLS];
  MATRIX_T b_i [B_ROWS][B_COLS];
  MATRIX_T c_i [C_ROWS][C_COLS];

  // Copy input data to local memory
  a_row_loop : for (int r=0;r<A_ROWS;r++) {
    a_col_loop : for (int c=0;c<A_COLS;c++) {
      a_i[r][c] = A[r][c];
    }
  }
  b_row_loop :  for (int r=0;r<B_ROWS;r++) {
    b_col_loop : for (int c=0;c<B_COLS;c++) {
      b_i[r][c] = B[r][c];
    }
  }

  // Call multiplier
  hls::matrix_multiply <hls::NoTranspose, hls::NoTranspose, A_ROWS, A_COLS, B_ROWS, B_COLS, C_ROWS, C_COLS, MATRIX_T, MATRIX_T> (a_i, b_i, c_i);

  // Copy local memory contents to outputs
  c_row_loop : for (int r=0;r<A_COLS;r++) {
    c_col_loop : for (int c=0;c<B_COLS;c++) {
      C[r][c] = c_i[r][c];
    }
  }

}

