`include "D_FLIPFLOP.v"

`include "Mux_2x1.v"

// Registru de shift Q: deplasare dependenta de control
module Q_shift_reg (
  input  wire       clk,
  input  wire       rst,
  input  wire       load,   // 1 = parallel load, 0 = shift
  input  wire       dir,    // 0 = shift right, 1 = shift left
  input  wire [7:0] in,     // parallel load data
  output wire [7:0] q       // register output
);

  wire [7:0] shift_data;
  wire [7:0] d;

  genvar i;
  generate
    for (i = 0; i < 8; i = i + 1) begin : bit_slice
      // compute shift-right input (fill MSB with 0)
      wire right_in = (i == 7) ? 1'b0 : q[i+1];
      // compute shift-left input (fill LSB with 0)
      wire left_in  = (i == 0) ? 1'b0 : q[i-1];

      // Mux between right and left shift based on dir
// Multiplexor 2-la-1 pe un bit: selecteaza intre cele doua intrari
      Mux_2x1 mux_dir (
        .sel  (dir),
        .in_0 (right_in),
        .in_1 (left_in),
        .out  (shift_data[i])
      );

      // Mux between shift result and parallel load
// Multiplexor 2-la-1 pe un bit: selecteaza intre cele doua intrari
      Mux_2x1 mux_load (
        .sel  (load),
        .in_0 (shift_data[i]),
        .in_1 (in[i]),
        .out  (d[i])
      );

      // Edge-triggered D flip-flop with async reset
// Flip-flop D: stocheaza un bit la flanc pozitiv, cu reset asincron
      D_FLIPFLOP dff (
        .D     (d[i]),
        .CLK   (clk),
        .RST   (rst),
        .Q     (q[i]),
        .Q_neg ()
      );
    end
  endgenerate

endmodule
