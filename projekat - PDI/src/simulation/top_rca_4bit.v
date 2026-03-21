module top_rca_4bit;

  reg  [3:0] A, B;
  reg        Cin;
  wire [3:0] S;
  wire       Cout;

  rca_4bit rca_4bit_inst (
    .A(A), .B(B), .Cin(Cin),
    .S(S), .Cout(Cout)
  );

  integer i;
  initial begin
    $monitor("t=%3d | A=%4b(%0d) B=%4b(%0d) Cin=%0b | S=%4b(%0d) Cout=%0b | A+B+Cin=%0d S_total=%0d %s",
      $time, A, A, B, B, Cin, S, S, Cout, A+B+Cin, {Cout,S},
      ({Cout,S} == (A+B+Cin)) ? "OK" : "GRESKA");

    Cin = 0;
    for (i = 0; i < 2**8; i = i + 1) begin
      {A, B} = i;
      #5;
    end
    Cin = 1;
    for (i = 0; i < 2**8; i = i + 1) begin
      {A, B} = i;
      #5;
    end

    #10 $finish;
  end

endmodule
