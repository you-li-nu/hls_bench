// The easy version of diffeq. Still solving a differential equation, but
// the parameters `dx` and `a` are now hardcoded, rather than user-specified.

#include <ap_int.h>

// Hardcoded parameters:
#define a_var 15
#define dx_var 1

typedef ap_uint<4> dint;
typedef ap_uint<12> dint_3x;
void diffeq_easy(dint_3x vars, dint &Xoutport, dint &Youtport, dint &Uoutport)
{
#pragma HLS interface ap_ctrl_none port=return
// #pragma HLS allocation instances=mul limit=1 operation
	dint x_var = vars >> 0;
	dint y_var = vars >> 4;
	dint u_var = vars >> 8;
	dint x1, y1, t1, t2, t3, t4, t5, t6;
    while (x_var < a_var) {
    	t1 = u_var * dx_var;
    	t2 = 3 * x_var;
    	t3 = 3 * y_var;
    	t4 = t1 * t2;
    	t5 = dx_var * t3;
    	t6 = u_var - t4;

    	u_var = t6 - t5;
    	y1 = u_var * dx_var;
    	y_var = y_var + y1;
    	x_var = x_var + dx_var;
    }
    Xoutport = x_var;
    Youtport = y_var;
    Uoutport = u_var;
}