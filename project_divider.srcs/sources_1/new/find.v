`timescale 1ns / 1ps

module find_64 (
    input               clk,
    input               rst,
    input               div,
    input               complete,
    input   [63: 0]     x,
    output  [ 5: 0]     y,
    output  reg         cal_finish
);
    wire [31: 0]    data_32;
    wire [15: 0]    data_16;
    wire [ 7: 0]    data_8;
    reg  [ 7: 0]    data_8_r;
    wire [ 3: 0]    data_4;
    wire [ 1: 0]    data_2;

    reg             cnt;

    assign y[5] = |x[63:32];
    assign data_32 = y[5] ? x[63:32] : x[31:0];
    assign y[4] = |data_32[31:16];
    assign data_16 = y[4] ? data_32[31:16] : data_32[15:0];
    assign y[3] = |data_16[15:8];
    assign data_8  = y[3] ? data_16[15:8] : data_16[7:0];
    assign y[2] = |data_8_r[7:4];
    assign data_4  = y[2] ? data_8_r[7:4] : data_8_r[3:0];
    assign y[1] = |data_4[3:2];
    assign data_2  = y[1] ? data_4[3:2] : data_4[1:0];
    assign y[0] = data_2[1];

    always @(posedge clk) begin
        if(rst || ~div || complete) begin
            cnt <= 1'b0;
            cal_finish <= 1'b0;
        end else if(~cnt) begin
            cnt <= ~cnt;
        end else if(cnt) begin
            data_8_r <= data_8;
            cal_finish <= 1'b1;
        end
    end

endmodule

module find_33 (
    input               clk,
    input               rst,
    input               div,
    input               complete,
    input   [32: 0]     x,
    output  [ 5: 0]     y,
    output  reg         cal_finish
);

    wire [15: 0]    data_16;
    wire [ 7: 0]    data_8;
    reg  [ 7: 0]    data_8_r;
    wire [ 3: 0]    data_4;
    wire [ 1: 0]    data_2;

    reg             cnt;

    assign y[5] = 0;
    assign y[4] = |x[31:16];
    assign data_16 = y[4] ? x[31:16] : x[15:0];
    assign y[3] = |data_16[15:8];
    assign data_8  = y[3] ? data_16[15:8] : data_16[7:0];
    assign y[2] = |data_8_r[7:4];
    assign data_4  = y[2] ? data_8_r[7:4] : data_8_r[3:0];
    assign y[1] = |data_4[3:2];
    assign data_2  = y[1] ? data_4[3:2] : data_4[1:0];
    assign y[0] = data_2[1];

    always @(posedge clk) begin
        if(rst || ~div || complete) begin
            cnt <= 1'b0;
            cal_finish <= 1'b0;
            data_8_r <= 8'b0;
        end else if(~cnt) begin
            cnt <= ~cnt;
        end else if(cnt) begin
            data_8_r <= data_8;
            cal_finish <= 1'b1;
        end
    end
endmodule