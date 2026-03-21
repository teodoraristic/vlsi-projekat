module cc (
  input  A,
  input  B,
  output S0, C0,  // rezultati za Cin=0
  output S1, C1   // rezultati za Cin=1
);

  assign S0 = A ^ B;       // A+B+0: suma
  assign C0 = A & B;       // A+B+0: prenos
  assign S1 = ~(A ^ B);    // A+B+1: suma
  assign C1 = A | B;       // A+B+1: prenos

endmodule