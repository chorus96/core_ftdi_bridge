`timescale 1ns/1ps  

module um232h_bfm
    import ftdi_pkg::*;
(
     output reg  ftdi_clk_o
    ,output reg  ftdi_rst_o
    ,output reg  ftdi_rxf_o
    ,output reg  ftdi_txe_o
    ,input  wire ftdi_siwua_i
    ,input  wire ftdi_wrn_i
    ,input  wire ftdi_rdn_i
    ,input  wire ftdi_oen_i  
    ,inout  wire [7:0] ftdi_data_io  
);

reg [7:0] ftdi_data_r; 
assign ftdi_data_io = ftdi_oen_i ? 8'hZZ : ftdi_data_r;

initial begin
    ftdi_clk_o = 0;
    ftdi_rst_o = 0;
    ftdi_rxf_o = 1;
    ftdi_txe_o = 1;
    forever #10ns ftdi_clk_o = ~ftdi_clk_o;
end 

task display_sig;
begin
    $display("ftdi_rxf_o:%h",ftdi_rxf_o);
    $display("ftdi_txe_o:%h",ftdi_txe_o);
    $display("ftdi_siwua_i:%h",ftdi_siwua_i);
    $display("ftdi_wrn_i:%h",ftdi_wrn_i);
    $display("ftdi_rdn_i:%h",ftdi_rdn_i);
    $display("ftdi_oen_i:%h",ftdi_oen_i);  
    $display("ftdi_data_io:%h",ftdi_data_io);  
end
endtask

task rst;
begin
    ftdi_rst_o = 1;
    #100ns;
    ftdi_rst_o = 0;
end
endtask

task send_nop;
begin
    // ftdi_txe_o = 1;
    // forever @(posedge ftdi_clk_o) begin
    //     if (ftdi_wrn_i == 1) begin
    //         ftdi_data_io = CMD_NOP;
    //         break;
    //     end
    // end    
    // ftdi_txe_o = 0;  
    @(negedge ftdi_clk_o);
    ftdi_rxf_o = 0;
    ftdi_data_r[`CMD_R] = CMD_NOP;
    wait(ftdi_rdn_i == 0);
    @(posedge ftdi_clk_o);
    ftdi_rxf_o = 1;  
end
endtask

endmodule