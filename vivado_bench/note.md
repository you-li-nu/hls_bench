## AMD Xilinx Vivado

## HLS pragmas

`https://china.xilinx.com/htmldocs/xilinx2019_1/sdsoc_doc/hls-pragmas-okr1504034364623.html`

## Initiation Interval

The initiation interval (II), is the number of clock cycles between the launch of successive loop iterations.

For a loop that has an iteration latency (B) of 3:

II = 3: (sequential)

□□□
   □□□
      □□□

II = 2:

□□□
  □□□
    □□□

II = 1：

□□□
 □□□
  □□□

A small II may not be achievable due to data dependency.

gcd_a_b.v: iteration latency = a, initiation interval = b.

## Example

```
#include <ap_int.h>

typedef ap_uint<4> dint;
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

```

## Approaches

### I/O

Turn off block I/O protocols, only clk, valid and reset remain.

`#pragma HLS interface ap_ctrl_none port=return`

### Resource allocation

Limit the number of available operators within one clock cycle.

`#pragma HLS allocation instances=sub limit=1 operation`

### Loop unrolling

Unroll loops by k times.

`#pragma HLS unroll factor=2`

### Loop pipelining

See the Initiation Interval part for an example.

If II=k is not achievable, it will select the smallest possible II instead.

`#pragma HLS pipeline II=1`