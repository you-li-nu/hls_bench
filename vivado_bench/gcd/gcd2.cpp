#include <ap_int.h>

typedef ap_uint<4> dint;
void gcd2(dint x_var, dint y_var, dint &gcd_output)
{
#pragma HLS interface ap_ctrl_none port=return
#pragma HLS allocation instances=sub limit=2 operation

    while (x_var != y_var) {
	#pragma HLS unroll factor=2
	//#pragma HLS latency min=3 max=3
    //#pragma HLS pipeline II=2
    	if (x_var < y_var) {
    		y_var -= x_var;
    	} else {
    		x_var -= y_var;
    	}
    }
    gcd_output = x_var;
}
