module bnn_cfg (
    //common interface
    input   wire            clk             ,
                            rst_n           ,
                            vad_duration    ,

    //bnn interface
    output  reg [15:0]      conv_wt1[4:0]   ,
    output  reg [15:0]      conv_wt2[4:0]   ,
    output  reg [15:0]      conv_wt3[4:0]   ,
    output  reg [2:0]       fc_wt1[107:0]   ,
    output  reg [2:0]       fc_wt1[107:0]   ,

    output  reg             mfcc_wr_en      ,
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

wire apb_wr = psel && penable && pwrite; // apb = advanced peripheral bus
wire apb_rd = psel && penable && ~pwrite;
assign pready  = 1'b1;
assign pslverr = 1'b0;
localparam  CONV_WEIGHT1    =  13'h0xxx;
localparam  CONV_WEIGHT2    =  13'h10xx;
localparam  CONV_WEIGHT3    =  13'h110x;
localparam  FC_WEIGHT2      =  13'h111x;
localparam  FC_WEIGHT3      =  13'h112x;
localparam  MFCC_WR_EN_ADDR =  13'h113x;
localparam  RESULT_ADDR     =  13'h1200;

wire meet_conv_wt           = ((paddr[12] == 1'b0) || (paddr[12:8] == 5'h10) || (paddr[12:4] == 9'h110));
wire meet_fc_weight1        = (paddr[12:4] == 9'h111);
wire meet_fc_weight2        = (paddr[12:4] == 9'h112);
wire mfcc_wr_en_addr        = (paddr[12:4] == 9'h113);

//传weight给 bnn_conv 和 bnn_fc
always @(posedge pclk, negedge presetn) begin
    if(!presetn) begin
        conv_wt1 <= '{default: 5'h0};
        conv_wt2 <= '{default: 5'h0};
        conv_wt3 <= '{default: 5'h0};
    end
    else if(apb_wr && meet_conv_wt)    begin
        conv_wt1[4:0] <= pwdata[31:27]; 
        conv_wt2[4:0] <= pwdata[26:22];
        conv_wt3[4:0] <= pwdata[21:17];
    end
end

always @(posedge pclk, negedge presetn) begin
    if(!presetn) begin
        meet_fc_weight1 <= '{default: 108'h0};
    end
    else if(apb_wr && meet_fc_weight1)
       case(paddr[3:2])
            2'b00:fc_wt1[107:96] <= pwdata[31:20];
            2'b01:fc_wt1[95:64]  <= pwdata[31:0];
            2'b10:fc_wt1[63:32]  <= pwdata[31:0];
            2'b11:fc_wt1[31:0]   <= pwdata[31:0];
            default: fc_wt1      <= fc_wt1;
       endcase
end

always @(posedge pclk, negedge presetn) begin
    if(!presetn) begin
        meet_fc_weight2 <= '{default: 108'h0};
    end
    else if(apb_wr && meet_fc_weight1)
       case(paddr[3:2])
            2'b00:fc_wt2[107:96] <= pwdata[31:20];
            2'b01:fc_wt2[95:64]  <= pwdata[31:0];
            2'b10:fc_wt2[63:32]  <= pwdata[31:0];
            2'b11:fc_wt2[31:0]   <= pwdata[31:0];
            default: fc_wt2      <= fc_wt2;
       endcase
end

always @(posedge pclk,negedge presetn) begin
    if(!presetn) 
        mfcc_wr_en <= 0;
    else if(apb_wr && mfcc_wr_en_addr)
        mfcc_wr_en <= 1;
end

//读输出
always@(*) begin
   if(apb_rd) begin
        casex(paddr)

            MFCC_WR_EN_ADDR:    begin
                                    prdata[31] = vad_duration;
                                end

            RESULT_ADDR:        begin
                                    prdata[31:30] = result;
                                end

            default :               prdata = 32'h0;
            
        endcase
   end
   else
        prdata = 32'h0;
end

endmodule //bnn_cfg