
package ftdi_pkg;
    `define CMD_R               3:0
    `define LEN_UPPER_R         7:4
    `define LEN_LOWER_R         7:0

    parameter CMD_NOP          = 4'd0;
    parameter CMD_WR           = 4'd1;
    parameter CMD_RD           = 4'd2;
    parameter CMD_GP_WR        = 4'd3;
    parameter CMD_GP_RD        = 4'd4;
    parameter CMD_GP_RD_CLR    = 4'd5;
    parameter CMD_STREAM_ON    = 4'd6;
    parameter CMD_STREAM_OFF   = 4'd7;
endpackage
