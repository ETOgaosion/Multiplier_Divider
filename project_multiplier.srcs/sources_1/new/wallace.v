`timescale 1ns / 1ps

module wallace(
    input   [15: 0]     N,
    input   [13: 0]     cin,
    output              C,
    output              S,
    output  [13: 0]     cout
);
    // layer 1
    wire [10: 0]    layer_2_in;
    full_adder adder_l1_1 (.cin(N[ 3: 1]), .C(cout[4]), .S(layer_2_in[6]));
    full_adder adder_l1_2 (.cin(N[ 6: 4]), .C(cout[3]), .S(layer_2_in[7]));
    full_adder adder_l1_3 (.cin(N[ 9: 7]), .C(cout[2]), .S(layer_2_in[8]));
    full_adder adder_l1_4 (.cin(N[12:10]), .C(cout[1]), .S(layer_2_in[9]));
    full_adder adder_l1_5 (.cin(N[15:13]), .C(cout[0]), .S(layer_2_in[10]));
    assign layer_2_in[5] = N[0];
    genvar  i;
    generate
        for (i=0; i<5; i=i+1) begin
            assign layer_2_in[i] = cin[4-i];
        end
    endgenerate

    // layer 2
    wire [5: 0]    layer_3_in;
    half_adder adder_l2_0 (.cin(layer_2_in[ 1: 0]), .C(cout[8]), .S(layer_3_in[2]));
    full_adder adder_l2_1 (.cin(layer_2_in[ 4: 2]), .C(cout[7]), .S(layer_3_in[3]));
    full_adder adder_l2_2 (.cin(layer_2_in[ 7: 5]), .C(cout[6]), .S(layer_3_in[4]));
    full_adder adder_l2_3 (.cin(layer_2_in[10: 8]), .C(cout[5]), .S(layer_3_in[5]));
    generate
        for (i=0; i<2; i=i+1) begin
            assign layer_3_in[i] = cin[6-i];
        end
    endgenerate

    // layer 3
    wire [5: 0]    layer_4_in;
    full_adder adder_l3_1 (.cin(layer_3_in[ 2: 0]), .C(cout[10]), .S(layer_4_in[4]));
    full_adder adder_l3_2 (.cin(layer_3_in[ 5: 3]), .C(cout[9]), .S(layer_4_in[5]));
    generate
        for (i=0; i<4; i=i+1) begin
            assign layer_4_in[i] = cin[10-i];
        end
    endgenerate

    // layer 4
    wire [2: 0]    layer_5_in;
    full_adder adder_l4_1 (.cin(layer_4_in[ 2: 0]), .C(cout[12]), .S(layer_5_in[1]));
    full_adder adder_l4_2 (.cin(layer_4_in[ 5: 3]), .C(cout[11]), .S(layer_5_in[2]));
    assign layer_5_in[0] = cin[11];

    // layer 5
    wire [2: 0]    layer_6_in;
    full_adder adder_l5_1 (.cin(layer_5_in[ 2: 0]), .C(cout[13]), .S(layer_6_in[2]));
    assign layer_6_in[1] = cin[12];
    assign layer_6_in[0] = cin[13];

    // layer 6
    full_adder adder_l6_1 (.cin(layer_6_in[ 2: 0]), .C(C), .S(S));
endmodule