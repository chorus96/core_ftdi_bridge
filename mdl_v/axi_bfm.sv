`timescale 1ns/1ps  

module axi_bfm
    import ftdi_pkg::*;
(
     input            clk_i
    ,input            rst_i

    ,input            slv_awvalid_i
    ,input   [ 31:0]  slv_awaddr_i
    ,input   [  3:0]  slv_awid_i
    ,input   [  7:0]  slv_awlen_i
    ,input   [  1:0]  slv_awburst_i
    ,input            slv_wvalid_i
    ,input   [ 31:0]  slv_wdata_i
    ,input   [  3:0]  slv_wstrb_i
    ,input            slv_wlast_i
    ,input            slv_bready_i
    ,input            slv_arvalid_i
    ,input   [ 31:0]  slv_araddr_i
    ,input   [  3:0]  slv_arid_i
    ,input   [  7:0]  slv_arlen_i
    ,input   [  1:0]  slv_arburst_i
    ,input            slv_rready_i

    ,output           slv_awready_o
    ,output           slv_wready_o
    ,output           slv_bvalid_o
    ,output  [  1:0]  slv_bresp_o
    ,output  [  3:0]  slv_bid_o
    ,output           slv_arready_o
    ,output           slv_rvalid_o
    ,output  [ 31:0]  slv_rdata_o
    ,output  [  1:0]  slv_rresp_o
    ,output  [  3:0]  slv_rid_o
    ,output           slv_rlast_o
);



endmodule