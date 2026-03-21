// Jednorazredni potpuni sabirac (Full Adder)
//
// Si  = Ai XOR Bi XOR Ci-1
// Ci  = AiBi + Ci-1(Ai + Bi)

module fa (
  input  A,
  input  B,
  input  Cin,
  output S,
  output Cout
);

  assign S    = A ^ B ^ Cin;
  assign Cout = (A & B) | (Cin & (A ^ B));

endmodule
