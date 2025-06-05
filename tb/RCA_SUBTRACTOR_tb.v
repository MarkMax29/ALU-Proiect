`timescale 1ns/1ps


`include "../src/fac.v"

`include "../src/RCA_SUBTRACTOR.v"

module RCA_SUBTRACTOR_tb;
  // Inputs
  reg  [7:0] x, y;
  reg        c_in;
  reg        op;
  // Outputs
  wire [7:0] z;
  wire       c_out;

  // Instantiate Unit Under Test
// Sumator/scazator ripple-carry: realizeaza add sau sub in functie de op
  RCA_SUBTRACTOR uut (
    .x     (x),
    .y     (y),
    .c_in  (c_in),
    .op    (op),
    .z     (z),
    .c_out (c_out)
  );

  // Dump waves
  initial begin
    $dumpfile("RCA_SUBTRACTOR_tb.vcd");
    $dumpvars(0, RCA_SUBTRACTOR_tb);
  end

  initial begin
    //=== Test Addition ===
    c_in = 1'b0;   // no carry in
    op   = 1'b0;   // op=0 → addition
    x    = 8'd27;  // 00011011
    y    = 8'd20;  // 00010100
    #10;
    $display("ADD : %0d + %0d = %0d, c_out=%b", x, y, z, c_out);

    //=== Test Subtraction ===
    c_in = 1'b1;   // two's-complement borrow in
    op   = 1'b1;   // op=1 → subtraction
    x    = 8'd40;  // 00101000
    y    = 8'd33;  // 00100001
    #10;
    $display("SUB : %0d - %0d = %0d, c_out=%b", x, y, z, c_out);

    //=== Edge Case: borrow out ===
    x    = 8'd5;   // 00000101
    y    = 8'd10;  // 00001010
    #10;
    $display("SUB : %0d - %0d = %0d, c_out=%b (borrow)", x, y, z, c_out);

    //=== Overflow Check ===
    c_in = 1'b0;   // addition again
    op   = 1'b0;
    x    = 8'hFF;  // 255
    y    = 8'h01;  // 1
    #10;
    $display("ADD : %0h + %0h = %0h, c_out=%b (overflow)", x, y, z, c_out);

    #10;
    $finish;
  end

endmodule
