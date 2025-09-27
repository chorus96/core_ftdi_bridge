`timescale 1ns/1ps  

module um232h_bfm
    import ftdi_pkg::*;
(
     output reg  ftdi_clk_o
    ,output reg  ftdi_rst_o
    ,output ftdi_rxf_o
    ,output ftdi_txe_o
    ,input  ftdi_siwua_i
    ,input  ftdi_wrn_i
    ,input  ftdi_rdn_i
    ,input  ftdi_oen_i  
    ,inout  [7:0] ftdi_data_io  
);

initial begin
    ftdi_clk_o = 0;
    ftdi_rst_o = 0;
    forever begin
        #10ns ftdi_clk_o = ~ftdi_clk_o;
    end
end 

task rst;
begin
    ftdi_rst_o = 1;
    #100ns;
    ftdi_rst_o = 0;
end
endtask

endmodule