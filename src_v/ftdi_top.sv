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

ftdi_bridge
#(
	.MODE("SYNC")
)
u_bridge
(
     .clk_i(ftdi_clk_i)
    ,.rst_i(ftdi_rst_i)

    // ,.mem_awvalid_o(...)
    // ,.mem_awaddr_o(...)
    // ,.mem_awid_o(...)
    // ,.mem_awlen_o(...)
    // ,.mem_awburst_o(...)
    // ,.mem_wvalid_o(...)
    // ,.mem_wdata_o(...)
    // ,.mem_wstrb_o(...)
    // ,.mem_wlast_o(...)
    // ,.mem_bready_o(...)
    // ,.mem_arvalid_o(...)
    // ,.mem_araddr_o(...)
    // ,.mem_arid_o(...)
    // ,.mem_arlen_o(...)
    // ,.mem_arburst_o(...)
    // ,.mem_rready_o(...)    
    // ,.mem_awready_i(...)
    // ,.mem_wready_i(...)
    // ,.mem_bvalid_i(...)
    // ,.mem_bresp_i(...)
    // ,.mem_bid_i(...)
    // ,.mem_arready_i(...)
    // ,.mem_rvalid_i(...)
    // ,.mem_rdata_i(...)
    // ,.mem_rresp_i(...)
    // ,.mem_rid_i(...)
    // ,.mem_rlast_i(...)

    ,.ftdi_rxf_i(ftdi_rxf_i)
    ,.ftdi_txe_i(ftdi_txe_i)
    ,.ftdi_data_in_i(ftdi_data_in_w)
    ,.ftdi_siwua_o(ftdi_siwua_o)
    ,.ftdi_wrn_o(ftdi_wrn_o)
    ,.ftdi_rdn_o(ftdi_rdn_o)
    ,.ftdi_oen_o(ftdi_oen_o)
    ,.ftdi_data_out_o(ftdi_data_out_w)

);

assign ftdi_data_in_w = ftdi_data_io;
assign ftdi_data_io   = ftdi_oen_o ? ftdi_data_out_w : 8'hZZ;

endmodule