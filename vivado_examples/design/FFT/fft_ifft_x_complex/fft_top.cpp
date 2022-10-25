// 67d7842dbbe25473c3c32b93c0da8047785f30d78e8a024de1b57352245f9689
/*******************************************************************************
Vendor: Xilinx 
Associated Filename: fft_top.cpp
Purpose: Xilinx FFT IP-XACT IP in Vivado HLS
Revision History: September 26, 2013 - initial release
                                                
*******************************************************************************
#-  (c) Copyright 2011-2019 Xilinx, Inc. All rights reserved.
#-
#-  This file contains confidential and proprietary information
#-  of Xilinx, Inc. and is protected under U.S. and
#-  international copyright and other intellectual property
#-  laws.
#-
#-  DISCLAIMER
#-  This disclaimer is not a license and does not grant any
#-  rights to the materials distributed herewith. Except as
#-  otherwise provided in a valid license issued to you by
#-  Xilinx, and to the maximum extent permitted by applicable
#-  law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
#-  WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
#-  AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
#-  BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
#-  INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
#-  (2) Xilinx shall not be liable (whether in contract or tort,
#-  including negligence, or under any other theory of
#-  liability) for any loss or damage of any kind or nature
#-  related to, arising under or in connection with these
#-  materials, including for any direct, or any indirect,
#-  special, incidental, or consequential loss or damage
#-  (including loss of data, profits, goodwill, or any type of
#-  loss or damage suffered as a result of any action brought
#-  by a third party) even if such damage or loss was
#-  reasonably foreseeable or Xilinx had been advised of the
#-  possibility of the same.
#-
#-  CRITICAL APPLICATIONS
#-  Xilinx products are not designed or intended to be fail-
#-  safe, or for use in any application requiring fail-safe
#-  performance, such as life-support or safety devices or
#-  systems, Class III medical devices, nuclear facilities,
#-  applications related to the deployment of airbags, or any
#-  other applications that could lead to death, personal
#-  injury, or severe property or environmental damage
#-  (individually and collectively, "Critical
#-  Applications"). Customer assumes the sole risk and
#-  liability of any use of Xilinx products in Critical
#-  Applications, subject only to applicable laws and
#-  regulations governing limitations on product liability.
#-
#-  THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
#-  PART OF THIS FILE AT ALL TIMES. 
#- ************************************************************************


This file contains confidential and proprietary information of Xilinx, Inc. and 
is protected under U.S. and international copyright and other intellectual 
property laws.

DISCLAIMER
This disclaimer is not a license and does not grant any rights to the materials 
distributed herewith. Except as otherwise provided in a valid license issued to 
you by Xilinx, and to the maximum extent permitted by applicable law: 
(1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND WITH ALL FAULTS, AND XILINX 
HEREBY DISCLAIMS ALL WARRANTIES AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, 
INCLUDING BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-INFRINGEMENT, OR 
FITNESS FOR ANY PARTICULAR PURPOSE; and (2) Xilinx shall not be liable (whether 
in contract or tort, including negligence, or under any other theory of 
liability) for any loss or damage of any kind or nature related to, arising under 
or in connection with these materials, including for any direct, or any indirect, 
special, incidental, or consequential loss or damage (including loss of data, 
profits, goodwill, or any type of loss or damage suffered as a result of any 
action brought by a third party) even if such damage or loss was reasonably 
foreseeable or Xilinx had been advised of the possibility of the same.

CRITICAL APPLICATIONS
Xilinx products are not designed or intended to be fail-safe, or for use in any 
application requiring fail-safe performance, such as life-support or safety 
devices or systems, Class III medical devices, nuclear facilities, applications 
related to the deployment of airbags, or any other applications that could lead 
to death, personal injury, or severe property or environmental damage 
(individually and collectively, "Critical Applications"). Customer assumes the 
sole risk and liability of any use of Xilinx products in Critical Applications, 
subject only to applicable laws and regulations governing limitations on product 
liability. 

THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS PART OF THIS FILE AT 
ALL TIMES.

*******************************************************************************/

#include "fft_top.h"

void dummy_proc_fe(
    bool direction,
    config_t* config, 
    cmpxData in[FFT_LENGTH], 
    cmpxData out[FFT_LENGTH])
{
    int i; 
    config->setDir(direction);
    config->setSch(0x2AB);
    for (i=0; i< FFT_LENGTH; i++)
        out[i] = in[i];
}

void dummy_proc_middle (
    config_t* config_in,
    config_t* config_out,
    status_t* st_in,
    cmpxData in[FFT_LENGTH],
    cmpxData out[FFT_LENGTH])
{
    ap_uint<1> dir = config_in->getDir();
    if (dir == 1)
        config_out->setDir(0);
    else
        config_out->setDir(1);
        
    config_out->setSch(config_in->getSch());
    int i; 
    bool ovflw= st_in->getOvflo();

    for (i=0; i< FFT_LENGTH; i++)
    {
        data_t re, im;
        cmpxData in_temp = in[i];
        if (ovflw && (in_temp.real() < (data_t)(-1.0) || in_temp.real() >= (data_t)(1.0)))
            re = in_temp.real() - (int)(in_temp.real());
        else
            re = in_temp.real();

        if (ovflw && (in_temp.imag() < (data_t)(-1.0) || in_temp.imag() >= (data_t)(1.0)))
            im = in_temp.imag() - (int)(in_temp.imag());
        else
            im = in_temp.imag();

        out[i] = cmpxData(re, im);
    }
}

void dummy_proc_be(
    status_t* status_in, 
    bool* ovflo,
    cmpxData in[FFT_LENGTH], 
    cmpxData out[FFT_LENGTH])
{
    int i; 
    *ovflo = status_in->getOvflo();
    for (i=0; i< FFT_LENGTH; i++)
        out[i] = in[i];
}


void fft_top(
    bool direction,
    cmpxData in[FFT_LENGTH],
    cmpxData out[FFT_LENGTH],
    bool* ovflo)
{
#pragma HLS interface ap_hs port=direction
#pragma HLS interface ap_fifo depth=1 port=ovflo
#pragma HLS interface ap_fifo depth=1024 port=in,out
#pragma HLS data_pack variable=in
#pragma HLS data_pack variable=out
#pragma HLS dataflow
   
    cmpxData xn1[FFT_LENGTH];
    cmpxData xk1[FFT_LENGTH];
    status_t fft_status1;
    config_t fft_config1;

    cmpxData xn2[FFT_LENGTH];
    cmpxData xk2[FFT_LENGTH];
    status_t fft_status2;
    config_t fft_config2;

#pragma HLS data_pack variable=fft_config1
#pragma HLS data_pack variable=fft_config2
   
    dummy_proc_fe(direction, &fft_config1, in, xn1);

      // FFT IP
    hls::fft<config1> 
    (xn1, xk1, &fft_status1, &fft_config1);

    dummy_proc_middle(&fft_config1, &fft_config2, &fft_status1, xk1, xn2);

    hls::fft<config1> 
    (xn2, xk2, &fft_status2, &fft_config2);
    
    dummy_proc_be(&fft_status2, ovflo, xk2, out);
}

