#include <ap_int.h>

// The FANCY benchmark (I don't know what it does, though)
// Seems to be a silly obfuscation of some simple code...

typedef ap_uint<4> word_t;
typedef ap_uint<12> word_3x_t;

// void fancy(bool startinp, word_3x_t abc, word_t &f)
void fancy(word_3x_t abc, word_t &f)
{
	#pragma HLS interface ap_ctrl_none port=return
	//#pragma HLS allocation instances=mul limit=1 operation

    word_t a = abc >> 0;
    word_t b = abc >> 4;
    word_t c = abc >> 8;
    // bool start = startinp;
    bool start = (a ^ b ^ c) & 1; // otherwise dangling wire?!?!

    word_t temp1a = 0, temp1b, temp3, temp4, temp6a;
    word_t counter = 0;
    while (counter < b) {
		//#pragma HLS unroll factor=4
		//#pragma HLS latency min=3 max=3
    	//#pragma HLS pipeline II=1
        if (a <= counter) {
            if (a <= counter) {
                temp6a = b;
            } else {
                temp6a = temp1a;
            }
        } else {
            temp6a = a;
        }

        if ((temp1a == 0) ^ (a > counter) ^ (a <= counter) ^ start) {
            temp1b = c;
        } else {
            if (a > b) {
                temp1b = a;
            } else {
                temp1b = b;
            }
        }

        if (start) {
            temp4 = temp1b;
        } else {
            temp4 = temp6a;
        }

        if (start ^ (a > b)) {
            if (b > c) {
                temp3 = c;
            } else {
                temp3 = b;
            }
        } else {
            temp3 = temp1b;
        }

        if ((temp1a == 0) ^ (a > counter) ^ (a <= counter)) {
            temp1a = temp4 + temp3;
        } else {
            if ((a > b) ^ (b > c)) {
                temp1a = temp4 + temp1a;
            } else {
                temp1a = temp4 + a;
            }
        }

        counter = counter + 1;
    }

    f = temp1a;
}
