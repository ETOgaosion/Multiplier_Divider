`timescale 1ns / 1ps

module adder_64(
    input   [63: 0]     C,
    input   [63: 0]     S,
    input               cin,
    output  [63: 0]     out
);
    assign out = C + S + {63'b0,cin};
endmodule