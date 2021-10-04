`timescale 1ns / 1ps

module minor (
    input   [63: 0]     A,
    input   [32: 0]     B,
    input   [ 6: 0]     shift,
    output              S,
    output  [63: 0]     new_A
);
    wire [32: 0]    src1;
    wire [63: 0]    src1_mid;
    wire [32: 0]    res;
    wire [63: 0]    clear;
    wire [63: 0]    res_assign;

    assign src1_mid = A[63:0] << shift;
    assign src1 = src1_mid[63:31];
    assign res = src1[32: 0] - B[32: 0];

    assign S = ~res[32];

    assign clear[63:0] = (S ? ((shift == 7'b0) ? {33'b0,31'h7fffffff} : {1'b1,33'b0,30'h3fffffff} >>> (shift-1)) : 64'hffffffff);

    assign res_assign[63:0] = (S ? {31'b0, res[32:0]} << (31-shift) : 64'b0);

    assign new_A = (A & clear | res_assign);
    
endmodule