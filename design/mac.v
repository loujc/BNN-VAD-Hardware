module mac (
    input   wire                clk     ,
                                rst_n   ,
    input   wire [1:0]          mac_in[1:3] ,

    output  reg signed  [3:0]   mac_out[1:2],
    output  reg                 mac_done
);

//后续需要手动键入weight值，不知道是否有更好方案……
reg signed [2:0] fc_weight1[107:0];
reg signed [2:0] fc_weight2[107:0];

//计算
genvar cnt;
generate
    for(cnt = 0; cnt <= 36; cnt = cnt+1)
    begin:cnt_weight
      always @(posedge clk or negedge rst_n) begin
        if(!rst_n)begin
            mac_done    <= 0;
            fc_weight1  <= {
                1,-1,1,-1,1,-1,   1,-1,1,-1,1,-1,   1,-1,1,-1,1,-1,   1,-1,1,-1,1,-1,   1,-1,1,-1,1,-1,   1,-1,1,-1,1,-2,   1,-1,1,-1,1,-1,   1,-1,1,-1,1,-1,   1,-1,1,-1,1,-1,
                1,-1,1,-1,1,-1,   1,-1,1,-1,1,-1,   1,-1,1,-1,1,-2,   1,-1,1,-1,1,-1,   1,-1,1,-1,1,-1,   1,-1,1,-1,1,-1,   1,-1,1,-1,1,-1,   1,-1,1,-1,1,-1,   1,-1,1,-1,1,-2
            };//填入weight
            fc_weight2  <= {
                1,-1,1,-1,1,-1,   1,-1,1,-1,1,-1,   1,-1,1,-1,1,-1,   1,-1,1,-1,1,-1,   1,-1,1,-1,1,-1,   1,-1,1,-1,1,-3,   1,-1,1,-1,1,-1,   1,-1,1,-1,1,-1,   1,-1,1,-1,1,-1,
                1,-1,1,-1,1,-1,   1,-1,1,-1,1,-1,   1,-1,1,-1,1,-3,   1,-1,1,-1,1,-1,   1,-1,1,-1,1,-1,   1,-1,1,-1,1,-1,   1,-1,1,-1,1,-1,   1,-1,1,-1,1,-1,   1,-1,1,-1,1,-3
            };//填入weight
        end
        else if(cnt == 36) begin
            mac_done <= 1;  //写mac_done逻辑
        end
        else if(cnt < 36)begin
            mac_out[2] <=   mac_in[3] * fc_weight1[107-cnt]
                        +   mac_in[2] * fc_weight1[71-cnt]
                        +   mac_in[1] * fc_weight1[35-cnt]
                        +   mac_out[1];

            mac_out[1] <=   mac_in[3] * fc_weight2[107-cnt]
                        +   mac_in[2] * fc_weight2[71-cnt]
                        +   mac_in[1] * fc_weight2[35-cnt]
                        +   mac_out[0];
            mac_done   <= 0;
        end
        else begin
            mac_out <= mac_out;
        end
      end
    
    end
endgenerate


endmodule //mac