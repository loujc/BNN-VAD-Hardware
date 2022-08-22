module compare (
    input   wire                clk         ,
                                rst_n       ,
                                enable      ,
    input   wire [1:0]          compare_in  ,

    output reg  [1:0]           result
);

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        result <= 2'b00;
    end
    else begin
        if((compare_in[1]>compare_in[0]) || enable)begin
            result <= 2'b10;//2
        end
        else if((compare_in[1]>compare_in[0]) || enable)begin
            result <= 2'b01;//1
            end
        else begin
            result <= result;
        end
    end
end

endmodule //compare