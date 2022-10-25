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
 *     (c) Copyright 2014-2019 Xilinx Inc.
 *     All rights reserved.
 *
 *****************************************************************************/

#ifndef VITERBI_H
#define VITERBI_H

#include <hls_stream.h>
#include "ap_int.h"
#include "hls_dsp.h"

const int ConstraintLength = 7;
const int TracebackLength = 6*ConstraintLength; // Traceback length is at least 6x constraint length for non-punctured data
const bool HasEraseInput = false;
const bool SoftData = false;
const int InputDataWidth = 1;
const int SoftDataFormat = 0;
const int OutputRate = 2;
const int ConvolutionCode0 = 121;
const int ConvolutionCode1 = 91;
const int ConvolutionCode2 = 0;
const int ConvolutionCode3 = 0;
const int ConvolutionCode4 = 0;
const int ConvolutionCode5 = 0;
const int ConvolutionCode6 = 0;

void viterbi_decoder_top(hls::stream< hls::viterbi_decoder_input<OutputRate,InputDataWidth,HasEraseInput> > &inputData,
                         hls::stream< ap_uint<1> > &outputData);

#endif

