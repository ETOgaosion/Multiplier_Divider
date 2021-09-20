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
        input   [31: 0]     X,
        input   [31: 0]     Y,
        input   [ 6: 0]     shift,
        output  [63: 0]     P,
        output              c
    );
    wire [ 3: 0]    S;
    wire [32: 0]    y = {Y,1'b0};
    wire [32: 0]    shift_y = y >> shift;
    wire [ 2: 0]    y_3 = shift_y[2:0];
    wire [32: 0]    x = {X,1'b0};
    wire [31: 0]    p;
    wire [95: 0]    P_more;
    booth_choice cal_booth_choice(
        .y(y_3),
        .S(S)
    );
    genvar  i;
    generate
        for (i=0; i<32; i=i+1) begin
            assign p[i] = ~(~(S[0] & ~x[i+1]) & ~(S[2] & ~  x[i]) & ~(S[1] & x[i+1]) & ~(S[3] & x[i]));
        end
    endgenerate
    assign P_more = {{32{c^X[31]}},p,{32{c}}} << shift;
    assign P = P_more[95:32];
    assign c = S[0] | S[2];
endmodule
