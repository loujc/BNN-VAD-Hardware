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
reg     [1:0]   data_in[107:0];//用于存放数据
reg     [1:0]   mac_in[2:0];
wire    [1:0]   mac_out;
wire            mac_done;

always #10 clk = ~clk;
initial begin
    clk     <= 0;
    rst_n   <= 0;
    #2 rst_n   <= 1;
    data_in  <= {
        1,-1,1,1,1,1,   1,1,1,1,1,1,   1,1,1,1,1,1,   1,1,1,1,1,1,   1,1,1,1,1,1,   1,1,1,1,1,1,
        1, 1,1,1,1,1,   1,1,1,1,1,1,   1,1,1,1,1,1,   1,1,1,1,1,1,   1,1,1,1,1,1,   1,1,1,1,1,1,
        1, 1,1,1,1,1,   1,1,1,1,1,1,   1,1,1,1,1,1,   1,1,1,1,1,1,   1,1,1,1,1,1,   1,1,1,0,0,0
    };
end
genvar cnt;
generate
    for(cnt=107;cnt>=0;cnt=cnt-3)
    begin:cnt_weight_tb
      always @(negedge clk or negedge rst_n) begin
        if(!rst_n)begin
        data_in  <= {
            1,-1,1,1,1,1,   1,1,1,1,1,1,   1,1,1,1,1,1,   1,1,1,1,1,1,   1,1,1,1,1,1,   1,1,1,1,1,1,
            1, 1,1,1,1,1,   1,1,1,1,1,1,   1,1,1,1,1,1,   1,1,1,1,1,1,   1,1,1,1,1,1,   1,1,1,1,1,1,
            1, 1,1,1,1,1,   1,1,1,1,1,1,   1,1,1,1,1,1,   1,1,1,1,1,1,   1,1,1,1,1,1,   1,1,1,0,0,0
        };
        end
        else begin
            mac_in <= data_in[cnt:(cnt-2)];
        end
      end
      
    end
endgenerate


mac mac_u1(
        .clk          (clk),
        .rst_n        (rst_n),
        .mac_in       (mac_in),
        .mac_out      (mac_out),
        .mac_done     (mac_done)    
);

initial begin
	$fsdbDumpfile("wave.fsdb");
	$fsdbDumpvars("+all");
end
initial begin
#1000000	$finish;
end

endmodule //mac_tb