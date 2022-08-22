module compare (
    input   wire                clk         ,
                                rst_n       ,
                                enable      ,//使能比较，即前面运算部分全部结束
    input   wire [1:0]          compare_in  ,//输入1x2数据

    output reg  [1:0]           result      //输出分类结果，10为1类别，01为2类别，00为无结果
);

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        result <= 2'b00;
    end
    else begin
        if((compare_in[1]>compare_in[0]) || enable)begin
            result <= 2'b10;//1类别
        end
        else if((compare_in[1]>compare_in[0]) || enable)begin
            result <= 2'b01;//2类别
            end
        else begin
            result <= result;
        end
    end
end

endmodule //compare