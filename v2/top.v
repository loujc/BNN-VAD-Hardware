module top (
    input   wire            clk             ,
                            rst_n           ,
    input   wire [15:0]     mfcc_data[4:0]  ,

    output  reg             vad_duration    ,
    output  reg [1:0]       result          ,

    //APB interface
    input   wire            pclk,
    input   wire            presetn,
    input   wire [12:0]     paddr,
    input   wire            pwrite,
    input   wire            psel,
    input   wire            penable,
    input   wire [31:0]     pwdata,

    output  reg  [31:0]     prdata,
    output  wire            pready,
    output  wire            pslverr  
);

//bnn interface
wire [15:0]      conv_wt1[4:0]   ;
wire [15:0]      conv_wt2[4:0]   ;
wire [15:0]      conv_wt3[4:0]   ;
wire [2:0]       fc_wt1[107:0]   ;
wire [2:0]       fc_wt1[107]     ;
wire             mfcc_wr_en_wire ;
wire             result          ;
wire             vad_duration    ;

bnn_cfg bnn_cfg_inst(
                    .clk                (clk),
                    .rst_n              (rst_n),
                    .vad_duration       (vad_duration),
                    .conv_wt1           (conv_wt1),
                    .conv_wt2           (conv_wt2),
                    .conv_wt3           (conv_wt3),
                    .fc_wt1             (fc_wt1),
                    .fc_wt1             (fc_wt2),
                    .mfcc_wr_en         (mfcc_wr_en_wire),
                    .result             (result),
                    .pclk               (pclk),
                    .presetn            (presetn),
                    .paddr              (paddr),
                    .pwrite             (pwrite),
                    .psel               (psel),
                    .penable            (penable),
                    .pwdata             (pwdata),
                    .prdata             (prdata),
                    .pready             (pready),
                    .pslverr            (pslverr)
);

bnn bnn_inst(
                    .clk                (clk),
                    .rst_n              (rst_n),
                    .mfcc_wr_en         (mfcc_wr_en_wire),
                    .mfcc_data[4:0]     (mfcc_data),
                    .conv_wt1[4:0]      (conv_wt1),
                    .conv_wt2[4:0]      (conv_wt2),
                    .conv_wt3[4:0]      (conv_wt3),
                    .fc_wt1[107:0]      (fc_wt1),
                    .fc_wt2[107:0]      (fc_wt2),
                    .result             (result),
                    .vad_duration       (vad_duration)
);


endmodule //top