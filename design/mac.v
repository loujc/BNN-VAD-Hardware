module mac (
    input   wire                clk     ,
                                rst_n   ,
    input   wire [1:0]          mac_in[1:3] ,//2:0
    input   wire                mac_en      ,

    output  reg signed  [9:0]   mac_out[1:2],//1:0
    output  wire                mac_done
);

//后续需要手动键入weight值，不知道是否有更好方案……
reg signed [2:0] fc_weight1[107:0];//3'b1
reg signed [2:0] fc_weight2[107:0];//
reg [5:0] count_reg;
//计算

genvar i;
generate
    for(i=0;i<=107;i=i+1)
    begin:gen_weight
    always @(posedge clk or negedge rst_n) begin
        fc_weight1[i] <= {3'd1};
        fc_weight2[i] <= {3'd0};
    end
    end
endgenerate


always @(posedge clk or negedge rst_n) begin
    if((!rst_n) || (count_reg == 36)) begin
        count_reg <= 0;
        mac_out <= {2'd0,2'd0};
    end
    else if((count_reg <= 35) && (mac_en)) begin
        mac_out[2] <=   mac_in[3] * fc_weight2[107-count_reg]
                    +   mac_in[2] * fc_weight2[71-count_reg]
                    +   mac_in[1] * fc_weight2[35-count_reg] + mac_out[2];

        mac_out[1] <=     mac_in[3] * fc_weight1[107-count_reg]
                    +     mac_in[2] * fc_weight1[71-count_reg]
                    +     mac_in[1] * fc_weight1[35-count_reg] + mac_out[1];
        count_reg <= count_reg + 1;
    end
end


assign mac_done = (count_reg == 36)? 1 : 0; // TODO 是否需要打一拍

endmodule //mac