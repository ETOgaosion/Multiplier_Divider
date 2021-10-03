`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/19/2021 03:41:27 PM
// Design Name: 
// Module Name: booth_part_mul
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


module booth_part_mul(
        input   [65: 0]     X,
        input   [34: 0]     Y,
        input   [ 6: 0]     shift,
        output  [65: 0]     P,
        output              c
    );
    wire [ 3: 0]    S;
    wire [34: 0]    shift_y = Y >> shift;
    wire [ 2: 0]    y_3 = shift_y[2:0];
    wire [65: 0]    x = X << shift;
    booth_choice cal_booth_choice(
        .y(y_3),
        .S(S)
    );
    genvar  i;
    assign P[0] = S[1] & x[0] | S[2] | S[0] & ~x[0];
    generate
        for (i=1; i<66; i=i+1) begin
            assign P[i] = S[1] & x[i] | S[3] & x[i-1] | S[2] & ~x[i-1] | S[0] & ~x[i];
        end
    endgenerate
    assign c = S[0] | S[2];
endmodule
