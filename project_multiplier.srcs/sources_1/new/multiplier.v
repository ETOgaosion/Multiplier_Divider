`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/19/2021 03:42:54 PM
// Design Name: 
// Module Name: multiplier
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module multiplier(
        input               clk,
        input               resetn,
        input               mul_signed,
        input   [31: 0]     X,
        input   [31: 0]     Y,
        output  [63: 0]     result
    );
    // booth mul
    wire [65: 0]    P   [16: 0];
    wire [16: 0]    c;
    genvar  i,j;
    wire [65: 0]    src1 = {{34{mul_signed & X[31]}}, X[31:0]};
    wire [34: 0]    src2 = {{2{mul_signed & Y[31]}}, Y[31:0],1'b0};
    generate
        for (i=0; i<17; i=i+1) begin
            booth_part_mul booth(
                .X(src1),
                .Y(src2),
                .shift(i<<1),
                .P(P[i]),
                .c(c[i])
            );
        end
    endgenerate

    // wallace
    wire [16: 0]    N   [65: 0];
    wire [13: 0]    cin [66: 0];
    wire [65: 0]    C;
    wire [65: 0]    S;
    assign cin[0][13:0] = c[13:0];
    generate
        for (i=0; i<66; i=i+1) begin
            for (j=0; j<17; j=j+1) begin
                assign N[i][j] = P[j][i];
            end
            wallace w_tree(
                .N(N[i]),
                .cin(cin[i]),
                .C(C[i]),
                .S(S[i]),
                .cout(cin[i+1])
            );
        end
    endgenerate

    // full adder
    wire [63: 0]    C_adder;
    wire            cin_adder;
    assign C_adder = {C[62:0],c[14]};
    assign cin_adder = c[15];
    adder_64 adder(.C(C_adder),.S(S[63:0]),.cin(cin_adder),.out(result));
endmodule
