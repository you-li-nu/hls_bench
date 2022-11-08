#include <ap_int.h>

typedef ap_uint<4> word_t;
typedef ap_uint<2> ctrl_t; // 2-bit control signals
typedef ap_uint<6> seed_t;

// Used for simulating a pesudo-random infinite sequence of inputs:
inline void seed_gen(seed_t &seed, ctrl_t &ctrl, word_t &data)
{
    data = seed >> 0;
    ctrl = seed >> 4;
    seed = (seed * 7) % 31;
}

void counter(seed_t seed, word_t &out)
{
#pragma HLS interface ap_ctrl_none port=return
    ctrl_t ctrl;
    word_t data;
    seed_gen(seed, ctrl, data);
    word_t limit = 0;
    word_t count = 0;

    while (ctrl != 0) {
        if (ctrl == 1) { // limit gets loaded
            limit = data;
        } else if (ctrl == 2) { // counts up
            if (count != limit) {
                ++count;
            }
        } else { // counts down
            if (count != limit) {
                --count;
            }
        }
        seed_gen(seed, ctrl, data);
    }
    // ctrl == 0, output and reset:
    out = count;
    count = 0;
}
