/*
testbench for compare

3种可能性，1>2 1<2 1=2
相等时候输出10（实际上应该让它假阳），但实际上相等的可能性也太低了……


*/
`timescale 1ns/1ps
module compare_tb ();
reg             clk;
reg             rst_n;
reg             enable;
reg    [1:0]    compare_in;
wire            result;

always #10 clk = ~clk;

initial begin
    clk     <= 0;
    rst_n   <= 0;
    enable  <= 0;
    compare_in <= {10,20};      //10
    #20 compare_in <= {5,5};    //30
    #40 compare_in <= {10,-7};  //50
    enable  <= 1;
    #60 compare_in <= {10,20};  //70
    #80 compare_in <= {5,5};    //90
    #100 compare_in <= {10,-7}; //110
end

compare compare_tb_u1(
            .clk         (clk),
            .rst_n       (rst_n),
            .enable      (enable),
            .compare_in  (compare_in),
            .result      (result)    
);

initial begin
//   $fsdbDumpvars();
//   $fsdbDumpMDA();
  $dumpvars();//无参数，表示设计中的所有信号都将被记录
  #10000 $finish;
end


endmodule //compare_tb