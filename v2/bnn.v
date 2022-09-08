module bnn (
    input   wire        clk             ,
                        rst_n           ,
                        mfcc_wr_en      ,
    input   wire [15:0] mfcc_data[4:0]  ,
    input   wire [15:0] conv_wt1[4:0]   ,
                        conv_wt2[4:0]   ,
                        conv_wt3[4:0]
    input   wire [2:0]  fc_wt1[107:0]   ,
                        fc_wt2[107:0]   ,

    output  reg [1:0]   result               
);

//相关中间变量声明
reg     [5:0]       count               ;
wire    [31:0]      conv_out[2:0]       ;
wire    [2:0]       binary_out[2:0]     ;
wire    [9:0]       mac_out[1:0]        ;
reg     [9:0]       temp_result[1:0]    ;

wire                compare_en          ;


//组合逻辑计算
always @(*) begin
//conv
conv_out[2]     =   $signed(mfcc_data[4]) * $signed(conv_wt3[4])
                +   $signed(mfcc_data[3]) * $signed(conv_wt3[3])
                +   $signed(mfcc_data[2]) * $signed(conv_wt3[2])
                +   $signed(mfcc_data[1]) * $signed(conv_wt3[1])
                +   $signed(mfcc_data[0]) * $signed(conv_wt3[0]);

conv_out[1]     =   $signed(mfcc_data[4]) * $signed(conv_wt2[4])
                +   $signed(mfcc_data[3]) * $signed(conv_wt2[3])
                +   $signed(mfcc_data[2]) * $signed(conv_wt2[2])
                +   $signed(mfcc_data[1]) * $signed(conv_wt2[1])
                +   $signed(mfcc_data[0]) * $signed(conv_wt2[0]);

conv_out[0]     =   $signed(mfcc_data[4]) * $signed(conv_wt1[4])
                +   $signed(mfcc_data[3]) * $signed(conv_wt1[3])
                +   $signed(mfcc_data[2]) * $signed(conv_wt1[2])
                +   $signed(mfcc_data[1]) * $signed(conv_wt1[1])
                +   $signed(mfcc_data[0]) * $signed(conv_wt1[0]);

//binary
binary_out[2]   =   (conv_out[2] >= 32'd0)? 3'd1 : -3'd1;
binary_out[1]   =   (conv_out[1] >= 32'd0)? 3'd1 : -3'd1;
binary_out[0]   =   (conv_out[0] >= 32'd0)? 3'd1 : -3'd1;

//mac
mac_out[1]      =   binary_out[3] * fc_wt2[107-count]
                +   binary_out[2] * fc_wt2[71-count]
                +   binary_out[1] * fc_wt2[35-count] + mac_out[2];

mac_out[0]      =   binary_out[3] * fc_wt1[107-count]
                +   binary_out[2] * fc_wt1[71-count]
                +   binary_out[1] * fc_wt1[35-count] + mac_out[1];
//compare
temp_result     =   (mac_out[1] >= mac_out[2])? 2'b10 : 2'b01    ;

end



//时序逻辑数据流动

//dataflow 
//TODO: 1. 输入enable 这边的逻辑（感觉不需要enable……我一个周期能算完1x5） 
//TODO: 2.输出是否有其他的信号？（把一些需要探测的值、送一些完成信号出去？）
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        result <= 2'b00;
    end
    else if(compare_en) begin
        result <= temp_result;
    end
    else begin
        result <= result;
    end
end

//count
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        count       <= 6'd0;
        compare_en  <= 1'b0;
    end
    else if(count == 36)begin
        count       <= 6'd0;
        compare_en  <= 1'b1;
    end
    else begin
        count       <= count + 6'd1;
        compare_en  <= 1'b0;
    end
end




endmodule //bnn