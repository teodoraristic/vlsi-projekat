// Cetvororazredni sabirac sa serijskim prenosom (Ripple Carry Adder)
//
// Prenos se propagira sekvencijalno kroz razrede:
//   C0 = Cin
//   C1 = Cout FA0
//   C2 = Cout FA1
//   C3 = Cout FA2
//   Cout = Cout FA3
//
// Prednosti: jednostavna i regularna struktura, malo kola
// Mane: veliko kasnjenje, srazmerno broju razreda

module rca_4bit (
  input  [3:0] A,
  input  [3:0] B,
  input        Cin,
  output [3:0] S,
  output       Cout
);

  wire C1, C2, C3;

  fa inst0 (.A(A[0]), .B(B[0]), .Cin(Cin), .S(S[0]), .Cout(C1)  );
  fa inst1 (.A(A[1]), .B(B[1]), .Cin(C1),  .S(S[1]), .Cout(C2)  );
  fa inst2 (.A(A[2]), .B(B[2]), .Cin(C2),  .S(S[2]), .Cout(C3)  );
  fa inst3 (.A(A[3]), .B(B[3]), .Cin(C3),  .S(S[3]), .Cout(Cout));

endmodule
