`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/04/2021 09:48:55 AM
// Design Name: 
// Module Name: divider
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments
// 
//////////////////////////////////////////////////////////////////////////////////


module divider(
    input               clk,
    input               rst,
    input               div,
    input               div_signed,
    input   [31: 0]     x,
    input   [31: 0]     y,
    output  [31: 0]     s,
    output  [31: 0]     r,
    output              complete   
    );
    
    wire [31:0] X;
    wire [31:0] Y;

    wire dividend_sign  = div_signed & x[31];
    wire divisor_sign   = div_signed & y[31];
    wire s_sign         = dividend_sign ^ divisor_sign;
    wire r_sign         = dividend_sign;

    assign X[31:0]      = (dividend_sign ? ~x[31:0]+1 : x[31:0]);
    assign Y[31:0]      = (divisor_sign  ? ~y[31:0]+1 : y[31:0]);

    wire [31:0] S;
    
    reg  [63: 0]    dividend_r    [31: 0];
    wire [63: 0]    dividend_w    [31: 0];
    wire [32: 0]    divisor     = {1'b0, Y[31:0]};

    reg [5:0] time_i;
    always @(posedge clk) begin
        if(rst) begin
            time_i <= 0;
        end else if(time_i != 6'd33 && div) begin
            time_i <= time_i + 5'b1;
        end else begin
            time_i <= 0;
        end

        if(time_i == 0 || time_i == 1) begin
            dividend_r[0][63:0]    <= {32'b0, X[31:0]};
        end else begin
            dividend_r[time_i[5:0]-1][63:0] <= dividend_w[time_i[5:0]-2][63:0];
        end
    end

    genvar i;
    generate
        for(i = 0; i < 32; i = i + 1) begin
            minor div_minor(.A(dividend_r[i]), .B(divisor),.shift(i),.S(S[31-i]),.new_A(dividend_w[i]));
        end
    endgenerate

    assign complete = (time_i == 6'd33);

    assign s[31:0] = s_sign ? ~S[31:0] + 32'b1 : S[31:0];

    assign r[31:0] = r_sign ? ~dividend_w[31][31:0] + 32'b1 : dividend_w[31][31:0];
endmodule
