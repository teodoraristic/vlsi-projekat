// Jednorazredni uslovni sabirac (1-bit Conditional Sum Adder)
//
// Za svaki bit se racunaju DVA moguca rezultata:
//   - slucaj Cin=0: S0, C0
//   - slucaj Cin=1: S1, C1
// Na osnovu stvarnog Cin (Cim1) selektuje se pravi izlaz: Si, Ci

module csuma_1 (
  input  A,
  input  B,
  input  Cim1,   // carry iz prethodnog razreda
  output S0, C0, // rezultati pretpostavljajuci Cin=0
  output S1, C1, // rezultati pretpostavljajuci Cin=1
  output Si,     // selektovana suma
  output Ci      // selektovani carry
);

  // Generisanje oba moguca rezultata
  cc cc_inst (
    .A(A), .B(B),
    .S0(S0), .C0(C0),
    .S1(S1), .C1(C1)
  );

  // Selekcija na osnovu stvarnog carry-a iz prethodnog razreda
  assign Si = Cim1 ? S1 : S0;
  assign Ci = Cim1 ? C1 : C0;

endmodule