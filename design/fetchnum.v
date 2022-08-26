module fetchnum(
    input   wire        clk,
                        rst_n,
                        read_en,//外部读使能，使能时候，可以读入数据
    input   wire [15:0] data_in[1:20],

    output  reg [15:0] data_one[1:5],//取出(1x5)这样一帧数，通过移位寄存器实现
    output  wire         empty//传递给外部，目前一帧（1x20）运算结束，请求输入下一帧
);

reg [2 :0]  cnt;
reg status;//0表示空了，可以接受数据

assign empty	=	!status;//1表示空了
;
reg [15:0]  data_temp[1:20]
//暂存


always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		cnt	<=	1;
		status	<=	0;
	end
	else begin
		if(read_en&&!status)begin//read in
			data_temp	<=	data_in;
			status		<=	1;			
		end
		else if(status) begin//output
			if(cnt<=5)begin//1 to 5
				data_one	<=	data_temp[(3*cnt-2)+:5];
				cnt		<=	cnt + 1;
			end 
			else begin//6
				data_one        <=      data_temp[16:20];
				status		<=	0;
				cnt		<=	1;
			
			end
		end
		
	end
end

endmodule //fetchnum
