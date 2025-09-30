`timescale 1ns/1ps  

module ftdi_fifo #(
     parameter WIDTH   = 8
    ,parameter DEPTH   = 64
    ,parameter ADDR_W  = 6
    ,parameter COUNT_W = 7
)(
     input                      clk_i
    ,input                      rst_i   
    ,input        [  WIDTH-1:0] data_in_i
    ,input                      push_i
    ,input                      pop_i  
    ,output logic [  WIDTH-1:0] data_out_o
    ,output logic               accept_o
    ,output logic               valid_o
    ,output logic [COUNT_W-1:0] level_o
);
/* DEFINE */

/* VARIABLER */
    reg [  WIDTH-1:0] ram_q[DEPTH-1:0];
    reg [ ADDR_W-1:0] rd_ptr_q;
    reg [ ADDR_W-1:0] wr_ptr_q;
    reg [COUNT_W-1:0] count_q;

/* LOGIC */
    always_ff @ (posedge clk_i or posedge rst_i) begin
        if (rst_i) begin
            count_q   <= {(COUNT_W) {1'b0}};
            rd_ptr_q  <= {( ADDR_W) {1'b0}};
            wr_ptr_q  <= {( ADDR_W) {1'b0}};
        end else begin
            if (push_i & accept_o) begin // Push
                ram_q[wr_ptr_q] <= data_in_i;
                wr_ptr_q        <= wr_ptr_q + 1;
            end
            
            if (pop_i & valid_o) // Pop
                rd_ptr_q <= rd_ptr_q + 1;

            if ((push_i & accept_o) & ~(pop_i & valid_o)) // Count up
                count_q <= count_q + 1;
            else if (~(push_i & accept_o) & (pop_i & valid_o)) // Count down
                count_q <= count_q - 1;
        end
    end

    always_comb begin : out_block
        /* verilator lint_off WIDTH */
        valid_o       = (count_q != 0);
        accept_o      = (count_q != DEPTH);
        /* verilator lint_on WIDTH */

        data_out_o    = ram_q[rd_ptr_q];
        level_o       = count_q;
    end

endmodule