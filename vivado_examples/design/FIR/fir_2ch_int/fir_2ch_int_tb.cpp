// 67d7842dbbe25473c3c32b93c0da8047785f30d78e8a024de1b57352245f9689
/*******************************************************************************
Vendor: Xilinx 
Associated Filename: fir_2ch_int_tb.cpp
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

#include <iostream>     
#include <fstream>      
#include "fir_2ch_int.h"

using namespace std;

int main() 
{
    int err =0; 

    //set up for reading input stimulus
    ifstream stream_fir_din_i("fir_2ch_int_din_i.txt");
    ifstream stream_fir_din_q("fir_2ch_int_din_q.txt");
    ifstream stream_fir_dout_i_cmodel("fir_2ch_int_dout_i_cmodel.txt");
    ifstream stream_fir_dout_q_cmodel("fir_2ch_int_dout_q_cmodel.txt");

    if (!stream_fir_din_i || !stream_fir_din_q) {
        printf("ERROR: Cant open input data file\n");
        return 1;
    }

    if (!stream_fir_dout_i_cmodel || !stream_fir_dout_q_cmodel) {
        printf("ERROR: Cant open cmodel data file\n");
        return 1;
    }

    din_t din_i[LENGTH];
    din_t din_q[LENGTH]; 
    dout_t dout_i[LENGTH];
    dout_t dout_q[LENGTH];

    for (int idx=0; idx<LENGTH; idx++) {
        
        double din_i_tmp, din_q_tmp;
        stream_fir_din_i >> din_i_tmp;
        din_t i = din_i_tmp;
        din_i[idx] = i;
        stream_fir_din_q >> din_q_tmp;
        din_t q = din_q_tmp;
        din_q[idx] = q;
    }
    stream_fir_din_i.close();
    stream_fir_din_q.close();

    fir_top(din_i, din_q, dout_i, dout_q);

    for (int idx=0; idx<LENGTH; idx++) 
    {
        dout_t i = dout_i[idx];
        dout_t q = dout_q[idx];
        double ref_i; 
        double ref_q;

        stream_fir_dout_i_cmodel >> ref_i;
        stream_fir_dout_q_cmodel >> ref_q;

        if (((abs((i.to_double() - ref_i)/ref_i)) > 0.1)) 
        {
            cout << "Error at " << idx << ": dout_i = " << i.to_double() 
                                            << ", ref_i =" << ref_i << endl;
            err++; 
        }
        if (((abs((q.to_double() - ref_q)/ref_q)) > 0.1)) 
        {
            cout << "Error at " << idx << ": dout_q = " << q.to_double() 
                                            << ", ref_q =" << ref_q << endl;
            err++; 
        }
    }

    stream_fir_dout_i_cmodel.close();
    stream_fir_dout_q_cmodel.close();

    if (err)
        cout << "TEST FAILED" << endl;
    else
        cout << "TEST PASSED" << endl;

    if (err)
        return 1;
    else
        return 0;
}


