`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/19/2021 07:26:54 PM
// Design Name: 
// Module Name: testbench
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


module testbench();
    reg     [31: 0]     X;
    reg     [31: 0]     Y;
    wire    [63: 0]     res;
    wire    [63: 0]     ref_res;

    assign ref_res = $signed(X) * $signed(Y);
    multiplier mul(.X(X),.Y(Y),.result(res));

    reg clk;
    initial begin
        clk = 1'b0;
    end

    always #10 clk = ~clk;

    always @(posedge clk) begin
        X <= $random();
        Y <= $random();
    end
endmodule
