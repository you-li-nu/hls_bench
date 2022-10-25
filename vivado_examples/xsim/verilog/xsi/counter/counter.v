`timescale 1 ns/1 ps
module counter_verilog (count, reset, enable, clk);
output [3:0] count;
input reset, enable, clk;
reg [3:0] count_temp = 4'h0;
assign count = count_temp;

always @ (posedge clk)
  begin
     if (reset)
       count_temp <= 4'h0;
     else if (enable)
       count_temp <= count_temp + 4'h01;
  end
endmodule


