#include <ap_int.h>

typedef ap_uint<4> dint;
typedef ap_uint<32> dint_8x;
void ellipf(dint_8x in_ports, dint_8x &out_ports)
{
#pragma HLS interface ap_ctrl_none port=return
#pragma HLS allocation instances=add limit=6 operation
//#pragma HLS pipeline II=2
//#pragma HLS unroll factor=2
//#pragma HLS latency min=2 max=2
	dint n1, n2, n3, n4, n5, n6, n7;
	dint n8, n9, n10, n11, n12, n13;
	dint n14, n15, n16, n17, n18, n19;
	dint n20, n21, n22, n23, n24, n25;
	dint n26, n27, n28, n29;

    dint inp = in_ports >> 0;
    dint sv2 = in_ports >> 4;
    dint sv13 = in_ports >> 8;
    dint sv18 = in_ports >> 12;
    dint sv26 = in_ports >> 16;
    dint sv33 = in_ports >> 20;
    dint sv38 = in_ports >> 24;
    dint sv39 = in_ports >> 28;
    dint sv2_o, sv13_o, sv18_o, sv26_o, sv33_o, sv38_o, sv39_o;
    dint outp;

    // `ellipf` seems to be a combinational circuit,
    // although `sv` somehow sounds like "state variable"?!
    //
    // This while loop is meaningless: there is always an implicit
    // while loop for the entire function?


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
	n17 = n1 + n15;
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
	sv33_o = n19 + n29;
	sv38_o = n29;
	sv39_o = n16 + n24;
	outp = n24;
    // out_ports = (outp << 0) | (sv2_o << 4) | (sv13_o << 8) | (sv18_o << 12) |
        // (sv26_o << 16) | (sv33_o << 20) | (sv38_o << 24) | (sv39_o << 28);
	out_ports =
		((dint_8x)outp << 0) |
		((dint_8x)sv2_o << 4) |
		((dint_8x)sv13_o << 8) |
		((dint_8x)sv18_o << 12) |
		((dint_8x)sv26_o << 16) |
		((dint_8x)sv33_o << 20) |
		((dint_8x)sv38_o << 24) |
		((dint_8x)sv39_o << 28);
}
