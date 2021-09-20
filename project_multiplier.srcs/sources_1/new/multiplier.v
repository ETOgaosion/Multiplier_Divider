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
        input   [31: 0]     X,
        input   [31: 0]     Y,
        output  [63: 0]     result
    );
    // booth mul
    wire [63: 0]    P   [15: 0];
    wire [15: 0]    c;
    genvar  i,j;
    generate
        for (i=0; i<16; i=i+1) begin
            booth_part_mul booth(
                .X(X),
                .Y(Y),
                .shift(i<<1),
                .P(P[i]),
                .c(c[i])
            );
        end
    endgenerate

    // wallace
    wire [15: 0]    N   [63: 0];
    wire [13: 0]    cin [64: 0];
    wire [63: 0]    C;
    wire [63: 0]    S;
    assign cin[0][13:0] = c[13:0];
    generate
        for (i=0; i<64; i=i+1) begin
            for (j=0; j<16; j=j+1) begin
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
    adder_64 adder(.C(C_adder),.S(S),.cin(cin_adder),.out(result));
endmodule
