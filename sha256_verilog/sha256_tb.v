`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.05.2021 11:18:39
// Design Name: 
// Module Name: sha256_tb
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


module sha256_tb;
    reg clk;
    reg  [511:0] data_in;
    wire [255:0] data_out;
    reg input_valid;
    wire output_valid;
    wire [255:0] Hash_in;
    integer len;
    integer index;
    
    integer i1;
    integer scan_file;
    
    sha256_Hash_in init_Hash(
        .Hash_in(Hash_in)
    );

    sha256_core dut(
        .clk(clk),
        .reset_n(),
        .Hash_in(Hash_in),
        .data_in(data_in),
        .input_valid(input_valid),
        .Hash_out(data_out),
        .output_valid(output_valid)
    );

    
    always
        #5 clk = !clk;

    initial begin
        clk = 1;
        i1 = $fopen("/home/ljaliminche/Desktop/CSE225/i1.txt", "r");
        scan_file = $fscanf(i1, "%s\n", data_in);
        len = 3;
        //data_in = "aaaaaaaaaa";len = 10;
//        data_in = "abc";len = 3;
        input_valid = 1;
        /* data preprocessing */
        data_in = data_in << (512 - (len * 8));
        data_in[63:0] = (len * 8);
        index = ((512 - (len * 8)) - 1);
        data_in[index] = 1'b1;
        @(posedge clk);        
        $display("data_in : %s", data_in);
        
        /* wait until output is ready*/
        while(output_valid != 1)begin
            input_valid = 0;
            @(posedge clk);
        end
//        $display("H_out : %h", data_out);
        $display("H_out : %h:%h:%h:%h:%h:%h:%h:%h:%h:%h:%h:%h:%h:%h:%h:%h:%h:%h:%h:%h:%h:%h:%h:%h:%h:%h:%h:%h:%h:%h:%h:%h", data_out[255:248],data_out[247:240],data_out[239:232],data_out[231:224],data_out[223:216],data_out[215:208],data_out[207:200],data_out[199:192],data_out[191:184],data_out[183:176],data_out[175:168],data_out[167:160],data_out[159:152],data_out[151:144],data_out[143:136],data_out[135:128],data_out[127:120],data_out[119:112],data_out[111:104],data_out[103:96],data_out[95:88],data_out[87:80],data_out[79:72],data_out[71:64],data_out[63:56],data_out[55:48],data_out[47:40],data_out[39:32],data_out[31:24],data_out[23:16],data_out[15:8],data_out[7:0]);
        
        $finish;
    end
    
endmodule
