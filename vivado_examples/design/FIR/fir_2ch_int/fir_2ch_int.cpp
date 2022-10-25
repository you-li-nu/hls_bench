// 67d7842dbbe25473c3c32b93c0da8047785f30d78e8a024de1b57352245f9689
/*******************************************************************************
Vendor: Xilinx 
Associated Filename: fir_2ch_int.cpp
Purpose: Xilinx FIR IP-XACT IP in Vivado HLS
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

#include "fir_2ch_int.h"

struct my_params : hls::ip_fir::params_t {
    static const double coeff_vec[sg_fir_srrc_coeffs_len];
    static const unsigned input_length = LENGTH;
    static const unsigned output_length = LENGTH;
    static const unsigned num_channels = NUM_CHAN;
    static const unsigned num_coeffs = sg_fir_srrc_coeffs_len;
    static const unsigned input_width = INPUT_WIDTH;
    static const unsigned input_fractional_bits = INPUT_FRACTIONAL_BITS;
    static const unsigned output_width = OUTPUT_WIDTH;
    static const unsigned output_fractional_bits = OUTPUT_FRACTIONAL_BITS;
    static const unsigned coeff_width = COEFF_WIDTH;
    static const unsigned coeff_fractional_bits = COEFF_FRACTIONAL_BITS;
    static const unsigned coeff_structure = hls::ip_fir::inferred;
    static const unsigned quantization = hls::ip_fir::quantize_only;
};
const double my_params::coeff_vec[sg_fir_srrc_coeffs_len] = {
   -3.0517578125e-05, -3.0517578125e-05, -3.0517578125e-05,                 0,
   4.57763671875e-05,   6.103515625e-05,                 0,-7.62939453125e-05,
  -0.0001068115234375, -3.0517578125e-05,   0.0001220703125, 0.000213623046875,
  0.0001068115234375,-0.000152587890625,-0.0003814697265625,-0.000335693359375,
     6.103515625e-05, 0.000518798828125, 0.000640869140625, 0.000213623046875,
  -0.000518798828125, -0.00091552734375,-0.000518798828125,     0.00048828125,
      0.001220703125,  0.00079345703125,   -0.000732421875,-0.002105712890625,
  -0.001693725585938,0.0009307861328125, 0.004074096679688, 0.004730224609375,
   0.000885009765625,-0.005950927734375, -0.01077270507813,-0.008087158203125,
    0.00323486328125,  0.01722717285156,  0.02290344238281,  0.01150512695313,
   -0.01542663574219, -0.04301452636719, -0.04855346679688, -0.01406860351563,
    0.06101989746094,   0.1555786132813,   0.2343902587891,   0.2650299072266,
     0.2343902587891,   0.1555786132813,  0.06101989746094, -0.01406860351563,
   -0.04855346679688, -0.04301452636719, -0.01542663574219,  0.01150512695313,
    0.02290344238281,  0.01722717285156,  0.00323486328125,-0.008087158203125,
   -0.01077270507813,-0.005950927734375, 0.000885009765625, 0.004730224609375,
   0.004074096679688,0.0009307861328125,-0.001693725585938,-0.002105712890625,
     -0.000732421875,  0.00079345703125,    0.001220703125,     0.00048828125,
  -0.000518798828125, -0.00091552734375,-0.000518798828125, 0.000213623046875,
   0.000640869140625, 0.000518798828125,   6.103515625e-05,-0.000335693359375,
  -0.0003814697265625,-0.000152587890625,0.0001068115234375, 0.000213623046875,
     0.0001220703125, -3.0517578125e-05,-0.0001068115234375,-7.62939453125e-05,
                   0,   6.103515625e-05, 4.57763671875e-05,                 0,
   -3.0517578125e-05, -3.0517578125e-05, -3.0517578125e-05
};


void dummy_fe(din_t din_i[LENGTH], din_t din_q[LENGTH], din_t out[FIR_LENGTH])
{
    for (unsigned i = 0; i < LENGTH; ++i)
    {
        out[2*i] = din_i[i];
        out[2*i + 1] = din_q[i];
    }
}

void dummy_be(dout_t in[FIR_LENGTH], dout_t dout_i[LENGTH], dout_t dout_q[LENGTH])
{
    for(unsigned i = 0; i < LENGTH; ++i)
    {
        dout_i[i] = in[2*i];
        dout_q[i] = in[2*i+1];
    }
}

void fir_top(din_t din_i[LENGTH], din_t din_q[LENGTH],
             dout_t dout_i[LENGTH], dout_t dout_q[LENGTH])
{
    din_t fir_in[FIR_LENGTH];
    dout_t fir_out[FIR_LENGTH];

    static hls::FIR<my_params> fir1;

    dummy_fe(din_i, din_q, fir_in);
    fir1.run(fir_in, fir_out);
    dummy_be(fir_out, dout_i, dout_q);
}

