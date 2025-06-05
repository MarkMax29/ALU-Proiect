`timescale 1ns/1ps

`include "D_FLIPFLOP.v"

`include "Mux_2x1.v"

`include "COUNTER.v"

`include "RCA_SUBTRACTOR.v"

module restoring_div (
  input  wire        clk,
  input  wire        rst,
  input  wire        start,      // load Q = dividend, R = 0, Qm1 = 0
  input  wire        enable,     // step signal (from Control Unit)
  input  wire [7:0]  dividend,
  input  wire [7:0]  divisor,
  output wire [7:0]  quotient,
  output wire [7:0]  remainder,
  output wire        done
);

  // 1) Counter
  wire [2:0] count;
// Contor de 3 biti: numara ciclurile si genereaza done dupa 8 iteratii
  COUNTER cnt (
    .CLK    (clk),
    .RST    (rst),
    .ENABLE (enable),
    .count  (count),
    .done   (done)
  );
  // only iterate while enable=1 & not done
  wire iter = enable && !done;

  // 2) State regs
  wire [7:0] R_hold, Q_hold;
  wire       Qm1_hold;
  wire [7:0] R_next, Q_next;
  wire       Qm1_next;
  wire [7:0] R_shift, Q_shift;
  wire       Qm1_shift;

  // 3) Shift‐left
  assign R_shift = {R_hold[6:0], Q_hold[7]};
  assign Q_shift = {Q_hold[6:0], Qm1_hold};
  assign Qm1_shift = Q_hold[0];

  // 4) Subtract divisor
  wire [7:0] R_sub;
// Sumator/rezistor ripple-carry: realizeaza add sau sub in functie de op
  RCA_SUBTRACTOR sub_i (
    .x    (R_shift),
    .y    (divisor),
    .c_in (1'b1),
    .op   (1'b1),
    .z    (R_sub),
    .c_out()
  );

  // 5) Decide restore or keep
  wire go = ~R_sub[7];
  genvar i;
  generate
    for (i = 0; i < 8; i = i + 1) begin : rem_next
// Multiplexor 2-la-1 pe un bit: selecteaza intre cele doua intrari
      Mux_2x1 mR(.sel(go), .in_0(R_shift[i]), .in_1(R_sub[i]), .out(R_next[i]));
    end
  endgenerate
  assign Q_next = {Q_shift[7:1], go};

  // 6a) iterate‐gate: hold vs update
  wire [7:0] R_iter, Q_iter;
  wire       Qm1_iter;
  generate
    for (i=0; i<8; i=i+1) begin : iter_mux
// Multiplexor 2-la-1 pe un bit: selecteaza intre cele doua intrari
      Mux_2x1 mRi(.sel(iter), .in_0(R_hold[i]), .in_1(R_next[i]), .out(R_iter[i]));
// Multiplexor 2-la-1 pe un bit: selecteaza intre cele doua intrari
      Mux_2x1 mQi(.sel(iter), .in_0(Q_hold[i]), .in_1(Q_next[i]), .out(Q_iter[i]));
    end
  endgenerate
// Multiplexor 2-la-1 pe un bit: selecteaza intre cele doua intrari
  Mux_2x1 mQm1i(.sel(iter), .in_0(Qm1_hold), .in_1(Qm1_shift), .out(Qm1_iter));

  // 6b) start‐gate: load initial vs iterate
  wire [7:0] R_load, Q_load;
  wire       Qm1_load;
  generate
    for (i=0; i<8; i=i+1) begin : start_mux
// Multiplexor 2-la-1 pe un bit: selecteaza intre cele doua intrari
      Mux_2x1 mRld(.sel(start), .in_0(1'b0),       .in_1(R_iter[i]), .out(R_load[i]));
// Multiplexor 2-la-1 pe un bit: selecteaza intre cele doua intrari
      Mux_2x1 mQld(.sel(start), .in_0(dividend[i]),.in_1(Q_iter[i]), .out(Q_load[i]));
    end
  endgenerate
// Multiplexor 2-la-1 pe un bit: selecteaza intre cele doua intrari
  Mux_2x1 mQm1ld(.sel(start), .in_0(1'b0), .in_1(Qm1_iter), .out(Qm1_load));

  // 7) Clocked regs
  generate
    for (i = 0; i < 8; i = i + 1) begin : regs
// Flip-flop D: stocheaza un bit la flanc pozitiv, cu reset asincron
      D_FLIPFLOP dR(.D(R_load[i]), .CLK(clk), .RST(rst), .Q(R_hold[i]), .Q_neg());
// Flip-flop D: stocheaza un bit la flanc pozitiv, cu reset asincron
      D_FLIPFLOP dQ(.D(Q_load[i]), .CLK(clk), .RST(rst), .Q(Q_hold[i]), .Q_neg());
    end
  endgenerate
// Flip-flop D: stocheaza un bit la flanc pozitiv, cu reset asincron
  D_FLIPFLOP dQ1(.D(Qm1_load), .CLK(clk), .RST(rst), .Q(Qm1_hold), .Q_neg());

  // 8) Outputs
  assign remainder = R_hold;
  assign quotient  = Q_hold;
endmodule
