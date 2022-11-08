#include <ap_int.h>

typedef ap_uint<4> dint;
void ellipf(dint inp, dint &outp, dint sv2, dint sv13, dint sv18, dint sv26, dint sv33, dint sv38, dint sv39, dint &sv2_o, dint &sv13_o, dint &sv18_o, dint &sv26_o, dint &sv33_o, dint &sv38_o, dint &sv39_o)
{
#pragma HLS interface ap_ctrl_none port=return
#pragma HLS allocation instances=add limit=2 operation
	dint n1, n2, n3, n4, n5, n6, n7;
	dint n8, n9, n10, n11, n12, n13;
	dint n14, n15, n16, n17, n18, n19;
	dint n20, n21, n22, n23, n24, n25;
	dint n26, n27, n28, n29;

    while (true) {
    	n1 = inp + sv2;
    	n2 = sv33 + sv39;
    	n3 = n1 + sv13;
    	n4 = n3 + sv26;
    	n5 = n4 + n2;
    	n6 = n5;
    	n7 = n5;
    	n8 = n3 + n6;
    	n9 = n7 + n2;
    	n10 = n3 + n8;
    	n11 = n8 + n5;
    	n12 = n2 + n9;
    	n13 = n10;
    	n14 = n12;
    	n15 = n1 + n13;
    	n16 = n14 + sv39;
    	n17 + n1 + n15;
    	n18 = n15 + n8;
    	n19 = n9 + n16;
    	n20 = n16 + sv39;
    	n21 = n17;
    	n22 = n18 + sv18;
    	n23 = sv38 + n19;
    	n24 = n20;
    	n25 = inp + n21;
    	n26 = n22;
    	n27 = n23;
    	n28 = n26 + sv18;
    	n29 = n27 + sv38;
    	sv2_o = n25 + n15;
    	sv13_o = n17 + n28;
    	sv18_o = n28;
    	sv26_o = n9 + n11;
    	sv38_o = n29;
    	sv33_o = n19 + n29;
    	sv39_o = n16 + n24;
    	outp = n24;
    }
}
