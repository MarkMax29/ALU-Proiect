`include "fac.v"

// Sumator/scazator ripple-carry: realizeaza add sau sub in functie de op
module RCA_SUBTRACTOR (
  input [7:0] x, y,
  input c_in, op,  //cand op=0 -> adunare, op=1 -> scadere
  output [7:0] z,
  output c_out
);

  wire [7:0] leg;
  wire [7:0] y_scadere;
  assign y_scadere=op?~y:y; //daca op=1, inverseaza bitii lui y, altfel y ramane neschimbat

// Modul factorial sau alt bloc specific (fac)
  fac fac0(.x(x[0]), .y(y_scadere[0]), .c_in(op),    .z(z[0]), .c_out(leg[0]));
// Modul factorial sau alt bloc specific (fac)
  fac fac1(.x(x[1]), .y(y_scadere[1]), .c_in(leg[0]),   .z(z[1]), .c_out(leg[1]));
// Modul factorial sau alt bloc specific (fac)
  fac fac2(.x(x[2]), .y(y_scadere[2]), .c_in(leg[1]),   .z(z[2]), .c_out(leg[2]));
// Modul factorial sau alt bloc specific (fac)
  fac fac3(.x(x[3]), .y(y_scadere[3]), .c_in(leg[2]),   .z(z[3]), .c_out(leg[3]));
// Modul factorial sau alt bloc specific (fac)
  fac fac4(.x(x[4]), .y(y_scadere[4]), .c_in(leg[3]),   .z(z[4]), .c_out(leg[4]));
// Modul factorial sau alt bloc specific (fac)
  fac fac5(.x(x[5]), .y(y_scadere[5]), .c_in(leg[4]),   .z(z[5]), .c_out(leg[5]));
// Modul factorial sau alt bloc specific (fac)
  fac fac6(.x(x[6]), .y(y_scadere[6]), .c_in(leg[5]),   .z(z[6]), .c_out(leg[6]));
// Modul factorial sau alt bloc specific (fac)
  fac fac7(.x(x[7]), .y(y_scadere[7]), .c_in(leg[6]),   .z(z[7]), .c_out(c_out));

endmodule



