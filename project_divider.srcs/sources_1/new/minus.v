`timescale 1ns / 1ps

module minus (
    input               clk,
    input               reset,
    input   [63: 0]     A,
    input   [32: 0]     B,
    input   [ 5: 0]     skip_pos,
    input               skip_cal_finish,
    output  reg [31: 0]     S,
    output  [31: 0]     R,
    output              es_go,
    output              complete
);

    wire [32: 0]    minuend;
    wire [32: 0]    minus_res;
    wire            s;
    reg  [63: 0]    A_r;
    wire [63: 0]    new_A;

    wire [63: 0]    clear_window = 64'hffff_ffff_8000_0000;

    reg  [ 5: 0]    time_i;
    reg             skipped;

    always @(posedge clk) begin
        if(reset || complete) begin
            time_i <= 6'b0;
            skipped <= 1'b0;
        end else if(skip_cal_finish && ~skipped) begin
            time_i <= skip_pos;
            skipped <= 1'b1;
        end else if(skipped) begin
            time_i <= time_i + 1;
        end

        if(reset || complete) begin
            A_r <= 64'b0;
        end else if(skip_cal_finish && ~skipped) begin
            A_r <= (A << skip_pos);
        end else begin
            A_r <= ((A_r & ~clear_window) | new_A) << 1;
        end
        
        if(reset || complete) begin
            S <= 32'b0;
        end else if(skipped) begin
            S <= S | ({s,31'b0} >> time_i);
        end
    end

    assign minuend = A_r[63:31];
    assign minus_res = minuend - B;
    assign s = ~minus_res[32];
    assign new_A[63:31] = s ? minus_res : minuend;
    assign new_A[30: 0] = 31'b0;
    assign R = A_r[63:32];
    
    assign es_go = (time_i == 6'd31);
    assign complete = (time_i == 6'd32);
endmodule