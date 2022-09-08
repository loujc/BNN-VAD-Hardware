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
reg    signed [3:0]    compare_in[1:0];
wire   [1:0]    result;

always #5 clk = ~clk;

initial begin
    clk     <= 0;
    rst_n   <= 0;
    #5 rst_n <= 1;
    enable  <= 0;
    compare_in <= {10,16};      //10
    #20 compare_in <= {5,5};    //30
    #40 compare_in <= {10,-7};  //50
    #50 enable  <= 1;
    #60 compare_in <= {5,10};  //70
    #80 compare_in <= {5,5};    //90
    #100 compare_in <= {5,-7}; //110
    #300 $finish;
end

compare compare_tb_u1(
            .clk         (clk),
            .rst_n       (rst_n),
            .enable      (enable),
            .compare_in  (compare_in),
            .result      (result)    
);

initial begin
	$fsdbDumpfile("wave.fsdb");
	$fsdbDumpvars("+all");
end


endmodule //compare_tb