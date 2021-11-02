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
    output  [63: 0]     div_total_result,
    output              es_go,
    output              complete   
    );
    
    wire [31:0] X;
    wire [31:0] Y;
    reg  [31:0] x_r;
    reg  [31:0] y_r;
    reg         div_signed_r;

    wire [31:0] s;
    wire [31:0] r;
    wire [31:0] S;
    wire [31:0] R;
    reg         div_r;

    wire dividend_sign  = div_signed_r & x_r[31];
    wire divisor_sign   = div_signed_r & y_r[31];
    wire s_sign         = dividend_sign ^ divisor_sign;
    wire r_sign         = dividend_sign;

    assign X[31:0]      = (dividend_sign ? ~x_r[31:0]+1 : x_r[31:0]);
    assign Y[31:0]      = (divisor_sign  ? ~y_r[31:0]+1 : y_r[31:0]);

    wire [31:0] S;

    always @(posedge clk) begin
        if(rst || complete) begin
            x_r <= 32'b0;
            y_r <= 32'b0;
            div_signed_r <= 1'b0;
        end else if (div) begin
            x_r <= x;
            y_r <= y;
            div_signed_r <= div_signed;
        end
    end
    
    wire [63: 0]    dividend    = {32'b0,X[31:0]};
    wire [32: 0]    divisor     = {1'b0, Y[31:0]};

    wire            find64_finish;
    wire            find32_finish;
    wire [ 5: 0]    pos_dividend;
    wire [ 5: 0]    pos_divisor;
    wire [ 5: 0]    skip_pos;
    wire [ 5: 0]    skip_pos_mid;

    find_64 find_first_1_in_dividend(.clk(clk),.rst(rst),.div(div_r),.complete(complete),.x(dividend),.y(pos_dividend),.cal_finish(find64_finish));
    find_33 find_first_1_in_divisor (.clk(clk),.rst(rst),.div(div_r),.complete(complete),.x(divisor),.y(pos_divisor),.cal_finish(find32_finish));

    assign skip_pos_mid = pos_divisor - pos_dividend;
    assign skip_pos = skip_pos_mid[5] ? skip_pos_mid + 6'd31 : 6'd31;


    minus div_minor(
        .clk(clk),
        .reset(rst),
        .A(dividend),
        .B(divisor),
        .skip_pos(skip_pos),
        .skip_cal_finish(find64_finish && find32_finish),
        .S(S),
        .R(R),
        .es_go(es_go),
        .complete(complete)
    );

    assign s[31:0] = s_sign ? ~S[31:0] + 32'b1 : S[31:0];

    assign r[31:0] = r_sign ? ~R + 32'b1 : R;

    always @(posedge clk) begin
        if(rst || complete) begin
            div_r <= 1'b0;
        end else if(div) begin
            div_r <= 1'b1;
        end
    end

    assign div_total_result = {s,r};
endmodule