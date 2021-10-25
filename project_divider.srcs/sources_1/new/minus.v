`timescale 1ns / 1ps

module minus (
    input   [32: 0]     A,
    input   [32: 0]     B,
    input   [30: 0]     remain_A,
    output              S,
    output  [32: 0]     new_A,
    output  [30: 0]     old_A
);
    wire [32: 0]    res;

    assign res = A[32: 0] - B[32: 0];

    assign S = ~res[32];

    assign new_A = S ? res : A;

    assign old_A = remain_A;
    
endmodule