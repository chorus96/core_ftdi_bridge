`timescale 1ns/1ps  

module ftdi_sync
(
     input  logic       clk_i
    ,input  logic       rst_i
    ,input  logic       ftdi_rxf_i
    ,input  logic       ftdi_txe_i
    ,input  logic [7:0] ftdi_data_in_i
    ,input  logic       inport_valid_i
    ,input  logic [7:0] inport_data_i
    ,input  logic       outport_accept_i
    ,output logic       ftdi_siwua_o
    ,output logic       ftdi_wrn_o
    ,output logic       ftdi_rdn_o
    ,output logic       ftdi_oen_o
    ,output logic [7:0] ftdi_data_out_o
    ,output logic       inport_accept_o
    ,output logic       outport_valid_o
    ,output logic [7:0] outport_data_o
);

//-----------------------------------------------------------------
// Tx FIFO
//-----------------------------------------------------------------
wire [7:0] tx_data_w;
wire       tx_valid_w;
wire       tx_accept_w;
wire [6:0] tx_level_w;

ftdi_fifo u_fifo_out
(
    .clk_i(clk_i),
    .rst_i(rst_i),

    .push_i(inport_valid_i),
    .data_in_i(inport_data_i),
    .accept_o(inport_accept_o),

    .valid_o(tx_valid_w),
    .data_out_o(tx_data_w),
    .pop_i(tx_accept_w),
    .level_o(tx_level_w)
);

wire tx_empty_next_w = (tx_level_w <= 7'd1);

//-----------------------------------------------------------------
// Rx FIFO
//-----------------------------------------------------------------
wire [7:0] rx_data_w  = ftdi_data_in_i;
wire       rx_valid_w = !ftdi_rdn_o && !ftdi_rxf_i;
wire       rx_accept_w;
wire [6:0] rx_level_w;

ftdi_fifo u_fifo_in
(
    .clk_i(clk_i),
    .rst_i(rst_i),

    .push_i(rx_valid_w),
    .data_in_i(rx_data_w),
    .accept_o(rx_accept_w),

    .valid_o(outport_valid_o),
    .data_out_o(outport_data_o),
    .pop_i(outport_accept_i),
    .level_o(rx_level_w)
);

wire rx_full_next_w = (rx_level_w >= 7'd63);

//-----------------------------------------------------------------
// Defines / Local params
//-----------------------------------------------------------------
localparam STATE_W           = 2;
typedef enum logic [STATE_W-1:0] {
     STATE_IDLE = 2'd0
    ,STATE_TX   = 2'd1
    ,STATE_RX   = 2'd2
} state_e;
state_e current_state_q, next_state_d;

wire rx_space_w = rx_accept_w;
wire rx_ready_w = !ftdi_rxf_i;
wire tx_space_w = !ftdi_txe_i;

reg  tx_valid_q;
assign tx_accept_w = !tx_valid_q || (current_state_q == STATE_TX && tx_space_w);

always_ff @ (posedge clk_i or posedge rst_i)
    if (rst_i)            tx_valid_q <= 1'b0;
    else if (tx_accept_w) tx_valid_q <= tx_valid_w;

always_comb begin // Next State Logic
    next_state_d = current_state_q;

    case (current_state_q)
    STATE_IDLE :
    begin
        if (rx_ready_w && rx_space_w)
            next_state_d    = STATE_RX;
        else if (tx_space_w && (tx_valid_w || tx_valid_q))
            next_state_d    = STATE_TX;
    end
    STATE_RX :
    begin
        if (!rx_ready_w || rx_full_next_w)
            next_state_d  = STATE_IDLE;
    end
    STATE_TX :
    begin
        if (!tx_space_w || tx_empty_next_w)
            next_state_d  = STATE_IDLE;
    end    
    default:
        ;
   endcase
end

always_ff @ (posedge clk_i or posedge rst_i) // Update state
    if (rst_i) current_state_q <= STATE_IDLE;
    else       current_state_q <= next_state_d;

//-----------------------------------------------------------------
// RD/WR/OE
//-----------------------------------------------------------------
// Xilinx placement pragmas:
//synthesis attribute IOB of rdn_q is "TRUE"
//synthesis attribute IOB of wrn_q is "TRUE"
//synthesis attribute IOB of oen_q is "TRUE"
//synthesis attribute IOB of data_q is "TRUE"

reg       rdn_q;
reg       wrn_q;
reg       oen_q;
reg [7:0] data_q;

always_ff @ (posedge clk_i or posedge rst_i)
    if (rst_i)
        oen_q   <= 1'b1;
    else if (current_state_q == STATE_IDLE && next_state_d == STATE_RX)
        oen_q   <= 1'b0;
    else if (current_state_q == STATE_RX && next_state_d == STATE_IDLE)
        oen_q   <= 1'b1;

always_ff @ (posedge clk_i or posedge rst_i)
    if (rst_i)
        rdn_q   <= 1'b1;
    else if (current_state_q == STATE_IDLE && next_state_d == STATE_RX)
        rdn_q   <= 1'b0;
    else if (current_state_q == STATE_RX && next_state_d == STATE_IDLE)
        rdn_q   <= 1'b1;

always_ff @ (posedge clk_i or posedge rst_i)
    if (rst_i)
        wrn_q   <= 1'b1;
    else if (current_state_q == STATE_IDLE && next_state_d == STATE_TX)
        wrn_q   <= 1'b0;
    else if (current_state_q == STATE_TX && next_state_d == STATE_IDLE)
        wrn_q   <= 1'b1;

always_ff @ (posedge clk_i or posedge rst_i)
    if (rst_i)
        data_q  <= 8'b0;
    else if (tx_accept_w)
        data_q  <= tx_data_w;

always_comb begin: output_block
    ftdi_wrn_o      = wrn_q;
    ftdi_rdn_o      = rdn_q;
    ftdi_oen_o      = oen_q;
    ftdi_data_out_o = data_q;
    ftdi_siwua_o    = 1'b1; // TODO:
end

endmodule