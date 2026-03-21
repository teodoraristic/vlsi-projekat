// Cetvororazredni sabirac na osnovu bita prenosa (Carry Select Adder)
//
// Podjeljen na dvije grupe od po 2 bita.
// Svaka grupa paralelno racuna dva rezultata (za Cin=0 i Cin=1).
// MPX bira tacan rezultat na osnovu stvarnog prenosa prethodne grupe.
//
// Grupa 0 (biti 1..0): Cin je poznat odmah (ulazni Cin sabirica)
// Grupa 1 (biti 3..2): Cin = Cout grupe 0, bira se MPX-om

module csel_4bit (
  input  [3:0] A,
  input  [3:0] B,
  input        Cin,
  output [3:0] S,
  output       Cout
);

  // Izlazi grupe 0
  wire [1:0] S0_g0, S1_g0;
  wire       C0_g0,  C1_g0;

  // Izlazi grupe 1
  wire [1:0] S0_g1, S1_g1;
  wire       C0_g1,  C1_g1;

  // Tacan prenos iz grupe 0
  wire Cout_g0;

  // Grupa 0: biti 1..0
  // Cin je poznat -> MPX bira odmah
  sa sa_inst0 (
    .A(A[1:0]), .B(B[1:0]),
    .S0(S0_g0), .C0(C0_g0),
    .S1(S1_g0), .C1(C1_g0)
  );

  assign S[1:0]  = Cin ? S1_g0 : S0_g0;
  assign Cout_g0 = Cin ? C1_g0 : C0_g0;

  // Grupa 1: biti 3..2
  // Cin nije poznat unaprijed -> racunamo oba, MPX bira na osnovu Cout_g0
  sa sa_inst1 (
    .A(A[3:2]), .B(B[3:2]),
    .S0(S0_g1), .C0(C0_g1),
    .S1(S1_g1), .C1(C1_g1)
  );

  assign S[3:2] = Cout_g0 ? S1_g1 : S0_g1;
  assign Cout   = Cout_g0 ? C1_g1 : C0_g1;

endmodule
