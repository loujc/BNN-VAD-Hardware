module fetchnum(
    input   wire        clk,
                        rst_n,
                        read_en,//外部读使能，使能时候，可以读入数据
    input   wire [19:0] data_in,

    output  reg [4 :0]  data_one,//取出(1x5)这样一帧数，通过移位寄存器实现
    output  reg         empty//传递给外部，目前一帧（1x20）运算结束，请求输入下一帧
);

reg [19:0]  data        ;
reg [2 :0]  cnt = 3'b1  ;
reg status = 1'b0;

assign data_one = data[19:15];
assign cnt = (cnt == 3'd6)? 3'b1:cnt;
assign status = (cnt == 3'd6) 1:0;
assign empty = status;
assign data = (read_en || empty)? data_in:data;


//移位送值
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        data <= 20'b0;
        cnt  <=  3'b1;
    end
    else
    begin
        data <= data << 3;
        cnt += 1'b1;
    end
end

endmodule //fetchnum