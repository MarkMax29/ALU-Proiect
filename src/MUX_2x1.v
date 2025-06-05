

// Multiplexor 2-la-1 pe un bit: selecteaza intre cele doua intrari
module Mux_2x1 (
    input  wire sel,
    input  wire in_0,
    input  wire in_1,
    output wire out
);

  // Internal nets
  wire sel_n;
  wire w0;
  wire w1;

  // Invert select
  not U_not (sel_n, sel);
  // AND gates for each input
  and U_and0 (w0, sel_n, in_0);
  and U_and1 (w1, sel,   in_1);
  // OR gate to combine
  or  U_or   (out, w0, w1);

endmodule
