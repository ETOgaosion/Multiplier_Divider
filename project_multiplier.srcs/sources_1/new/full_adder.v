`timescale 1ns / 1ps

module full_adder(
    input   [ 2: 0]     cin,
    output              C,
    output              S
);
    assign {C,S} = cin[0] + cin[1] + cin[2];
endmodule