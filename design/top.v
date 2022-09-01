module top (
    input   wire                clk                 ,
                                rst_n               ,
                                read_en             ,
    input   wire [15:0]         data_in[1:20]       ,
    output  wire                empty               ,//暂时加一个empty test用
    output  reg  [1:0]          result      
);
//fetchnum
// wire            empty;//一帧数据读完，与外部交互
wire [15:0]     data_one[1:5];
wire            fetchnum_vld;
//conv&binary
wire [31:0]     conv_out[1:3];
wire [1:0]      conv_out_binarized[1:3];
wire            conv_vld;
//mac
wire [9:0]      mac_out[1:2];
wire            mac_done;

//instance
//fetch number from 1 frame for 5 times
fetchnum fetchnum_inst(
                        .clk            (clk),
                        .rst_n          (rst_n),
                        .read_en        (read_en),
                        .data_in        (data_in),
                        .fetchnum_vld   (fetchnum_vld),
                        .data_one       (data_one),
                        .empty          (empty)              
);

//conv
bnn_conv bnn_conv_inst(
                        .clk             (clk),
                        .rst_n           (rst_n),
                        .data_in         (data_one),
                        .conv_en         (fetchnum_vld),
                        .conv_out        (conv_out),
                        .conv_vld        (conv_vld),
                        .conv_done       ()
);

//binarize
binary #(
                        .depth           (32),
                        .target_depth    (2),
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
                        .mac_en          (conv_vld),
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