module bnn_conv (
    input   wire                clk     ,
                                rst_n   ,
    input   wire [4:0]          data_in ,//输入的一帧数据 5 位

    output  reg signed  [2:0]   conv_out,//卷积一次输入，每一位为一个kernel和一帧输入的运算结果
    output  reg                 conv_done//conv整个（6帧，6x20）运算结束，目前应该没用到……
);

reg signed [4:0]    weight1     ;
reg signed [4:0]    weight2     ;
reg signed [4:0]    weight3     ;
reg signed [2:0]    result      ;
reg [5:0]           cnt = 5'b0  ;

//权重赋值，手动键入即可
assign weight1 = {1,-1,1,1,1};
assign weight2 = {1,-1,1,1,1};
assign weight3 = {1,-1,1,1,1};

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        result  <= 3'b0;
        cnt     <= 5'b0;
    end
    else
    begin
        result[2] <=    $signed(data_in[4]) * $signed(weight1[4])
                    +   $signed(data_in[3]) * $signed(weight1[3])
                    +   $signed(data_in[2]) * $signed(weight1[2])
                    +   $signed(data_in[1]) * $signed(weight1[1])
                    +   $signed(data_in[0]) * $signed(weight1[0]);

        result[1] <=    $signed(data_in[4]) * $signed(weight2[4])
                    +   $signed(data_in[3]) * $signed(weight2[3])
                    +   $signed(data_in[2]) * $signed(weight2[2])
                    +   $signed(data_in[1]) * $signed(weight2[1])
                    +   $signed(data_in[0]) * $signed(weight2[0]);

        result[0] <=    $signed(data_in[4]) * $signed(weight3[4])
                    +   $signed(data_in[3]) * $signed(weight3[3])
                    +   $signed(data_in[2]) * $signed(weight3[2])
                    +   $signed(data_in[1]) * $signed(weight3[1])
                    +   $signed(data_in[0]) * $signed(weight3[0]);
        cnt <= cnt + 5'b1;
    end
end

assign cnt = (cnt == 5'd35)? 5'b0 : cnt;

//输出
assign conv_out = result;
assign conv_done = (cnt == 5'd35)? 1 : 0;

endmodule //bnn_conv