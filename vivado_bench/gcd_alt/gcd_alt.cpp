#include <ap_int.h>

typedef ap_uint<4> dint;
void gcd_alt(dint x_var, dint y_var, dint &gcd_output)
{
#pragma HLS interface ap_ctrl_none port=return
//#pragma HLS allocation instances=sub limit=1 operation

	dint tmp_var;
    while (x_var != y_var) {
	#pragma HLS unroll factor=2
	//#pragma HLS latency min=2 max=2
    #pragma HLS pipeline II=3
    	if (x_var > y_var) {
    		x_var -= y_var;
    	} else {
    		tmp_var = x_var;
    		x_var = y_var;
    		y_var = tmp_var;
    	}
    }
    gcd_output = x_var;
}
