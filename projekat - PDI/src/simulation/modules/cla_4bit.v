// Cetvororazredni sabirac sa paralelnim prenosom (Carry Lookahead Adder)
//
// Svi medjuprenosi se racunaju paralelno iz G i P signala:
//
//   C1 = G0 + P0*C0
//   C2 = G1 + P1*G0 + P1*P0*C0
//   C3 = G2 + P2*G1 + P2*P1*G0 + P2*P1*P0*C0
//   C4 = G3 + P3*G2 + P3*P2*G1 + P3*P2*P1*G0 + P3*P2*P1*P0*C0
//
// Svaki FA dobija vec izracunat prenos, ne ceka na prethodni FA.

module cla_4bit (
  input  [3:0] A,
  input  [3:0] B,
  input        Cin,
  output [3:0] S,
  output       Cout
);

  // G i P signali iz svakog razreda
  wire [3:0] G, P;

  // Medjuprenosi izracunati paralelno
  wire C1, C2, C3;

  // CLA logika - paralelno racunanje svih prenosa
  assign C1   = G[0] | (P[0] & Cin);
  assign C2   = G[1] | (P[1] & G[0]) | (P[1] & P[0] & Cin);
  assign C3   = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & Cin);
  assign Cout = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0])
                     | (P[3] & P[2] & P[1] & P[0] & Cin);

  // Instanciranje potpunih sabiraca sa paralelno izracunatim prenosima
  fa inst0 (.A(A[0]), .B(B[0]), .Cin(Cin), .S(S[0]), .Cout(), .G(G[0]), .P(P[0]));
  fa inst1 (.A(A[1]), .B(B[1]), .Cin(C1),  .S(S[1]), .Cout(), .G(G[1]), .P(P[1]));
  fa inst2 (.A(A[2]), .B(B[2]), .Cin(C2),  .S(S[2]), .Cout(), .G(G[2]), .P(P[2]));
  fa inst3 (.A(A[3]), .B(B[3]), .Cin(C3),  .S(S[3]), .Cout(), .G(G[3]), .P(P[3]));

endmodule
