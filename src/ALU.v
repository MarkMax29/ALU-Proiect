`timescale 1ns/1ps


`include "../src/Control_Unit_ALU.v"

`include "../src/D_FLIPFLOP.v"

`include "../src/Mux_2x1.v"

`include "../src/COUNTER.v"

`include "../src/RCA_SUBTRACTOR.v"

`include "../src/booth_radix_2.v"

`include "../src/restoring_div.v"

module ALU (
  input  wire        clk,
  input  wire        rst,
  input  wire        BEGIN,    // pulse to start mul/div
  input  wire [1:0]  Op,       // 00=add,01=sub,10=mul,11=div
  input  wire [7:0]  inA,
  input  wire [7:0]  inM,
  output wire        END,
  output wire [15:0] OUTBUS
);

  // Control signals
  wire c0, c1, c2, c3, c4, c5, c6, c7,
       c8, c9, c10, c11, c12, c13, c14, c15,
       c16, c17, c18, c8_wait;
  wire count7_mul, count7_div, Q0, Qm1;
  wire a7;

  // select correct counter done for CU
  wire count7_sig;
  assign count7_sig = (Op == 2'b10) ? count7_mul : count7_div;

// Unitate de control ALU: genereaza semnalele de control c0..c18
  Control_Unit_ALU cu (
    .clk        (clk),
    .rst        (rst),
    .\BEGIN     (BEGIN),
    .Op         (Op),
    .count7     (count7_sig),
    .\a[7]      (a7),
    .\Q[0]Q[-1] ({Q0, Qm1}),
    .\END       (END),
    .c0(c0), .c1(c1), .c2(c2), .c3(c3),
    .c4(c4), .c5(c5), .c6(c6), .c7(c7),
    .c8(c8), .c9(c9), .c10(c10), .c11(c11),
    .c12(c12), .c13(c13), .c14(c14), .c15(c15),
    .c16(c16), .c17(c17), .c18(c18), .c8_wait(c8_wait)
  );

  // A/M registers
  wire [7:0] A_reg, M_reg;
  assign a7 = A_reg[7];
  genvar i;
  generate
    for (i = 0; i < 8; i = i + 1) begin : AM
// Flip-flop D: stocheaza un bit la flanc pozitiv, cu reset asincron
      D_FLIPFLOP dA (
        .D   (c0 ? inA[i] : A_reg[i]),
        .CLK (clk),
        .RST (rst),
        .Q   (A_reg[i]),
        .Q_neg()
      );
// Flip-flop D: stocheaza un bit la flanc pozitiv, cu reset asincron
      D_FLIPFLOP dM (
        .D   (c1 ? inM[i] : M_reg[i]),
        .CLK (clk),
        .RST (rst),
        .Q   (M_reg[i]),
        .Q_neg()
      );
    end
  endgenerate

  // Combinational ADD/SUB
  wire [7:0] sumA, sumS;
// Sumator/rezistor ripple-carry: realizeaza add sau sub in functie de op
  RCA_SUBTRACTOR add_u (
    .x    (inA),
    .y    (inM),
    .c_in (1'b0),
    .op   (1'b0),
    .z    (sumA),
    .c_out()
  );
// Sumator/rezistor ripple-carry: realizeaza add sau sub in functie de op
  RCA_SUBTRACTOR sub_u (
    .x    (inA),
    .y    (inM),
    .c_in (1'b1),
    .op   (1'b1),
    .z    (sumS),
    .c_out()
  );

  // Booth multiplier
  wire [15:0] mulP;
// Multiplicator Booth Radix-2: iterativ A,Q,Qm1 cu 8 cicluri
  booth_radix_2 bm (
    .clk     (clk),
    .rst     (rst),
    .start   (c2),
    .enable  (c7),
    .multA   (A_reg),
    .multB   (M_reg),
    .done    (count7_mul),
    .product (mulP),
    .Q0      (Q0),
    .Qm1     (Qm1)
  );

  // Restoring divider
  wire [7:0] divQ;
// Divizor restaurator: calculeaza catul si restul in 8 cicluri
  restoring_div rd (
    .clk      (clk),
    .rst      (rst),
    .start    (c8),
    .enable   (c12),
    .dividend (A_reg),
    .divisor  (M_reg),
    .quotient (divQ),
    .remainder(),
    .done     (count7_div)
  );

  // Final result MUX by Op
  wire [15:0] extA = {8'b0, sumA},
               extS = {8'b0, sumS},
               extM = mulP,
               extD = {8'b0, divQ};

  generate
    for (i = 0; i < 16; i = i + 1) begin : OUT
      wire useA = (Op == 2'b00),
           useS = (Op == 2'b01),
           useM = (Op == 2'b10),
           useD = (Op == 2'b11);
      wire [15:0] selbus = useA ? extA :
                          useS ? extS :
                          useM ? extM :
                          useD ? extD :
                                 16'b0;
      assign OUTBUS[i] = selbus[i];
    end
  endgenerate

endmodule
