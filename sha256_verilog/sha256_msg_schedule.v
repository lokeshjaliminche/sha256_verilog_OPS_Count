`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.05.2021 13:05:50
// Design Name: 
// Module Name: sha256_data_transform
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

module sha256_s0 (
          input wire [31:0] x,
          output wire [31:0] s0
          );
    assign s0 = ({x[6:0], x[31:7]} ^ {x[17:0], x[31:18]} ^ (x >> 3));

endmodule
      
module sha256_s1 (
          input wire [31:0] x,
          output wire [31:0] s1
          );
    assign s1 = ({x[16:0], x[31:17]} ^ {x[18:0], x[31:19]} ^ (x >> 10));

endmodule
      
      
// prepare and update words used for hashing
module sha256_msg_schedule #(parameter WORDSIZE=1) (
          input clk,
          input [WORDSIZE*16-1:0] M,
          input M_valid,
          output [WORDSIZE-1:0] W_tm2, W_tm15,
          input [WORDSIZE-1:0] s1_Wtm2, s0_Wtm15,
          output [WORDSIZE-1:0] W
          );

     reg [WORDSIZE*16-1:0] WORD_ARR;
      // W(t-n) values, from the perspective of Wt_next
      //There are total 16 words of size 32 bits
      /* 63 : 32 == second word*/
      assign W_tm2 = WORD_ARR[WORDSIZE*2-1:WORDSIZE*1];
      
      /* 479 : 448 == 15th word*/
      assign W_tm15 = WORD_ARR[WORDSIZE*15-1:WORDSIZE*14];
       
      /*223 : 192 == 7th word  */ 
      wire [WORDSIZE-1:0] W_tm7 = WORD_ARR[WORDSIZE*7-1:WORDSIZE*6];
      
      /*511 : 480 == 16th word */
      wire [WORDSIZE-1:0] W_tm16 = WORD_ARR[WORDSIZE*16-1:WORDSIZE*15]; 
      
      // Wt_next is the next Wt to be pushed to the queue, will be consumed in 16 rounds
      /*initialize the new workd adding all the words calculated above*/
      wire [WORDSIZE-1:0] Wt_next = s1_Wtm2 + W_tm7 + s0_Wtm15 + W_tm16; 

      /*
        for ( ; i < 64; ++i)
           m[i] = SIG1(m[i - 2]) + m[i - 7] + SIG0(m[i - 15]) + m[i - 16];
      */
      /*update the word list*/
      wire [WORDSIZE*16-1:0] WORD_ARR_D = {WORD_ARR[WORDSIZE*15-1:0], Wt_next};
      
      assign W = WORD_ARR[WORDSIZE*16-1:WORDSIZE*15];

      always @(posedge clk)
      begin
          if (M_valid) begin
              WORD_ARR <= M;
             // $display("Wt_next : %h",Wt_next);
             // $display("WORD ARR : %h",WORD_ARR);              
          end else begin
              WORD_ARR <= WORD_ARR_D;
             // $display("Wt_next : %h",Wt_next);
             // $display("WORD ARR : %h",WORD_ARR);
          end
      end
      
endmodule
