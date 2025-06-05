module D_FLIPFLOP(
  input D,
  input CLK,
  input RST,
  output Q,
  output Q_neg
);
  wire s0;
  wire s1;
  wire s2;
  wire s3;
  wire Q_neg_temp;
  wire Q_temp;
  assign s0 = ~ CLK;
  assign s1 = (D & ~ RST);
  assign s3 = ~ (~ (s1 & s0) & s2);
  assign s2 = ~ (~ (~ s1 & s0) & s3);
  assign Q_temp = ~ (~ (s3 & CLK) & Q_neg_temp);
  assign Q_neg_temp = ~ (~ (s2 & CLK) & Q_temp);
  assign Q = Q_temp;
  assign Q_neg = Q_neg_temp;
endmodule
