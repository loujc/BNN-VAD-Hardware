/*
testbench for top

只要使能、送数就可以
送6帧（6x20） result才可以输出
测一下使能的性能

*/

`timescale 1ns/1ps
module top_tb ();
reg                 clk        ;
                    rst_n      ;
                    read_en    ;
reg   [19:0]        data_in    ;
wire  [1:0]         result     ;

always #10 clk = ~clk;

initial begin
    clk     <= 0;
    rst_n   <= 0;
    read_en <= 0;
    data_in <= {1,1,1,1,1,1,1,1,1,1,  1,1,1,1,1,1,1,1,1,1};
    #20 read_en <= 1;
    #20 data_in <= {1,1,1,1,1,1,1,1,1,1,  1,1,1,1,1,1,1,1,1,1};//20低写入，30进行计算
    #40 data_in <= {1,1,1,1,1,1,1,1,1,1,  1,1,1,1,1,1,1,1,1,1};//40低写入，50进行计算
    #60 data_in <= {1,1,1,1,1,1,1,1,1,1,  1,1,1,1,1,1,1,1,1,1};//60低写入，70进行计算
    #80 data_in <= {1,1,1,1,1,1,1,1,1,1,  1,1,1,1,1,1,1,1,1,1};//80低写入，90进行计算
    #100 data_in <= {1,1,1,1,1,1,1,1,1,1,  1,1,1,1,1,1,1,1,1,1};//100低写入，110进行计算
    #120 data_in <= {1,1,1,1,1,1,1,1,1,1,  1,1,1,1,1,1,1,1,1,1};//120低写入，130进行计算
end

top top_u1(
    .clk         (clk),
    .rst_n       (rst_n),
    .read_en     (read_en),
    .data_in     (data_in),
    .result      (result)    
);

initial begin
//   $fsdbDumpvars();
//   $fsdbDumpMDA();
  $dumpvars();//无参数，表示设计中的所有信号都将被记录
  #10000 $finish;
end

endmodule //top_tb