module fac (
   input x,
   input y,
   input c_in,
   output z,
   output c_out
);
   assign z=(x^y)^c_in;
   assign c_out=(x&y)|(x&c_in)|(y&c_in);
endmodule
