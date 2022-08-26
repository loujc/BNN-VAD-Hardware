module binary #(
    parameter WIDTH      = 3;
)
(
    input   wire    [WIDTH-1:0]      data_raw,
    output  reg     [WIDTH-1:0]      data_binarized
);

always @(*) begin
    for(count = 0; count <= WIDTH; count = count + 1)begin
        data_binarized[WIDTH] = (data_raw[WIDTH] == 0)? 0 :(data_raw[WIDTH] >= 1)? 1 : 0;
    end
end

endmodule //binary