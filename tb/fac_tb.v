module fac_tb;
  reg x;
  reg y;
  reg c_in;
  wire z;
  wire c_out;

  fac cut (
    .x(x),
    .y(y),
    .c_in(c_in),
    .z(z),
    .c_out(c_out)
  );

  initial begin
    $dumpfile("dump.vcd"); $dumpvars;
    $display("c_in\tx\t\ty\t\tz\tc_out");
    $monitor("%b\t%b\t%b\t%b\t%b",c_in,x,y,z,c_out);

    // Test
    
    x = 1;
    y = 0;
    c_in = 1;
    #10;

    $finish;
  end
endmodule
