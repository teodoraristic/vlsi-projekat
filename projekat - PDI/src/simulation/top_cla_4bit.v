module top_cla_4bit;

  reg  [3:0] A, B;
  reg        Cin;
  wire [3:0] S;
  wire       Cout;

  cla_4bit cla_4bit_inst (
    .A(A), .B(B), .Cin(Cin),
    .S(S), .Cout(Cout)
  );

  integer i;
  initial begin
    $monitor("t=%3d | A=%4b(%0d) B=%4b(%0d) Cin=%0b | S=%4b(%0d) Cout=%0b | A+B+Cin=%0d S_total=%0d %s",
      $time, A, A, B, B, Cin, S, S, Cout, A+B+Cin, {Cout,S},
      ({Cout,S} == (A+B+Cin)) ? "OK" : "GRESKA");

    // Sve kombinacije: A i B od 0 do 15, Cin 0 i 1 (512 kombinacija)
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
