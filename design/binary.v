module binary #(
    parameter depth         = 32;
    parameter target_depth  = 2;
    parameter WIDTH         = 3;
)
(
    input   wire    [depth-1:0]             data_raw[WIDTH-1:0]        ,
    output  reg     [target_depth-1:0]      data_binarized[WIDTH-1:0]
);

always @(*) begin
    for(count = 0; count <= WIDTH; count = count + 1)begin
        data_binarized[WIDTH] = (data_raw[WIDTH] >= 0)? 1 : -1;
    end
end

endmodule //binary