
module m();

import "DPI-C" pure function int myFunction ();

int i;

initial
begin
#1;
  i = myFunction();
  if( i == 5)
    $display("PASSED");
  else
    $display("FAILED");
  $finish();
end


endmodule
