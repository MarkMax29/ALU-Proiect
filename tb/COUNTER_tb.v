`timescale 1ns/1ps

`include "../src/D_FLIPFLOP.v"

`include "../src/fac.v"

`include "../src/Mux_2x1.v"

`include "../src/COUNTER.v"

module COUNTER_tb;
  // Inputs
  reg        CLK;
  reg        RST;
  reg        ENABLE;
  // Outputs
  wire [2:0] count;
  wire       done;

  // Instantiate the Unit Under Test
// Contor de 3 biti: numara ciclurile si genereaza done dupa 8 iteratii
  COUNTER uut (
    .CLK    (CLK),
    .RST    (RST),
    .ENABLE (ENABLE),
    .count  (count),
    .done   (done)
  );

  // Clock: 10 ns period
  initial CLK = 0;
  always #5 CLK = ~CLK;

  initial begin
    // VCD dump for waveform viewing
    $dumpfile("COUNTER_tb.vcd");
    $dumpvars(0, COUNTER_tb);

    // 1) Apply reset
    RST    = 0;
    ENABLE = 0;
    #12;
    RST    = 1; #10;
    RST    = 0; #10;

    // 2) ENABLE=0: counter should stay at 000, done=0
    ENABLE = 0;
    repeat (4) @(posedge CLK);

    // 3) ENABLE=1: count up through 7, observe done=1 at 7
    ENABLE = 1;
    repeat (12) @(posedge CLK);

    // 4) Disable, verify hold at terminal count
    ENABLE = 0;
    repeat (4) @(posedge CLK);

    // 5) Re-enable: ensure no wrap-around (still held at 7)
    ENABLE = 1;
    repeat (4) @(posedge CLK);

    #10;
    $finish;
  end

  // Monitor all changes
  initial begin
    $display(" time | RST EN | count done");
    $monitor("%4t |   %b  %b  |  %b    %b",
             $time, RST, ENABLE, count, done);
  end
endmodule
