module top_csuma_3;

  reg  [2:0] A, B;
  wire [2:0] S;
  wire       C;

  csuma_3 csuma_3_inst (
    .A(A), .B(B),
    .S(S), .C(C)
  );

  integer i;
  initial begin
    $monitor("t=%3d | A=%3b(%0d) B=%3b(%0d) | S=%3b(%0d) C=%0b | A+B=%0d S_total=%0d %s",
      $time, A, A, B, B, S, S, C, A+B, {C,S},
      ({C,S} == (A+B)) ? "OK" : "GRESKA");

    // Sve kombinacije: A i B od 0 do 7 (64 kombinacije)
    for (i = 0; i < 64; i = i + 1) begin
      {A, B} = i;
      #5;
    end

    #10 $finish;
  end

endmodule