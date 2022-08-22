module mac (
    input   wire                clk     ,
                                rst_n   ,
    input   wire [2:0]          mac_in ,

    output  reg signed  [1:0]   mac_out,
    output  reg                 mac_done
);

//后续需要手动键入weight值，不知道是否有更好方案……
reg signed [107:0] fc_weight1;
reg signed [107:0] fc_weight2;
assign fc_weight1 = {};//填入weight
assign fc_weight2 = {};//填入weight

reg signed temp1 = 0,temp2 = 0;

reg [5:0] cnt;


always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        temp_result <= 0;
        temp1   <= 0;
        temp2   <= 0;
        cnt     <= 0;
    end
    else begin //每次都是这几位，然后通过移位进行转换权重
        temp1 <=    mac_in[2] * fc_weight1[107]
                +   mac_in[1] * fc_weight1[71]
                +   mac_in[0] * fc_weight1[35]
                +   temp1;
        temp2 <=    mac_in[2] * fc_weight2[107]
                +   mac_in[1] * fc_weight2[71]
                +   mac_in[0] * fc_weight2[35]
                +   temp2;
        cnt <= cnt + 5'b1;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        fc_weight1 <= {};//填入weight
        fc_weight2 <= {};//填入weight
    end
    else begin
        fc_weight1 <= fc_weight1 << 1;
        fc_weight2 <= fc_weight2 << 1;
    end
end


assign cnt = (cnt == 5'd35)? 5'b0 : cnt;


//输出
assign mac_out  = {temp1,temp2}         ;
assign mac_done = (cnt == 5'd35)? 1 : 0 ;


endmodule //mac