`timescale 1ns / 1ps

module booth_choice(
    input   [ 2: 0]     y,  // y[2]=y_i+1, y[1]=y_i, y[0]=y_i-1
    output  [ 3: 0]     S   // S[0]=S_-x, S[1]=S_x, S[2]=S_-2x, S[3]=S_2x
);
    assign S[0] = ~(~(y[2] & y[1] & ~y[0]) & ~(y[2] & ~ y[1] & y[0]));
    assign S[1] = ~(~(~y[2] & y[1] & ~y[0]) & ~(~y[2] & ~ y[1] & y[0]));
    assign S[2] = ~(~(y[2] & ~y[1] & ~y[0]));
    assign S[3] = ~(~(~y[2] & y[1] & y[0]));
endmodule