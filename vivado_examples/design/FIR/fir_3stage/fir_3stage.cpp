// 67d7842dbbe25473c3c32b93c0da8047785f30d78e8a024de1b57352245f9689
/*******************************************************************************
Vendor: Xilinx 
Associated Filename: fir_3stage.cpp
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


#include "fir_3stage.h"
#include "hls_fir.h"

struct config_halfband0 : hls::ip_fir::params_t {
    static const double coeff_vec[sg_fir_halfband0_coeffs_len];
    static const unsigned input_length = LENGTH;
    static const unsigned output_length = LENGTH;
    static const unsigned num_coeffs = sg_fir_halfband0_coeffs_len;
    static const unsigned input_width = INPUT_WIDTH_HALFBAND0;
    static const unsigned input_fractional_bits = INPUT_FRACT_WIDTH_HALFBAND0;
    static const unsigned output_width = 18;
    static const unsigned output_fractional_bits = OUTPUT_FRACT_WIDTH_HALFBAND0;
    static const unsigned coeff_width = 18;
    static const unsigned coeff_fractional_bits = 17;
    static const unsigned quantization = hls::ip_fir::quantize_only;
    static const unsigned output_rounding_mode = hls::ip_fir::symmetric_rounding_to_infinity;
    static const unsigned coeff_structure = hls::ip_fir::half_band;
};
const double config_halfband0::coeff_vec[sg_fir_halfband0_coeffs_len] = {
   0.012596,          0,                 -0.1002,           0,
   0.58761,           0.99999,            0.58761,          0,
  -0.1002,            0,                  0.012596
};

struct config_halfband1 : hls::ip_fir::params_t {
    static const double coeff_vec[sg_fir_halfband1_coeffs_len];
    static const unsigned input_length = LENGTH;
    static const unsigned output_length = LENGTH;
    static const unsigned num_coeffs = sg_fir_halfband1_coeffs_len;
    static const unsigned input_width = 18;
    static const unsigned input_fractional_bits = INPUT_FRACT_WIDTH_HALFBAND1;
    static const unsigned output_width = 19;
    static const unsigned output_fractional_bits = OUTPUT_FRACT_WIDTH_HALFBAND1;
    static const unsigned coeff_width = 18;
    static const unsigned coeff_fractional_bits = 17;
    static const unsigned quantization = hls::ip_fir::quantize_only;
    static const unsigned output_rounding_mode = hls::ip_fir::symmetric_rounding_to_infinity;
    static const unsigned coeff_structure = hls::ip_fir::half_band;
};
const double config_halfband1::coeff_vec[sg_fir_halfband1_coeffs_len] = {
    0.00090027,       0,                 -0.0084457,        0,
    0.04052,          0,                 -0.14239,          0,
    0.60941,          0.99999,            0.60941,          0,
   -0.14239,          0,                  0.04052,          0,
   -0.0084457,        0,                  0.00090027
};

struct config_srrc : hls::ip_fir::params_t {
    static const double coeff_vec[sg_fir_srrc_coeffs_len];
    static const unsigned input_length = LENGTH;
    static const unsigned output_length = LENGTH;
    static const unsigned num_coeffs = sg_fir_srrc_coeffs_len;
    static const unsigned input_width = 19;
    static const unsigned input_fractional_bits = INPUT_FRACT_WIDTH_SRRC;
    static const unsigned output_width = 36;
    static const unsigned output_fractional_bits = OUTPUT_FRACT_WIDTH_SRRC;
    static const unsigned coeff_width = 16;
    static const unsigned coeff_fractional_bits = 16;
    static const unsigned quantization = hls::ip_fir::quantize_only;
    static const unsigned coeff_structure = hls::ip_fir::inferred;
};
const double config_srrc::coeff_vec[sg_fir_srrc_coeffs_len] = {
    #include "coeff_srrc.def"
};

template<typename data_t, int LENGTH>
void dummy_process(data_t in[LENGTH], data_t out[LENGTH])
{
    for(unsigned i = 0; i < LENGTH; ++i)
    #pragma HLS pipeline rewind
        out[i] = in[i];
}

void fir_top(data_in_t in[LENGTH],
             data_out_t out[LENGTH])
{
    data_in_t fir_in[LENGTH];
    data_halfband_t data_halfband[LENGTH];
    data_srrc_t data_srrc[LENGTH];    
    data_out_t fir_out[LENGTH];

    hls::FIR<config_halfband0> fir_halfband0;
    hls::FIR<config_halfband1> fir_halfband1;
    hls::FIR<config_srrc> fir_srrc;

    dummy_process<data_in_t, LENGTH>(in, fir_in);
    fir_halfband0.run(fir_in, data_halfband);
    fir_halfband1.run(data_halfband, data_srrc);
    fir_srrc.run(data_srrc, fir_out);
    dummy_process<data_out_t, LENGTH>(fir_out, out);
}


