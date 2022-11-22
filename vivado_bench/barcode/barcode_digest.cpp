#include <ap_int.h>

// A barcode reader.

typedef ap_uint<4> word_t;
typedef ap_uint<3> addr_t; // always 1 bit less than word_t for temporary reasons
typedef ap_uint<6> seed_t;
typedef ap_uint<5> digest_t;


#define WHITE 0
#define BLACK 1

// Used for simulating a pseudo-random infinite sequence of inputs
// (should be replaced by UFs in the future):
inline void seed_gen(seed_t &seed, bool &video)
{
    video = seed < 2; 
    seed = seed * 7 + 1;
}

// Used for accumulating intermediate results:
inline void digest_gen(digest_t &digest, word_t data, addr_t addr, bool flag)
{
    digest = digest * 3 + data + (flag ? addr : -addr);
}


void barcode(seed_t seed, addr_t num_input, digest_t &outp)
{
#pragma HLS interface ap_ctrl_none port=return

//#pragma HLS allocation instances=mul limit=1 operation
    bool video;
    addr_t num = num_input;
    addr_t actnum = 0; // current number of black-white transitions read
    bool flag = WHITE; // color of the current stripe
    word_t width = 0; // width of the current stripe

    word_t data;
    addr_t addr;
    digest_t digest = 0;
    while (actnum != num) {
		//#pragma HLS unroll factor=2
		#pragma HLS latency min=1 max=1
    	//#pragma HLS pipeline II=1
        seed_gen(seed, video);
        if (video != flag) {
            // write the width of the previous stripe to the memory:
            data = width;
            addr = actnum;
            ++actnum;
            width = 0;
            digest_gen(digest, data, addr, flag);
        }
        // update the width of the current stripe:
        flag = video;
        ++width;
    }
    outp = digest;
}
