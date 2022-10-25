
module TOP();

  export "DPI-C" function svFunc ; 

  int svValue ;

  function int svFunc(input int x) ;
    svValue = x + 1 ;
    return svValue + 3 ;
  endfunction

  import "DPI-C" function int cFunc(input int x) ;

  int result ;
  
  initial
  begin
    svValue = 15 ;
    result = cFunc(3) ;
    if (svValue != 4)
    begin
      $display("FAILED") ;
      $finish ;
    end
    if (result == 7)
      $display("PASSED") ;
    else
      $display("FAILED") ;
  end

endmodule
