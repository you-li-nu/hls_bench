// Common header
#include <ap_int.h>
typedef ap_uint<8> dint; // Default to 8 bits
#define INDEX 1 // choose one function from below


// Example: GCD
#if INDEX == 0
void gcd2(dint x_var, dint y_var, dint &gcd_output)
{
#pragma HLS interface ap_ctrl_none port=return
#pragma HLS allocation instances=sub limit=1 operation

    while (x_var != y_var) {
	#pragma HLS unroll factor=2
	#pragma HLS pipeline II=1
    	if (x_var < y_var) {
    		y_var -= x_var;
    	} else {
    		x_var -= y_var;
    	}
    }
    gcd_output = x_var;
}
#endif

// Reverse Integer (ref. https://leetcode.com/problems/reverse-integer/solution/)
// Wraps upon overflow (i.e. result is just modulo 2^N)
#if INDEX == 1
void reverse(dint x, dint &result)
{
#pragma HLS interface ap_ctrl_none port=return
	dint rev = 0;
	while (x != 0) {
	#pragma HLS unroll factor=2
	#pragma HLS pipeline II=1
		rev = rev * 10 + pop;
		x /= 10;
	}
	result = rev;
}
#endif

// Is-Palindrome (ref. https://leetcode.com/problems/palindrome-number/solution/)
#if INDEX == 2
void is_palindrome(dint x, bool &result)
{
#pragma HLS interface ap_ctrl_none port=return
	dint reverted = 0;
	if (x % 10 == 0) {
		result = x == 0;
	} else {
		while (x > reverted) {
		#pragma HLS unroll factor=2
		#pragma HLS pipeline II=1
			reverted = reverted * 10 + x % 10; // won't overflow if bit size >= 7
			x /= 10;
		}
		result = x == reverted || x == reverted / 10;
	}
}
#endif

// Calculate Pow(x, n) (ref. https://leetcode.com/problems/powx-n/solution/)
// Approach 3: Fast Power Algorithm Iterative
// Wraps upon overflow (i.e. result is just modulo 2^N)
#if INDEX == 3
void my_pow(dint x, dint n, dint &result)
{
#pragma HLS interface ap_ctrl_none port=return
#pragma HLS allocation instances=mul limit=2 operation  // may change limit to 1
    dint curr_product = x;
    result = 1;
    while (n > 0) {
        if (n & 1) {
            result *= curr_product;
        }
        curr_product *= curr_product;
        n >>= 1;
    }
}
#endif
