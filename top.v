module top (
    input   wire                clk         ,
                                rst_n       ,
                                read_en     ,
    input   wire [19:0]         data_in     ,
    output  reg[1:0]            result      
);
//fetchnum
wire            empty;//一帧数据读完，与外部交互
wire [4:0]      data_one;
//conv&binary
wire [2:0]      conv_out,conv_out_binarized;
//mac
wire [1:0]      mac_out;
wire            mac_done;

//instance
//fetch number from 1 frame for 5 times
fetchnum fetchnum_inst(
                        .clk            (clk),
                        .rst_n          (rst_n),
                        .read_en        (read_en),
                        .data_in        (data_in),
                        .data_one       (data_one),
                        .empty          (empty)              
);

//conv
bnn_conv bnn_conv_inst(
                        .clk             (clk),
                        .rst_n           (rst_n),
                        .data_in         (data_one),
                        .conv_out        (conv_out),
                        .conv_done       ()
);

//binarize
binary #(
                        .WIDTH           (3)
)
binary_inst(
                        .data_raw        (conv_out),
                        .data_binarized  (conv_out_binarized)
);

//MAC
mac mac_inst(
                        .clk             (clk),
                        .rst_n           (rst_n),
                        .mac_in          (conv_out_binarized),
                        .mac_out         (mac_out),
                        .mac_done        (mac_done)
);

//Compare 2 classifier result
compare compare_inst(
                        .clk             (clk),
                        .rst_n           (rst_n),
                        .enable          (mac_done),
                        .compare_in      (mac_out),
                        .result          (result)

);

endmodule //top