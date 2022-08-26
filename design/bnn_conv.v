module bnn_conv (
    input   wire                 clk           ,
                                 rst_n         ,
    input   wire [15:0]          data_in[1:5]  , //输入的一帧数据 5 位

    output  reg signed  [31:0]   conv_out[1:3] , //卷积一次输入，每一位为一个kernel和一帧输入的运算结果
    output  wire                 conv_done       //conv整个（6帧，6x20）运算结束，目前应该没用到……
);

reg signed [15:0]    weight1[1:5]       ;
reg signed [15:0]    weight2[1:5]       ;
reg signed [15:0]    weight3[1:5]       ;
reg [5:0]            cnt = 5'b0         ;

//权重赋值，手动键入即可
weight1 = {1,-1,1,1,1};
weight2 = {1,-1,1,1,1};
weight3 = {1,-1,1,1,1};

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        conv_out  <= 3'b0;
    end
    else
    begin
        conv_out[3] <=      $signed(data_in[5]) * $signed(weight1[5])
                        +   $signed(data_in[4]) * $signed(weight1[4])
                        +   $signed(data_in[3]) * $signed(weight1[3])
                        +   $signed(data_in[2]) * $signed(weight1[2])
                        +   $signed(data_in[1]) * $signed(weight1[1]);

        conv_out[2] <=      $signed(data_in[5]) * $signed(weight2[5])
                        +   $signed(data_in[4]) * $signed(weight2[4])
                        +   $signed(data_in[3]) * $signed(weight2[3])
                        +   $signed(data_in[2]) * $signed(weight2[2])
                        +   $signed(data_in[1]) * $signed(weight2[1]);

        conv_out[1] <=      $signed(data_in[5]) * $signed(weight3[5])
                        +   $signed(data_in[4]) * $signed(weight3[4])
                        +   $signed(data_in[3]) * $signed(weight3[3])
                        +   $signed(data_in[2]) * $signed(weight3[2])
                        +   $signed(data_in[1]) * $signed(weight3[1]);
        cnt <= cnt + 5'b1;
    end
end

always@(posedge clk or negedge rst_n)begin
    if(!rst_n || (cnt == 5'd35))begin
        cnt  <= 5'b0;
    end
    else begin
        cnt  <= cnt;
    end
end

//输出
assign conv_done = (cnt == 5'd35)? 1 : 0;

endmodule //bnn_conv