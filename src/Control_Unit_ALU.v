
module Decoder2 (
    output out_0,
    output out_1,
    output out_2,
    output out_3,
    input [1:0] sel
);
    assign out_0 = (sel == 2'h0)? 1'b1 : 1'b0;
    assign out_1 = (sel == 2'h1)? 1'b1 : 1'b0;
    assign out_2 = (sel == 2'h2)? 1'b1 : 1'b0;
    assign out_3 = (sel == 2'h3)? 1'b1 : 1'b0;
endmodule

// Unitate de control ALU: genereaza semnalele de control c0..c18
module Control_Unit_ALU (
  input clk,
  input rst,
  input \BEGIN ,
  input [1:0] Op,
  input count7,
  input \a[7] ,
  input [1:0] \Q[0]Q[-1] ,
  output \END ,
  output c0,
  output c1,
  output c2,
  output c3,
  output c4,
  output c5,
  output c6,
  output c7,
  output c8,
  output c9,
  output c10,
  output c11,
  output c12,
  output c13,
  output c14,
  output c15,
  output c16,
  output c17,
  output c18,
  output c8_wait
);
  wire s0;
  wire c0_temp;
  wire s1;
  wire c1_temp;
  wire s2;
  wire c2_temp;
  wire s3;
  wire c3_temp;
  wire s4;
  wire c5_temp;
  wire s5;
  wire c6_temp;
  wire s6;
  wire c7_temp;
  wire s7;
  wire c8_temp;
  wire s8;
  wire c9_temp;
  wire s9;
  wire c4_temp;
  wire s10;
  wire c10_temp;
  wire s11;
  wire c11_temp;
  wire s12;
  wire c13_temp;
  wire s13;
  wire c14_temp;
  wire s14;
  wire c15_temp;
  wire c16_temp;
  wire s15;
  wire c17_temp;
  wire s16;
  wire c12_temp;
  wire s17;
  wire c18_temp;
  wire END_temp;
  wire add;
  wire sub;
  wire mul;
  wire div;
  wire \00 ;
  wire \01 ;
  wire \10 ;
  wire \11 ;
  wire c8_wait_temp;
  Decoder2 Decoder2_i0 (
    .sel( Op ),
    .out_0( add ),
    .out_1( sub ),
    .out_2( mul ),
    .out_3( div )
  );
  Decoder2 Decoder2_i1 (
    .sel( \Q[0]Q[-1]  ),
    .out_0( \00  ),
    .out_1( \01  ),
    .out_2( \10  ),
    .out_3( \11  )
  );
  // S0
// Flip-flop D: stocheaza un bit la flanc pozitiv, cu reset asincron
  D_FLIPFLOP D_FLIPFLOP_i2 (
    .D( s0 ),
    .CLK( clk ),
    .RST( rst ),
    .Q( c0_temp ),
    .Q_neg ()
  );
  // S1
// Flip-flop D: stocheaza un bit la flanc pozitiv, cu reset asincron
  D_FLIPFLOP D_FLIPFLOP_i3 (
    .D( s1 ),
    .CLK( clk ),
    .RST( rst ),
    .Q( c1_temp ),
    .Q_neg ()
  );
  // S2
// Flip-flop D: stocheaza un bit la flanc pozitiv, cu reset asincron
  D_FLIPFLOP D_FLIPFLOP_i4 (
    .D( s2 ),
    .CLK( clk ),
    .RST( rst ),
    .Q( c2_temp ),
    .Q_neg ()
  );
  // S3
// Flip-flop D: stocheaza un bit la flanc pozitiv, cu reset asincron
  D_FLIPFLOP D_FLIPFLOP_i5 (
    .D( s3 ),
    .CLK( clk ),
    .RST( rst ),
    .Q( c3_temp ),
    .Q_neg ()
  );
  // S5
// Flip-flop D: stocheaza un bit la flanc pozitiv, cu reset asincron
  D_FLIPFLOP D_FLIPFLOP_i6 (
    .D( s4 ),
    .CLK( clk ),
    .RST( rst ),
    .Q( c5_temp ),
    .Q_neg ()
  );
  // S6
// Flip-flop D: stocheaza un bit la flanc pozitiv, cu reset asincron
  D_FLIPFLOP D_FLIPFLOP_i7 (
    .D( s5 ),
    .CLK( clk ),
    .RST( rst ),
    .Q( c6_temp ),
    .Q_neg ()
  );
  // S7
// Flip-flop D: stocheaza un bit la flanc pozitiv, cu reset asincron
  D_FLIPFLOP D_FLIPFLOP_i8 (
    .D( s6 ),
    .CLK( clk ),
    .RST( rst ),
    .Q( c7_temp ),
    .Q_neg ()
  );
  // S8
// Flip-flop D: stocheaza un bit la flanc pozitiv, cu reset asincron
  D_FLIPFLOP D_FLIPFLOP_i9 (
    .D( s7 ),
    .CLK( clk ),
    .RST( rst ),
    .Q( c8_temp ),
    .Q_neg ()
  );
  // S9
// Flip-flop D: stocheaza un bit la flanc pozitiv, cu reset asincron
  D_FLIPFLOP D_FLIPFLOP_i10 (
    .D( s8 ),
    .CLK( clk ),
    .RST( rst ),
    .Q( c9_temp ),
    .Q_neg ()
  );
  // S4
// Flip-flop D: stocheaza un bit la flanc pozitiv, cu reset asincron
  D_FLIPFLOP D_FLIPFLOP_i11 (
    .D( s9 ),
    .CLK( clk ),
    .RST( rst ),
    .Q( c4_temp ),
    .Q_neg ()
  );
  // S10
// Flip-flop D: stocheaza un bit la flanc pozitiv, cu reset asincron
  D_FLIPFLOP D_FLIPFLOP_i12 (
    .D( s10 ),
    .CLK( clk ),
    .RST( rst ),
    .Q( c10_temp ),
    .Q_neg ()
  );
  // S11
// Flip-flop D: stocheaza un bit la flanc pozitiv, cu reset asincron
  D_FLIPFLOP D_FLIPFLOP_i13 (
    .D( s11 ),
    .CLK( clk ),
    .RST( rst ),
    .Q( c11_temp ),
    .Q_neg ()
  );
  // S13
// Flip-flop D: stocheaza un bit la flanc pozitiv, cu reset asincron
  D_FLIPFLOP D_FLIPFLOP_i14 (
    .D( s12 ),
    .CLK( clk ),
    .RST( rst ),
    .Q( c13_temp ),
    .Q_neg ()
  );
  // S14
// Flip-flop D: stocheaza un bit la flanc pozitiv, cu reset asincron
  D_FLIPFLOP D_FLIPFLOP_i15 (
    .D( s13 ),
    .CLK( clk ),
    .RST( rst ),
    .Q( c14_temp ),
    .Q_neg ()
  );
  // S15
// Flip-flop D: stocheaza un bit la flanc pozitiv, cu reset asincron
  D_FLIPFLOP D_FLIPFLOP_i16 (
    .D( s14 ),
    .CLK( clk ),
    .RST( rst ),
    .Q( c15_temp ),
    .Q_neg ()
  );
  // S16
// Flip-flop D: stocheaza un bit la flanc pozitiv, cu reset asincron
  D_FLIPFLOP D_FLIPFLOP_i17 (
    .D( c15_temp ),
    .CLK( clk ),
    .RST( rst ),
    .Q( c16_temp ),
    .Q_neg ()
  );
  // S17
// Flip-flop D: stocheaza un bit la flanc pozitiv, cu reset asincron
  D_FLIPFLOP D_FLIPFLOP_i18 (
    .D( s15 ),
    .CLK( clk ),
    .RST( rst ),
    .Q( c17_temp ),
    .Q_neg ()
  );
  // S12
// Flip-flop D: stocheaza un bit la flanc pozitiv, cu reset asincron
  D_FLIPFLOP D_FLIPFLOP_i19 (
    .D( s16 ),
    .CLK( clk ),
    .RST( rst ),
    .Q( c12_temp ),
    .Q_neg ()
  );
  // S18
// Flip-flop D: stocheaza un bit la flanc pozitiv, cu reset asincron
  D_FLIPFLOP D_FLIPFLOP_i20 (
    .D( s17 ),
    .CLK( clk ),
    .RST( rst ),
    .Q( c18_temp ),
    .Q_neg ()
  );
  assign s0 = (~ \BEGIN  | END_temp);
  assign END_temp = ((div & c14_temp) | (mul & c14_temp) | ((sub | add) & c7_temp));
  assign s1 = ((add | sub) & \BEGIN  & c0_temp);
  assign s2 = (mul & \BEGIN  & c0_temp);
  assign s3 = (div & \BEGIN  & c0_temp);
  assign s4 = (add & c4_temp);
  assign s5 = (sub & c4_temp);
  assign s6 = ((c16_temp & ~ \a[7]  & count7) | c5_temp | c6_temp | c18_temp | (c17_temp & count7 & ~ \a[7] ));
  assign s7 = (mul & c4_temp);
  assign s16 = ((~ count7 & c17_temp) | c11_temp | (c16_temp & ~ \a[7]  & ~ count7));
  assign s12 = (count7 & c9_temp);
  assign s13 = ((div & c7_temp) | (mul & c13_temp));
  assign s15 = (\a[7]  & c16_temp);
  assign s17 = (count7 & \a[7]  & c17_temp);
  assign s14 = ((div & c4_temp) | (div & c12_temp));
  assign s11 = (mul & ((c8_wait_temp & (\11  | \00 )) | (~ count7 & c9_temp) | (c10_temp & ~ count7) | (c12_temp & (\11  | \00 ))));
  // S8_wait
// Flip-flop D: stocheaza un bit la flanc pozitiv, cu reset asincron
  D_FLIPFLOP D_FLIPFLOP_i21 (
    .D( c8_temp ),
    .CLK( clk ),
    .RST( rst ),
    .Q( c8_wait_temp ),
    .Q_neg ()
  );
  assign s8 = ((\01  & c8_wait_temp) | (\01  & c12_temp));
  assign s10 = ((\10  & c8_wait_temp) | (\10  & c12_temp));
  assign s9 = (c1_temp | c2_temp | c3_temp);
  assign \END  = END_temp;
  assign c0 = c0_temp;
  assign c1 = c1_temp;
  assign c2 = c2_temp;
  assign c3 = c3_temp;
  assign c4 = c4_temp;
  assign c5 = c5_temp;
  assign c6 = c6_temp;
  assign c7 = c7_temp;
  assign c8 = c8_temp;
  assign c9 = c9_temp;
  assign c10 = c10_temp;
  assign c11 = c11_temp;
  assign c12 = c12_temp;
  assign c13 = c13_temp;
  assign c14 = c14_temp;
  assign c15 = c15_temp;
  assign c16 = c16_temp;
  assign c17 = c17_temp;
  assign c18 = c18_temp;
  assign c8_wait = c8_wait_temp;
endmodule
