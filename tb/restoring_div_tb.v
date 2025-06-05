`timescale 1ns/1ps

`include "../src/D_FLIPFLOP.v"

`include "../src/Mux_2x1.v"

`include "../src/COUNTER.v"

`include "../src/RCA_SUBTRACTOR.v"

`include "../src/restoring_div.v"

module restoring_div_tb;
  // Clock and reset
  reg         clk;
  reg         rst;
  // Control
  reg         start;
  reg         enable;
  // Inputs
  reg  [7:0]  dividend;
  reg  [7:0]  divisor;
  // Outputs
  wire [7:0]  quotient;
  wire [7:0]  remainder;
  wire        done;

  // Instantiate DUT
// Divizor restaurator: calculeaza catul si restul in 8 cicluri
  restoring_div uut (
    .clk      (clk),
    .rst      (rst),
    .start    (start),
    .enable   (enable),
    .dividend (dividend),
    .divisor  (divisor),
    .quotient (quotient),
    .remainder(remainder),
    .done     (done)
  );

  // 10 ns clock
  initial clk = 0;
  always #5 clk = ~clk;

  // Dump waves
  initial begin
    $dumpfile("restoring_div_tb.vcd");
    $dumpvars(0, restoring_div_tb);
  end

  // Test sequence
  initial begin
    // -----------------------------------------------------------------------
    // 1) Reset
    // -----------------------------------------------------------------------
    rst     = 1;
    start   = 0;
    enable  = 0;
    dividend= 0;
    divisor = 0;
    #12;
    rst     = 0;
    #8;

    // -----------------------------------------------------------------------
    // Test Case 1: 100 ÷  3 = 33 rem 1
    // -----------------------------------------------------------------------
    dividend = 8'd100;
    divisor  = 8'd3;
    start    = 1;
    enable   = 0;
    // Load dividend & clear remainder
    @(posedge clk);
    start    = 0;
    enable   = 1;
    // Perform 8 iterations
    repeat (8) @(posedge clk);
    enable   = 0;
    @(posedge clk);
    $display("TC1: %0d ÷ %0d = %0d rem %0d (done=%b)", 
              dividend, divisor, quotient, remainder, done);
    if (quotient !== 8'd33 || remainder !== 8'd1 || !done)
      $error("TC1 FAILED: got %0d rem %0d done=%b", quotient, remainder, done);

    // -----------------------------------------------------------------------
    // Test Case 2:   7 ÷  8 = 0 rem 7
    // -----------------------------------------------------------------------
    #10;
    dividend = 8'd7;
    divisor  = 8'd8;
    start    = 1;
    enable   = 0;
    @(posedge clk);
    start    = 0;
    enable   = 1;
    repeat (8) @(posedge clk);
    enable   = 0;
    @(posedge clk);
    $display("TC2: %0d ÷ %0d = %0d rem %0d (done=%b)", 
              dividend, divisor, quotient, remainder, done);
    if (quotient !== 8'd0 || remainder !== 8'd7 || !done)
      $error("TC2 FAILED: got %0d rem %0d done=%b", quotient, remainder, done);

    // -----------------------------------------------------------------------
    // Test Case 3: 255 ÷  5 = 51 rem 0
    // -----------------------------------------------------------------------
    #10;
    dividend = 8'd255;
    divisor  = 8'd5;
    start    = 1;
    enable   = 0;
    @(posedge clk);
    start    = 0;
    enable   = 1;
    repeat (8) @(posedge clk);
    enable   = 0;
    @(posedge clk);
    $display("TC3: %0d ÷ %0d = %0d rem %0d (done=%b)", 
              dividend, divisor, quotient, remainder, done);
    if (quotient !== 8'd51 || remainder !== 8'd0 || !done)
      $error("TC3 FAILED: got %0d rem %0d done=%b", quotient, remainder, done);

    // -----------------------------------------------------------------------
    // Test Case 4:  50 ÷ 25 = 2 rem 0
    // -----------------------------------------------------------------------
    #10;
    dividend = 8'd50;
    divisor  = 8'd25;
    start    = 1;
    enable   = 0;
    @(posedge clk);
    start    = 0;
    enable   = 1;
    repeat (8) @(posedge clk);
    enable   = 0;
    @(posedge clk);
    $display("TC4: %0d ÷ %0d = %0d rem %0d (done=%b)", 
              dividend, divisor, quotient, remainder, done);
    if (quotient !== 8'd2 || remainder !== 8'd0 || !done)
      $error("TC4 FAILED: got %0d rem %0d done=%b", quotient, remainder, done);

    // Finish
    #10;
    $display("All tests completed.");
    $finish;
  end
endmodule
