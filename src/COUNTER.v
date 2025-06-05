`include "D_FLIPFLOP.v"

`include "fac.v"

`include "Mux_2x1.v"

// Contor de 3 biti: numara ciclurile si genereaza done dupa 8 iteratii
module COUNTER (
  input  wire       CLK,
  input  wire       RST,
  input  wire       ENABLE,
  output wire [2:0] count,
  output wire       done
);

  // Internal wires
  wire [2:0] ct, add, ct_nxt;
  wire       c0, c1;
  wire       done_cnt;
  wire       enable_active;

  // 1) Terminal count flag
  assign done_cnt     = ct[2] & ct[1] & ct[0];
  assign done         = done_cnt;

  // 2) Active enable
  assign enable_active = ENABLE & ~done_cnt;

  // 3) Ripple-add 1
// Modul factorial sau alt bloc specific (fac)
  fac fa0(.x(ct[0]), .y(1'b0), .c_in(enable_active), .z(add[0]), .c_out(c0));
// Modul factorial sau alt bloc specific (fac)
  fac fa1(.x(ct[1]), .y(1'b0), .c_in(c0),             .z(add[1]), .c_out(c1));
// Modul factorial sau alt bloc specific (fac)
  fac fa2(.x(ct[2]), .y(1'b0), .c_in(c1),             .z(add[2]), .c_out());

  // 4) Hold-vs-add mux
// Multiplexor 2-la-1 pe un bit: selecteaza intre cele doua intrari
  Mux_2x1 mux0(.sel(enable_active), .in_0(ct[0]), .in_1(add[0]), .out(ct_nxt[0]));
// Multiplexor 2-la-1 pe un bit: selecteaza intre cele doua intrari
  Mux_2x1 mux1(.sel(enable_active), .in_0(ct[1]), .in_1(add[1]), .out(ct_nxt[1]));
// Multiplexor 2-la-1 pe un bit: selecteaza intre cele doua intrari
  Mux_2x1 mux2(.sel(enable_active), .in_0(ct[2]), .in_1(add[2]), .out(ct_nxt[2]));

  // 5) State registers
// Flip-flop D: stocheaza un bit la flanc pozitiv, cu reset asincron
  D_FLIPFLOP dff0(.D(ct_nxt[0]), .CLK(CLK), .RST(RST), .Q(ct[0]), .Q_neg());
// Flip-flop D: stocheaza un bit la flanc pozitiv, cu reset asincron
  D_FLIPFLOP dff1(.D(ct_nxt[1]), .CLK(CLK), .RST(RST), .Q(ct[1]), .Q_neg());
// Flip-flop D: stocheaza un bit la flanc pozitiv, cu reset asincron
  D_FLIPFLOP dff2(.D(ct_nxt[2]), .CLK(CLK), .RST(RST), .Q(ct[2]), .Q_neg());

  // 6) Output
  assign count = ct;

endmodule
