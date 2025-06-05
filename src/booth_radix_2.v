`timescale 1ns/1ps

`include "D_FLIPFLOP.v"

`include "Mux_2x1.v"

`include "COUNTER.v"

`include "RCA_SUBTRACTOR.v"

// Multiplicator Booth Radix-2: iterativ A,Q,Qm1 cu 8 cicluri
module booth_radix_2 (
  input  wire        clk,
  input  wire        rst,
  input  wire        start,     // load initial A=0, Q=multB, Qm1=0
  input  wire        enable,    // step signal (from Control Unit)
  input  wire [7:0]  multA,
  input  wire [7:0]  multB,
  output wire        done,      // pulses high when count==7, then stays high
  output wire [15:0] product,
  output wire        Q0,        // LSB of Q
  output wire        Qm1        // “minus-1” bit
);

  // 1) Count 8 cycles, then latch done
  wire [2:0] count;
// Contor de 3 biti: numara ciclurile si genereaza done dupa 8 iteratii
  COUNTER cnt (
    .CLK    (clk),
    .RST    (rst),
    .ENABLE (enable),   // counter itself stops at 7 internally
    .count  (count),
    .done   (done)
  );
  // we only iterate while enable is high AND not yet done
  wire iter = enable && !done;

  // 2) Partial-product regs
  wire [7:0] A_hold, Q_hold;
  wire       Qm1_hold;
  wire [7:0] A_next, Q_next;
  wire       Qm1_next;
  wire [7:0] A_shift, Q_shift;
  wire       Qm1_shift;

  // decide add/sub based on {Q[0],Qm1}
  wire do_add =  Q_hold[0] & ~Qm1_hold;  // 01
  wire do_sub = ~Q_hold[0] &  Qm1_hold;  // 10

  // sum and difference
  wire [7:0] sum_add, sum_sub;
// Sumator/rezistor ripple-carry: realizeaza add sau sub in functie de op
  RCA_SUBTRACTOR add_i (
    .x    (A_hold),
    .y    (multA),
    .c_in (1'b0),
    .op   (1'b0),
    .z    (sum_add),
    .c_out()
  );
// Sumator/rezistor ripple-carry: realizeaza add sau sub in functie de op
  RCA_SUBTRACTOR sub_i (
    .x    (A_hold),
    .y    (multA),
    .c_in (1'b1),
    .op   (1'b1),
    .z    (sum_sub),
    .c_out()
  );

  // 3) Select A_next = hold / add / sub
  genvar i;
  generate
    for (i = 0; i < 8; i = i + 1) begin : sel_addsub
      wire stage1;
// Multiplexor 2-la-1 pe un bit: selecteaza intre cele doua intrari
      Mux_2x1 m0(.sel(do_add), .in_0(A_hold[i]), .in_1(sum_add[i]), .out(stage1));
// Multiplexor 2-la-1 pe un bit: selecteaza intre cele doua intrari
      Mux_2x1 m1(.sel(do_sub), .in_0(stage1),    .in_1(sum_sub[i]), .out(A_next[i]));
    end
  endgenerate

  // 4) Arithmetic right-shift {A_next,Q_hold,Qm1_hold}
  assign A_shift   = { A_next[7],    A_next[7:1] };
  assign Q_shift   = { A_next[0],    Q_hold[7:1] };
  assign Qm1_shift =           Q_hold[0]   ;

  // 5a) iterate-gate: when !iter hold old, when iter shift
  wire [7:0] A_iter, Q_iter;
  wire       Qm1_iter;
  generate
    for (i = 0; i < 8; i = i + 1) begin : gen_iter
// Multiplexor 2-la-1 pe un bit: selecteaza intre cele doua intrari
      Mux_2x1 mA(.sel(iter), .in_0(A_hold[i]), .in_1(A_shift[i]), .out(A_iter[i]));
// Multiplexor 2-la-1 pe un bit: selecteaza intre cele doua intrari
      Mux_2x1 mQ(.sel(iter), .in_0(Q_hold[i]), .in_1(Q_shift[i]), .out(Q_iter[i]));
    end
  endgenerate
// Multiplexor 2-la-1 pe un bit: selecteaza intre cele doua intrari
  Mux_2x1 mQm1(.sel(iter), .in_0(Qm1_hold), .in_1(Qm1_shift), .out(Qm1_iter));

  // 5b) start-gate: when start load initial, else take iterate result
  wire [7:0] A_load, Q_load;
  wire       Qm1_load;
  generate
    for (i = 0; i < 8; i = i + 1) begin : gen_start
      // A_load = start ? 0        : A_iter
// Multiplexor 2-la-1 pe un bit: selecteaza intre cele doua intrari
      Mux_2x1 msA(.sel(start), .in_0(1'b0), .in_1(A_iter[i]), .out(A_load[i]));
      // Q_load = start ? multB[i] : Q_iter
// Multiplexor 2-la-1 pe un bit: selecteaza intre cele doua intrari
      Mux_2x1 msQ(.sel(start), .in_0(multB[i]), .in_1(Q_iter[i]), .out(Q_load[i]));
    end
  endgenerate
// Multiplexor 2-la-1 pe un bit: selecteaza intre cele doua intrari
  Mux_2x1 msQm1(.sel(start), .in_0(1'b0), .in_1(Qm1_iter), .out(Qm1_load));

  // 6) Clock the registers
  generate
    for (i = 0; i < 8; i = i + 1) begin : regs
// Flip-flop D: stocheaza un bit la flanc pozitiv, cu reset asincron
      D_FLIPFLOP dA(.D(A_load[i]), .CLK(clk), .RST(rst), .Q(A_hold[i]), .Q_neg());
// Flip-flop D: stocheaza un bit la flanc pozitiv, cu reset asincron
      D_FLIPFLOP dQ(.D(Q_load[i]), .CLK(clk), .RST(rst), .Q(Q_hold[i]), .Q_neg());
    end
  endgenerate
// Flip-flop D: stocheaza un bit la flanc pozitiv, cu reset asincron
  D_FLIPFLOP dQ1(.D(Qm1_load), .CLK(clk), .RST(rst), .Q(Qm1_hold), .Q_neg());

  // 7) Outputs
  assign product = {A_hold, Q_hold};
  assign Q0      = Q_hold[0];
  assign Qm1     = Qm1_hold;
endmodule
