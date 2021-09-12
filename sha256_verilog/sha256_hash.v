`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.05.2021 11:33:55
// Design Name: 
// Module Name: sha256_transform
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

module sha256_EP1 (
          input wire [31:0] x,
          output wire [31:0] EP1
          );

    assign EP1 = ({x[5:0], x[31:6]} ^ {x[10:0], x[31:11]} ^ {x[24:0], x[31:25]});
// OR, OR

endmodule

// Ch(x,y,z)
module Ch #(parameter WORDSIZE=0) (
    input wire [WORDSIZE-1:0] x, y, z,
    output wire [WORDSIZE-1:0] Ch
    );

    assign Ch = ((x & y) ^ (~x & z));
//AND, OR, NEG, AND

endmodule

module sha256_EP0 (
    input wire [31:0] x,
    output wire [31:0] EP0
    );

    assign EP0 = ({x[1:0], x[31:2]} ^ {x[12:0], x[31:13]} ^ {x[21:0], x[31:22]});
//OR, OR
endmodule
      
// Maj(x,y,z)
module Maj #(parameter WORDSIZE=0) (
    input wire [WORDSIZE-1:0] x, y, z,
    output wire [WORDSIZE-1:0] Maj
    );

    assign Maj = (x & y) ^ (x & z) ^ (y & z);
//AND OR AND OR AND
endmodule

module sha256_hash_helper #(parameter WORDSIZE=0)(
    input [WORDSIZE-1:0] Kj, Wj,
    input [WORDSIZE-1:0] a_in, b_in, c_in, d_in, e_in, f_in, g_in, h_in,
    input [WORDSIZE-1:0] Ch_e_f_g, Maj_a_b_c, EP0_a, EP1_e,
    output [WORDSIZE-1:0] a_out, b_out, c_out, d_out, e_out, f_out, g_out, h_out
    );
    
    wire [WORDSIZE-1:0] T1 = h_in + EP1_e + Ch_e_f_g + Kj + Wj;
//ADD, ADD, ADD, ADD
    wire [WORDSIZE-1:0] T2 = EP0_a + Maj_a_b_c;
//ADD

    assign a_out = T1 + T2;
//ADD
    assign b_out = a_in;
    assign c_out = b_in;
    assign d_out = c_in;
    assign e_out = d_in + T1;
//ADD
    assign f_out = e_in;
    assign g_out = f_in;
    assign h_out = g_in;

endmodule

module sha256_hash (
    input [31:0] Wj,
    input [31:0] Kj,
    input [31:0] a_in, b_in, c_in, d_in, e_in, f_in, g_in, h_in,
    output [31:0] a_out, b_out, c_out, d_out, e_out, f_out, g_out, h_out
    );

    reg kj;
    wire [31:0] Ch_e_f_g, Maj_a_b_c, EP0_a, EP1_e;

    Ch #(.WORDSIZE(32)) Ch (
        .x(e_in), .y(f_in), .z(g_in), .Ch(Ch_e_f_g)
    );

    Maj #(.WORDSIZE(32)) Maj (
        .x(a_in), .y(b_in), .z(c_in), .Maj(Maj_a_b_c)
    );

    sha256_EP0 EP0 (
        .x(a_in), .EP0(EP0_a)
    );

    sha256_EP1 EP1 (
        .x(e_in), .EP1(EP1_e)
    );

    sha256_hash_helper #(.WORDSIZE(32)) sha256_transform_helper_t (
          .Kj(Kj), .Wj(Wj),
          .a_in(a_in), .b_in(b_in), .c_in(c_in), .d_in(d_in),
          .e_in(e_in), .f_in(f_in), .g_in(g_in), .h_in(h_in),
          .Ch_e_f_g(Ch_e_f_g), .Maj_a_b_c(Maj_a_b_c), .EP0_a(EP0_a), .EP1_e(EP1_e),
          .a_out(a_out), .b_out(b_out), .c_out(c_out), .d_out(d_out),
          .e_out(e_out), .f_out(f_out), .g_out(g_out), .h_out(h_out)
      );

endmodule
