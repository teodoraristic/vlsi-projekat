// Trorazredni uslovni sabirac (3-bit Conditional Sum Adder)
//
// Svaki razred generiše S0,C0 i S1,C1 paralelno.
// Carry se propagira kroz MUX-eve, ne kroz lance sabirac-a.
//
// Struktura:
//   Razred 0: Cim1 = 0 (nema carry-a ispred)
//   Razred 1: Cim1 = Ci[0] (carry iz razreda 0)
//   Razred 2: Cim1 = Ci[1] (carry iz razreda 1)
//
//   Krajnji carry C = Ci[2]

module csuma_3 (
  input  [2:0] A,
  input  [2:0] B,
  output [2:0] S,
  output       C
);

  wire [2:0] S0, C0, S1, C1, Si, Ci;

  // Razred 0: Cin je uvek 0
  csuma_1 inst0 (
    .A(A[0]), .B(B[0]),
    .Cim1(1'b0),
    .S0(S0[0]), .C0(C0[0]),
    .S1(S1[0]), .C1(C1[0]),
    .Si(Si[0]), .Ci(Ci[0])
  );

  // Razred 1: Cin je Ci[0]
  csuma_1 inst1 (
    .A(A[1]), .B(B[1]),
    .Cim1(Ci[0]),
    .S0(S0[1]), .C0(C0[1]),
    .S1(S1[1]), .C1(C1[1]),
    .Si(Si[1]), .Ci(Ci[1])
  );

  // Razred 2: Cin je Ci[1]
  csuma_1 inst2 (
    .A(A[2]), .B(B[2]),
    .Cim1(Ci[1]),
    .S0(S0[2]), .C0(C0[2]),
    .S1(S1[2]), .C1(C1[2]),
    .Si(Si[2]), .Ci(Ci[2])
  );

  // Izlazi
  assign S = Si;  // Si je vec selektovano u svakom csuma_1
  assign C = Ci[2];

endmodule