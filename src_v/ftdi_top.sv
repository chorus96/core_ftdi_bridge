`timescale 1ns/1ps  

module ftdi_top(
     input  ftdi_clk_i
    ,input  ftdi_rst_i
    ,input  ftdi_rxf_i
    ,input  ftdi_txe_i
    ,output ftdi_siwua_o
    ,output ftdi_wrn_o
    ,output ftdi_rdn_o
    ,output ftdi_oen_o  
    ,inout  [7:0] ftdi_data_io  
);

wire [7:0] ftdi_data_in_w;
wire [7:0] ftdi_data_out_w;
wire [31:0] gpio1_w;
wire [31:0] gpio2_w;

wire           awready_w;
wire           wready_w;
wire           bvalid_w;
wire  [  1:0]  bresp_w;
wire  [  3:0]  bid_w;
wire           arready_w;
wire           rvalid_w;
wire  [ 31:0]  rdata_w;
wire  [  1:0]  rresp_w;
wire  [  3:0]  rid_w;
wire           rlast_w;
wire           awvalid_w;
wire  [ 31:0]  awaddr_w;
wire  [  3:0]  awid_w;
wire  [  7:0]  awlen_w;
wire  [  1:0]  awburst_w;
wire           wvalid_w;
wire  [ 31:0]  wdata_w;
wire  [  3:0]  wstrb_w;
wire           wlast_w;
wire           bready_w;
wire           arvalid_w;
wire  [ 31:0]  araddr_w;
wire  [  3:0]  arid_w;
wire  [  7:0]  arlen_w;
wire  [  1:0]  arburst_w;
wire           rready_w;

ftdi_bridge u_bridge
(
     .clk_i(ftdi_clk_i)
    ,.rst_i(ftdi_rst_i)

    ,.mem_awready_i(awready_w)
    ,.mem_wready_i(wready_w)
    ,.mem_bvalid_i(bvalid_w)
    ,.mem_bresp_i(bresp_w)
    ,.mem_bid_i(bid_w)
    ,.mem_arready_i(arready_w)
    ,.mem_rvalid_i(rvalid_w)
    ,.mem_rdata_i(rdata_w)
    ,.mem_rresp_i(rresp_w)
    ,.mem_rid_i(rid_w)
    ,.mem_rlast_i(rlast_w)
    ,.mem_awvalid_o(awvalid_w)
    ,.mem_awaddr_o(awaddr_w)
    ,.mem_awid_o(awid_w)
    ,.mem_awlen_o(awlen_w)
    ,.mem_awburst_o(awburst_w)
    ,.mem_wvalid_o(wvalid_w)
    ,.mem_wdata_o(wdata_w)
    ,.mem_wstrb_o(wstrb_w)
    ,.mem_wlast_o(wlast_w)
    ,.mem_bready_o(bready_w)
    ,.mem_arvalid_o(arvalid_w)
    ,.mem_araddr_o(araddr_w)
    ,.mem_arid_o(arid_w)
    ,.mem_arlen_o(arlen_w)
    ,.mem_arburst_o(arburst_w)
    ,.mem_rready_o(rready_w)

    ,.ftdi_rxf_i(ftdi_rxf_i)
    ,.ftdi_txe_i(ftdi_txe_i)
    ,.ftdi_data_in_i(ftdi_data_in_w)
    ,.ftdi_siwua_o(ftdi_siwua_o)
    ,.ftdi_wrn_o(ftdi_wrn_o)
    ,.ftdi_rdn_o(ftdi_rdn_o)
    ,.ftdi_oen_o(ftdi_oen_o)
    ,.ftdi_data_out_o(ftdi_data_out_w)

    ,.gp_outputs_o(gpio1_w)
    ,.gp_inputs_i(gpio2_w)
);

assign ftdi_data_in_w = ftdi_data_io;
assign ftdi_data_io   = ftdi_oen_o ? ftdi_data_out_w : 8'hZZ;

gpio_bfm u_gpio_bfm
(
     .clk_i(ftdi_clk_i)
    ,.rst_i(ftdi_rst_i)
    ,.gpio_i(gpio1_w)
    ,.gpio_o(gpio2_w) // Unused
);

axi_bfm u_axi_bfm
(
     .clk_i(ftdi_clk_i)
    ,.rst_i(ftdi_rst_i)
    ,.slv_awvalid_i(awvalid_w)
    ,.slv_awaddr_i(awaddr_w)
    ,.slv_awid_i(awid_w)
    ,.slv_awlen_i(awlen_w)
    ,.slv_awburst_i(awburst_w)
    ,.slv_wvalid_i(wvalid_w)
    ,.slv_wdata_i(wdata_w)
    ,.slv_wstrb_i(wstrb_w)
    ,.slv_wlast_i(wlast_w)
    ,.slv_bready_i(bready_w)
    ,.slv_arvalid_i(arvalid_w)
    ,.slv_araddr_i(araddr_w)
    ,.slv_arid_i(arid_w)
    ,.slv_arlen_i(arlen_w)
    ,.slv_arburst_i(arburst_w)
    ,.slv_rready_i(rready_w)
    ,.slv_awready_o(awready_w)
    ,.slv_wready_o(wready_w)
    ,.slv_bvalid_o(bvalid_w)
    ,.slv_bresp_o(bresp_w)
    ,.slv_bid_o(bid_w)
    ,.slv_arready_o(arready_w)
    ,.slv_rvalid_o(rvalid_w)
    ,.slv_rdata_o(rdata_w)
    ,.slv_rresp_o(rresp_w)
    ,.slv_rid_o(rid_w)
    ,.slv_rlast_o(rlast_w)
);

endmodule