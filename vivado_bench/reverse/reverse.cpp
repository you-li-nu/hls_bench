#include <ap_int.h>
typedef ap_uint<8> dint;

void reverse(dint x, dint &result)
{
#pragma HLS interface ap_ctrl_none port=return
	dint rev = 0;
	dint pop = 0;
	while (x != 0) {
	#pragma HLS unroll factor=2
	#pragma HLS pipeline II=1
		rev = rev * 10 + pop;
		x /= 10;
		pop %= 10;
	}
	result = rev;
}
