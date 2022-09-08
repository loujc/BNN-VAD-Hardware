module binary #(
    parameter depth         = 32,
    parameter target_depth  = 2,
    parameter WIDTH         = 3
)
(
    input   reg signed     [depth-1:0]             data_raw[WIDTH-1:0]        ,
    output  reg signed     [target_depth-1:0]      data_binarized[WIDTH-1:0]
);

genvar cnt;
generate
    for (cnt = 0; cnt < WIDTH; cnt=cnt+1)
    begin: binaryLoop
        always @(*) begin
            if(data_raw[cnt] >= 'd0) begin
                data_binarized[cnt] <= 3'd1;
            end
            else begin
                data_binarized[cnt] <= -3'd1;
            end
        end
    end
endgenerate

endmodule //binary
