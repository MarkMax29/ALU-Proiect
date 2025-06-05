`timescale 1ns/1ps

`include "../src/D_FLIPFLOP.v"
`include "../src/Mux_4x1.v"
`include "../src/SHIFT_REG_BIDIR.v"

module SHIFT_REG_BIDIR_tb;
  // Inputs
  reg [7:0] IN;
  reg        load;
  reg        dr;    // when load=0: 0=shift right, 1=shift left
  reg        clk;
  reg        rst;

  // Outputs
  wire       msb;
  wire       lsb;
  wire [7:0] o;

  // Instantiate Unit Under Test
// Registru de shift bidirectional: deplasare stanga/dreapta
  SHIFT_REG_BIDIR uut (
    .IN   (IN),
    .load (load),
    .dr   (dr),
    .clk  (clk),
    .rst  (rst),
    .msb  (msb),
    .lsb  (lsb),
    .o    (o)
  );

  // Clock: 10 ns period
  initial clk = 0;
  always #5 clk = ~clk;

  initial begin
    // Waveform dump
    $dumpfile("SHIFT_REG_BIDIR_tb.vcd");
    $dumpvars(0, SHIFT_REG_BIDIR_tb);

    // 1) Reset
    rst  = 1; load = 0; dr = 0; IN = 8'h00;
    #10;
    rst = 0;
    #10;

    // 2) Parallel load pattern 11001100
    IN   = 8'b11001100;
    load = 1;
    #10;
    load = 0;
    #10;
    $display("Loaded   : o=%b msb=%b lsb=%b", o, msb, lsb);

    // 3) Shift right 3
    dr = 0;
    repeat (3) @(posedge clk);
    #1 $display("Shift R 3: o=%b msb=%b lsb=%b", o, msb, lsb);

    // 4) Shift left 4
    dr = 1;
    repeat (4) @(posedge clk);
    #1 $display("Shift L 4: o=%b msb=%b lsb=%b", o, msb, lsb);

    // 5) Parallel load new pattern 00110011
    IN   = 8'b00110011;
    load = 1;
    #10;
    load = 0;
    #10;
    $display("Reloaded : o=%b msb=%b lsb=%b", o, msb, lsb);

    // 6) Shift left 2
    dr = 1;
    repeat (2) @(posedge clk);
    #1 $display("Shift L 2 : o=%b msb=%b lsb=%b", o, msb, lsb);

    // 7) Shift right 2
    dr = 0;
    repeat (2) @(posedge clk);
    #1 $display("Shift R 2 : o=%b msb=%b lsb=%b", o, msb, lsb);

    #10;
    $finish;
  end

  initial begin
    $display("time | rst load dr IN       -> o       msb lsb");
    $monitor("%4t |  %b   %b    %b   %b -> %b  %b   %b", $time, rst, load, dr, IN, o, msb, lsb);
  end
endmodule
