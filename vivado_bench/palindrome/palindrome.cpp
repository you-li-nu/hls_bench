#include <ap_int.h>
typedef ap_uint<8> dint;

void palindrome(dint x, bool &result)
{
#pragma HLS interface ap_ctrl_none port=return
	dint reverted = 0;
	if (x % 10 == 0) {
		result = x == 0;
	} else {
		while (x > reverted) {
			reverted = reverted * 10 + x % 10; // won't overflow if bit size >= 7
			x /= 10;
		}
		result = x == reverted || x == reverted / 10;
	}
}
