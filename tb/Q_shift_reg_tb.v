`timescale 1ns/1ps

`include "../src/D_FLIPFLOP.v"

`include "../src/Mux_2x1.v"

`include "../src/Q_shift_reg.v"

module Q_shift_reg_tb;
  // Inputs
  reg        clk;
  reg        rst;
  reg        load;
  reg        dir;    // 0 = shift right, 1 = shift left
  reg [7:0]  in;
  // Outputs
  wire [7:0] q;

  // Instantiate Unit Under Test
// Registru de shift Q: deplasare dependenta de control
  Q_shift_reg uut (
    .clk  (clk),
    .rst  (rst),
    .load (load),
    .dir  (dir),
    .in   (in),
    .q    (q)
  );

  // Clock generation: 10 ns period
  initial clk = 0;
  always #5 clk = ~clk;

  initial begin
    // Waveform dump
    $dumpfile("Q_shift_reg_tb.vcd");
    $dumpvars(0, Q_shift_reg_tb);

    //=== Test Sequence ===

    // 1) Reset the register
    rst = 1; load = 0; dir = 0; in = 8'h00;
    #10;
    rst = 0;
    #10;

    // 2) Parallel load a pattern
    load = 1; in = 8'b10110011;
    #10;
    load = 0;
    #10;

    // 3) Shift right 3 times
    dir = 0; // shift right
    repeat (3) @(posedge clk);
    #1; $display("Shift Right 3: q = %b", q);

    // 4) Shift left 4 times
    dir = 1; // shift left
    repeat (4) @(posedge clk);
    #1; $display("Shift Left 4: q = %b", q);

    // 5) Parallel load new pattern
    load = 1; in = 8'b01010101;
    #10;
    load = 0;
    #10;

    // 6) Shift left 2 times
    dir = 1;
    repeat (2) @(posedge clk);
    #1; $display("Shift Left 2: q = %b", q);

    // 7) Shift right 2 times
    dir = 0;
    repeat (2) @(posedge clk);
    #1; $display("Shift Right 2: q = %b", q);

    #10;
    $finish;
  end

  // Monitor signals
  initial begin
    $display("time | rst load dir in       q");
    $monitor("%4t |  %b   %b    %b   %b => %b", $time, rst, load, dir, in, q);
  end
endmodule
