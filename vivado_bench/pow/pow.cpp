#include <ap_int.h>
typedef ap_uint<8> dint;

void pow(dint x, dint n, dint &result)
{
#pragma HLS interface ap_ctrl_none port=return
#pragma HLS allocation instances=mul limit=2 operation  // may change limit to 1
    dint curr_product = x;
    result = 1;
    while (n > 0) {
        #pragma HLS unroll factor=2
		#pragma HLS pipeline II=1
        if (n & 1) {
            result *= curr_product;
        }
        curr_product *= curr_product;
        n >>= 1;
    }
}
