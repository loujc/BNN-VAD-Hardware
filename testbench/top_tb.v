/*
testbench for top

只要使能、送数就可以
送6帧（6x20） result才可以输出
测一下使能的性能

*/

`timescale 1ns/1ps
module top_tb ();
reg                 clk               ,
                    rst_n             ,
                    read_en           ;
reg   [15:0]        data_in[1:20]     ;
reg                 empty             ;//test用
wire  [1:0]         result            ;

always #10 clk = ~clk;
always @(negedge clk) read_en = (empty==1)? 1 : 0;
initial begin
    clk     <= 0;
    rst_n   <= 0;
    #2 rst_n <= 1;
    // read_en <= 0;
    #5 data_in <= {16'd1,16'd2,16'd3,16'd4,16'd5,16'd6,16'd7,16'd8,16'd9,16'd10,  16'd1,16'd1,16'd1,16'd1,16'd1,16'd6,16'd6,16'd6,16'd6,16'd6};
    #160 data_in <= {16'd2,16'd2,16'd2,16'd2,16'd2,16'd2,16'd2,16'd2,16'd2,16'd2,  16'd2,16'd2,16'd2,16'd2,16'd2,16'd2,16'd2,16'd2,16'd2,16'd2};//20低写入，30进行计算
    #160 data_in <= {16'd3,16'd3,16'd3,16'd3,16'd3,16'd3,16'd3,16'd3,16'd3,16'd3,  16'd3,16'd3,16'd3,16'd3,16'd3,16'd3,16'd3,16'd3,16'd3,16'd3};//40低写入，50进行计算j 

    #160 data_in <= {16'd4,16'd4,16'd4,16'd4,16'd4,16'd4,16'd4,16'd4,16'd4,16'd4,  16'd4,16'd4,16'd4,16'd4,16'd4,16'd4,16'd4,16'd4,16'd4,16'd4};//60低写入，70进行计算
    #160 data_in <= {16'd5,16'd5,16'd5,16'd5,16'd5,16'd5,16'd5,16'd5,16'd5,16'd5,  16'd5,16'd5,16'd5,16'd5,16'd5,16'd5,16'd5,16'd5,16'd5,16'd5};//80低写入，90进行计算
    #160 data_in <= {16'd6,16'd6,16'd6,16'd6,16'd6,16'd6,16'd6,16'd6,16'd6,16'd6,  16'd6,16'd6,16'd6,16'd6,16'd6,16'd6,16'd6,16'd6,16'd6,16'd6};//100低写入，110进行计算
    // #120 data_in <= {16'd7,16'd7,16'd7,16'd7,16'd7,16'd7,16'd7,16'd7,16'd7,16'd7,  16'd7,16'd7,16'd7,16'd7,16'd7,16'd7,16'd7,16'd7,16'd7,16'd7};//120低写入，130进行计算
end

top top_u1(
    .clk         (clk),
    .rst_n       (rst_n),
    .read_en     (read_en),
    .data_in     (data_in),
    .empty       (empty),
    .result      (result)    
);

initial begin
	$fsdbDumpfile("wave.fsdb");
	$fsdbDumpvars("+all");
end
initial begin
#1000000	$finish;
end

endmodule //top_tb