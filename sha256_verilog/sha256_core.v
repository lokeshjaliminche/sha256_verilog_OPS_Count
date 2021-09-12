`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.05.2021 10:57:09
// Design Name: 
// Module Name: sha256_core
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

module sha256_Hash_in(output [255:0] Hash_in);
    assign Hash_in = {
        32'h6A09E667, 32'hBB67AE85, 32'h3C6EF372, 32'hA54FF53A,
        32'h510E527F, 32'h9B05688C, 32'h1F83D9AB, 32'h5BE0CD19
    };

endmodule


module sha256_core(
        input clk,
        input reset_n,
        input [255:0] Hash_in, /* This is initial hash function */
        input [511:0] data_in, /* This is initial message to encrypt */
        input input_valid, /* check if input is valid */
        output [255:0] Hash_out, /* This is final hash */ 
        output output_valid  /* check final hash if the output_valid is true */
    );
    
    
    reg [6:0] round;
    
    wire [31:0] a_in = Hash_in[255:224], b_in = Hash_in[223:192];
    wire [31:0] c_in = Hash_in[191:160], d_in = Hash_in[159:128];
    wire [31:0] e_in = Hash_in[127:96], f_in = Hash_in[95:64];
    wire [31:0] g_in = Hash_in[63:32], h_in = Hash_in[31:0];
    
    /* Intermediate hash constants */
    reg [31:0] a_q, b_q, c_q, d_q, e_q, f_q, g_q, h_q;
    
    /* Temporary variables for calculating the intermediate hash values */
    wire [31:0] a_d, b_d, c_d, d_d, e_d, f_d, g_d, h_d;
    
    /* temp variables to transform words */
    wire [31:0] W_tm2, W_tm15, s1_Wtm2, s0_Wtm15, Wj, Kj;
    
    /* Enable output_valid if 64 rounds are completed */ 
    assign output_valid = round == 64;
    
    /* This is final step to prepare hash out */
    assign Hash_out = {
        a_in + a_q, b_in + b_q, c_in + c_q, d_in + d_q, e_in + e_q, f_in + f_q, g_in + g_q, h_in + h_q
    };   
    
    
    always @(posedge clk)
    begin
        if (input_valid) begin
            round <= 0;
            a_q <= a_in; b_q <= b_in; c_q <= c_in; d_q <= d_in;
            e_q <= e_in; f_q <= f_in; g_q <= g_in; h_q <= h_in;
        end else begin
            a_q <= a_d; b_q <= b_d; c_q <= c_d; d_q <= d_d;
            e_q <= e_d; f_q <= f_d; g_q <= g_d; h_q <= h_d;
            round <= round + 1;
// addition 
//            $display("round : %d", round);
        end
        
    end
 
 
    /* selecting constant */
    sha256_K_iterator sha256_K_iterator_t (
        .clk(clk), .rst(input_valid), .K(Kj)
    );      
    
    sha256_s0 sha256_s0 (.x(W_tm15), .s0(s0_Wtm15));
    sha256_s1 sha256_s1 (.x(W_tm2), .s1(s1_Wtm2));

    sha256_msg_schedule #(.WORDSIZE(32)) sha256_msg_schedule_t (
        .clk(clk),
        .M(data_in), .M_valid(input_valid),
        .W_tm2(W_tm2), .W_tm15(W_tm15),
        .s1_Wtm2(s1_Wtm2), .s0_Wtm15(s0_Wtm15),
        .W(Wj)
    );
    
    sha256_hash sha256_hash_t (
        .Kj(Kj), .Wj(Wj),
        .a_in(a_q), .b_in(b_q), .c_in(c_q), .d_in(d_q),
        .e_in(e_q), .f_in(f_q), .g_in(g_q), .h_in(h_q),
        .a_out(a_d), .b_out(b_d), .c_out(c_d), .d_out(d_d),
        .e_out(e_d), .f_out(f_d), .g_out(g_d), .h_out(h_d)
    );
endmodule
