/*
testbench for MAC

每次3位数进去，权重设置比较特殊，最后求和结果：
temp1应该为第一组3个数的-2倍，temp2应该是第一组数的-3倍
移位送入
看最后输出结果和mac_done是否置位

*/
`timescale 1ns/1ps
module mac_tb ();
reg             clk;
reg             rst_n;
reg     [107:0] data_in;//用于存放数据
reg     [2:0]   mac_in;
wire    [1:0]   mac_out;
wire            mac_done;
reg             status; //用于检测rst_n的状态

always #10 clk = ~clk;
initial begin
    clk     <= 0;
    rst_n   <= 0;
    data_in  <= {
        2,-2,2,1,1,1,   1,1,1,1,1,1,   1,1,1,1,1,1,   1,1,1,1,1,1,   1,1,1,1,1,1,   1,1,1,1,1,1,
        1, 1,1,1,1,1,   1,1,1,1,1,1,   1,1,1,1,1,1,   1,1,1,1,1,1,   1,1,1,1,1,1,   1,1,1,1,1,1,
        1, 1,1,1,1,1,   1,1,1,1,1,1,   1,1,1,1,1,1,   1,1,1,1,1,1,   1,1,1,1,1,1,   1,1,1,0,0,0
    };
end

always @(posedge clk or negedge rst_n or posedge mac_done) begin
    if(!rst_n || mac_done)begin
        data_in  <= {
            2,-2,2,1,1,1,   1,1,1,1,1,1,   1,1,1,1,1,1,   1,1,1,1,1,1,   1,1,1,1,1,1,   1,1,1,1,1,1,
            1, 1,1,1,1,1,   1,1,1,1,1,1,   1,1,1,1,1,1,   1,1,1,1,1,1,   1,1,1,1,1,1,   1,1,1,1,1,1,
            1, 1,1,1,1,1,   1,1,1,1,1,1,   1,1,1,1,1,1,   1,1,1,1,1,1,   1,1,1,1,1,1,   1,1,1,0,0,0
        };
        status <= 1'b1;
    end
    else begin
        status <= 1'b0;
        data_in <= data_in << 3;
        mac_in <= data_in[107:105];
    end
end

mac mac_u1(
        .clk          (clk),
        .rst_n        (rst_n),
        .mac_in       (mac_in),
        .mac_out      (mac_out),
        .mac_done     (mac_done)    
);

initial begin
//   $fsdbDumpvars();
//   $fsdbDumpMDA();
  $dumpvars();//无参数，表示设计中的所有信号都将被记录
  #10000 $finish;
end

endmodule //mac_tb