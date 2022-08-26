module fetchnum_tb;

reg		clk;
reg		rst_n;
reg		read_en;

reg	[15:0]	data_in[1:20];

wire	[15:0]	data_one[1:5];
wire		empty;

fetchnum fetchnum_u(
	.clk(clk),
	.rst_n(rst_n),
	.read_en(read_en),
	.data_in(data_in),

	.data_one(data_one),
	.empty(empty)
);

always #5 clk = !clk;

initial begin
	$fsdbDumpfile("wave.fsdb");
	$fsdbDumpvars("+all");
end
initial begin
	clk	<=	0;
	rst_n	<=	0;
	read_en	<=	0;

#10	rst_n	<=	1;
#10	read_en	<=	1;
#100	read_en	<=	0;

#1000	$finish;
end

initial begin
	data_in	<=	{1, 2, 3, 4, 5, 
			 6, 7, 8, 9, 10, 
			 11, 12, 13, 14, 15, 
			16, 17, 18, 19, 20 };
end


endmodule 
