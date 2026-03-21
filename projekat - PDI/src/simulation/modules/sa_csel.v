// Grupni sabirac (Sub-Adder) za Carry Select Adder
//
// Racuna paralelno DVA moguca rezultata za grupu od 2 bita:
//   S0, C0 - zbir i prenos grupe ako je ulazni prenos Cin = 0
//   S1, C1 - zbir i prenos grupe ako je ulazni prenos Cin = 1
//
// Interno koristi dva RCA lanca (jedan sa cin=0, drugi sa cin=1).
// MPX u csel_4bit bira tacan rezultat na osnovu stvarnog prenosa.

module sa (
  input  [1:0] A,
  input  [1:0] B,
  output [1:0] S0,   // suma grupe uz pretpostavku Cin=0
  output       C0,   // prenos grupe uz pretpostavku Cin=0
  output [1:0] S1,   // suma grupe uz pretpostavku Cin=1
  output       C1    // prenos grupe uz pretpostavku Cin=1
);

  wire c0_1, c1_1;

  // RCA lanac sa pretpostavkom Cin = 0
  fa fa0_0 (.A(A[0]), .B(B[0]), .Cin(1'b0), .S(S0[0]), .Cout(c0_1));
  fa fa0_1 (.A(A[1]), .B(B[1]), .Cin(c0_1), .S(S0[1]), .Cout(C0)  );

  // RCA lanac sa pretpostavkom Cin = 1
  fa fa1_0 (.A(A[0]), .B(B[0]), .Cin(1'b1), .S(S1[0]), .Cout(c1_1));
  fa fa1_1 (.A(A[1]), .B(B[1]), .Cin(c1_1), .S(S1[1]), .Cout(C1)  );

endmodule
