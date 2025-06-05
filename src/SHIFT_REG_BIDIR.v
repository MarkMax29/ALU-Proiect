`include "D_FLIPFLOP.v"
`include "Mux_4x1.v"

// Registru de shift bidirectional: deplasare stanga/dreapta
module SHIFT_REG_BIDIR (
    input  wire [7:0] IN,
    input  wire       load,   // 1: load parallel data, 0: shift
    input  wire       dr,     // when load=0: 0=shift right, 1=shift left
    input  wire       clk,
    input  wire       rst,
    output wire       msb,
    output wire       lsb,
    output wire [7:0] o
);

    wire [7:0] d;
    wire [7:0] q;
    wire [1:0] sel;

    // Combine load and direction into 2-bit select
    // sel[1] = load, sel[0] = ~load & dr
    assign sel = {load, ~load & dr};

    // Outputs
    assign o   = q;
    assign msb = q[7];
    assign lsb = q[0];

    genvar i;
    generate
      for (i = 0; i < 8; i = i + 1) begin : shifts
        // Determine shift inputs
        wire in_left  = (i == 7) ? msb : q[i+1];
        wire in_right = (i == 0) ? lsb : q[i-1];
        wire load_val = IN[i];

        // 4-to-1 MUX: {left, right, load, 0}
        Mux_4x1 mux (
          .sel   (sel),
          .in_0  (in_left),
          .in_1  (in_right),
          .in_2  (load_val),
          .in_3  (1'b0),
          .out   (d[i])
        );

        // D flip-flop
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
