module binary #(
    parameter depth         = 32,
    parameter target_depth  = 2,
    parameter WIDTH         = 3
)
(
    input   reg     [depth-1:0]             data_raw[WIDTH-1:0]        ,
    output  reg     [target_depth-1:0]      data_binarized[WIDTH-1:0]
);

genvar cnt;
generate
    for (cnt = 0; cnt < WIDTH; cnt=cnt+1)
    begin: binaryLoop
        always @(*) begin
            if(data_raw[cnt] >= 'b0) begin
                data_binarized[cnt] = 1;
            end
            else begin
                data_binarized[cnt] = -1;
            end
        end
    end
endgenerate

endmodule //binary
