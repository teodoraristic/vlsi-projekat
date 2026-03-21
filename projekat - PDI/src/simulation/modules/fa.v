// Jednorazredni potpuni sabirac (Full Adder)
//
// Racuna zbir (S) i prenos (Cout) za ulaze A, B i Cin.
// Takodje generise signale:
//   G (Generate)  = A & B    -> prenos se generise bez obzira na Cin
//   P (Propagate) = A | B    -> prenos se propagira ako postoji Cin

module fa (
  input  A,
  input  B,
  input  Cin,
  output S,    // suma
  output Cout, // prenos
  output G,    // generate
  output P     // propagate
);

  assign S    = A ^ B ^ Cin;
  assign Cout = (A & B) | (Cin & (A ^ B));
  assign G    = A & B;
  assign P    = A | B;

endmodule
