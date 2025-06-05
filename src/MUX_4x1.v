
module Mux_4x1 (
    input  wire [1:0] sel,
    input  wire       in_0,
    input  wire       in_1,
    input  wire       in_2,
    input  wire       in_3,
    output wire       out
);

  // Inverted select lines
  wire sel_n0, sel_n1;
  not U_not0 (sel_n1, sel[1]);
  not U_not1 (sel_n0, sel[0]);

  // One-hot gating of inputs
  wire t0, t1, t2, t3;
  and U_and0 (t0, sel_n1, sel_n0, in_0);  // sel==00
  and U_and1 (t1, sel_n1, sel[0], in_1);  // sel==01
  and U_and2 (t2, sel[1], sel_n0, in_2);  // sel==10
  and U_and3 (t3, sel[1], sel[0], in_3);  // sel==11

  // Combine
  or  U_or   (out, t0, t1, t2, t3);

endmodule
