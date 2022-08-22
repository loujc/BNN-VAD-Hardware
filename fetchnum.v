module fetchnum(
    input   wire        clk,
                        rst_n,
                        read_en,
    input   wire [19:0] data_in,

    output  reg [4 :0]  data_one,
    output  reg         empty
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