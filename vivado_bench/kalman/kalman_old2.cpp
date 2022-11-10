#include <ap_int.h>

// Prototypical kalman filter where input, state, and output are only 2-word long.
// The coefficient arrays are generated by pseudo-randomness.

typedef ap_uint<4> word_t;
typedef ap_uint<6> nonce_t;
typedef ap_uint<2> index_t;
typedef ap_uint<8> word_2x_t;
typedef ap_uint<16> word_4x_t;

// Used for filling a pseudo-random matrix (should be replaced by UFs in the future):
inline word_t load_A_matrix(nonce_t nonce, index_t i, index_t j) { return (nonce >> 0) * (i + 5) + 23 * j; }
inline word_t load_K_matrix(nonce_t nonce, index_t i, index_t j) { return (nonce >> 1) * (i + 3) + 14 * j; }
inline word_t load_G_matrix(nonce_t nonce, index_t i, index_t j) { return (nonce >> 2) * (6 * j + 1) - i; }


void kalman(nonce_t nonce, word_4x_t in_port, word_2x_t &out_port)
{
#pragma HLS interface ap_ctrl_none port=return
#pragma HLS pipeline II=2
#pragma HLS unroll factor=2
//#pragma HLS latency min=1 max=1
//#pragma HLS loop_merge
    // load input vector Y:
    word_t y[2] = { in_port >> 0, in_port >> 4 };

    // load state vector X:
    word_t x[2] = { in_port >> 8, in_port >> 12 };

    // compute next state vector X:
    word_t x_next[2] = { 0, 0 };
    for (index_t i = 0; i < 2; ++i) {
		#pragma HLS loop_flatten
        for (index_t j = 0; j < 2; ++j) {
            word_t a = load_A_matrix(nonce, i, j);
            word_t k = load_K_matrix(nonce, i, j);
            x_next[i] += a * x[j] + k * y[j];
        }
    }

    // compute output vector V:
    word_t v[2] = { 0, 0 };
    for (index_t i = 0; i < 2; ++i) {
		#pragma HLS loop_flatten
        for (index_t j = 0; j < 2; ++j) {
            word_t g = load_G_matrix(nonce, i, j);
            v[i] += g * x_next[j];
        }
    }

    // output vector V:
    out_port = v[0] | (v[1] << 4);
}
