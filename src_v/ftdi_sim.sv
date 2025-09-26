`timescale 1ns/1ps

module ftdi_sim;

wire        ftdi_clk_w    ;
wire        ftdi_rst_w    ;
wire        ftdi_rxf_w    ;
wire        ftdi_txe_w    ;
wire        ftdi_siwua_w  ;
wire        ftdi_wrn_w    ;
wire        ftdi_rdn_w    ;
wire        ftdi_oen_w    ;  
wire  [7:0] ftdi_data_io_w;  

initial begin
    $display("Starting FTDI simulation");
    #100ns;
    u_um232h_bfm.rst();
    #100us;
    $finish();
end 

ftdi_top u_ftdi_top
(
     .ftdi_clk_i  (ftdi_clk_w    )
    ,.ftdi_rst_i  (ftdi_rst_w    )
    ,.ftdi_rxf_i  (ftdi_rxf_w    )
    ,.ftdi_txe_i  (ftdi_txe_w    )
    ,.ftdi_siwua_o(ftdi_siwua_w  )
    ,.ftdi_wrn_o  (ftdi_wrn_w    )
    ,.ftdi_rdn_o  (ftdi_rdn_w    )
    ,.ftdi_oen_o  (ftdi_oen_w    )  
    ,.ftdi_data_io(ftdi_data_io_w) 
);

um232h_bfm u_um232h_bfm
(
     .ftdi_clk_o  (ftdi_clk_w    )
    ,.ftdi_rst_o  (ftdi_rst_w    )
    ,.ftdi_rxf_o  (ftdi_rxf_w    )
    ,.ftdi_txe_o  (ftdi_txe_w    )
    ,.ftdi_siwua_i(ftdi_siwua_w  )
    ,.ftdi_wrn_i  (ftdi_wrn_w    )
    ,.ftdi_rdn_i  (ftdi_rdn_w    )
    ,.ftdi_oen_i  (ftdi_oen_w    )  
    ,.ftdi_data_io(ftdi_data_io_w) 
);

endmodule