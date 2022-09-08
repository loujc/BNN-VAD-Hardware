module binary_tb();

reg	signed [31:0]	data_raw[2:0];
reg	signed [1:0]	data_binarized[2:0];

binary #(
	.WIDTH(3)
)
binary_tb
(
	.data_raw(data_raw),
	.data_binarized(data_binarized)
);

initial begin
	$fsdbDumpfile("wave.fsdb");
	$fsdbDumpvars("+all");
end
initial begin
#1000000	$finish;
end

initial begin
	data_raw	<=	{1, -1, 3};
	#100 data_raw <= {10, 20 ,-20};
end


endmodule 
