#include <ap_int.h>

// A barcode reader.

typedef ap_uint<4> word_t;
typedef ap_uint<3> addr_t; // always 1 bit less than word_t for temporary reasons
typedef ap_uint<6> seed_t;


#define WHITE 0
#define BLACK 1

// Used for simulating a pseudo-random infinite sequence of inputs
// (should be replaced by UFs in the future):
inline void seed_gen(seed_t &seed, bool &video)
{
    video = seed < 2; 
    seed = seed * 7 + 1;
}

// INPUTS:
//  num: Given number of black-white transitions

// OUTPUTS:
//  eoc: End of conversion signal to a microproc
//  memw: Write signal for a memory
//  data: Data which should be written to a memory
//  addr: Address signals for a memory
void barcode(seed_t seed, addr_t num, bool &vld, bool &eoc, bool &memw, word_t &data, addr_t &addr)
{
#pragma HLS interface ap_ctrl_none port=return
/* WARN: The Valid Signal is Manually Set (`vld`). DO NOT GENERATE ANOTHER. */
    vld = false;
    eoc = false;

    bool video;
    addr_t actnum = 0; // current number of black-white transitions read
    bool flag = WHITE; // color of the current stripe
    word_t width = 0; // width of the current stripe
    while (actnum != num) {
        seed_gen(seed, video);
        if (video != flag) {
            // write the width of the previous stripe to the memory:
            memw = true;
            data = width;
            addr = actnum;
            ++actnum;
            width = 0;
            vld = true;
        } else {
            vld = false;
            memw = false;
        }
        // update the width of the current stripe:
        flag = video;
        ++width;
    }

    // write the width of the last stripe to the memory:
    eoc = true;
    memw = true;
    data = width;
    addr = actnum;
    vld = true;
}