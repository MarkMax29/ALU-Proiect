`timescale 1ns/1ps

`include "../src/D_FLIPFLOP.v"

`include "../src/Mux_2x1.v"

`include "../src/COUNTER.v"

`include "../src/RCA_SUBTRACTOR.v"

`include "../src/booth_radix_2.v"

module booth_radix_2_tb;
  // Inputs
  reg        clk;
  reg        rst;
  reg        start;
  reg        enable;
  reg  [7:0] multA;   // now matches DUT port
  reg  [7:0] multB;   // now matches DUT port

  // Outputs
  wire       done;
  wire [15:0] product;

  // Instantiate the DUT
// Multiplicator Booth Radix-2: iterativ A,Q,Qm1 cu 8 cicluri
  booth_radix_2 uut (
    .clk     (clk),
    .rst     (rst),
    .start   (start),
    .enable  (enable),
    .multA   (multA),
    .multB   (multB),
    .done    (done),
    .product (product)
  );

  // Clock: 10 ns period
  initial clk = 0;
  always #5 clk = ~clk;

  initial begin
    $dumpfile("booth_radix_2_tb.vcd");
    $dumpvars(0, booth_radix_2_tb);

    // Test Case 1: 15 * 3 = 45
    rst    = 1; start = 0; enable = 0; multA = 0; multB = 0;
    #12;
    rst    = 0;                             // release reset
    #8;
    start  = 1; multA = 8'd15; multB = 8'd3; 
    #10;
    start  = 0;    // latch inA, inB
    enable = 1;    // begin 8-cycle shift/add sequence
    repeat (8) @(posedge clk);
    enable = 0;
    #10;
    $display("TC1: %0d * %0d = %0d (done=%b)", multA, multB, product, done);
    if (product !== 16'd45 || !done) $error("TC1 FAILED");

    // Test Case 2: 7 * 8 = 56
    #10;
    rst    = 1; start = 0; enable = 0; 
    #12;
    rst    = 0;
    #8;
    start  = 1; multA = 8'd7; multB = 8'd8;
    #10;
    start  = 0;
    enable = 1;
    repeat (8) @(posedge clk);
    enable = 0;
    #10;
    $display("TC2: %0d * %0d = %0d (done=%b)", multA, multB, product, done);
    if (product !== 16'd56 || !done) $error("TC2 FAILED");

    // Test Case 3: 255 * 255 = 65025
    #10;
    rst    = 1; start = 0; enable = 0; 
    #12;
    rst    = 0;
    #8;
    start  = 1; multA = 8'hFF; multB = 8'hFF;
    #10;
    start  = 0;
    enable = 1;
    repeat (8) @(posedge clk);
    enable = 0;
    #10;
    $display("TC3: %0d * %0d = %0d (done=%b)", multA, multB, product, done);
    if (product !== 16'd65025 || !done) $error("TC3 FAILED");

    $finish;
  end
endmodule
