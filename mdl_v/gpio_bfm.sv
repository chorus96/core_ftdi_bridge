`timescale 1ns/1ps  

module gpio_bfm
    import ftdi_pkg::*;
#(
    parameter C_GPIO_WIDTH = 32
)
(
     input                     clk_i
    ,input                     rst_i
    ,input  [C_GPIO_WIDTH-1:0] gpio_i
    ,output [C_GPIO_WIDTH-1:0] gpio_o
);

initial $monitor("GPIO: %h", gpio_i);

endmodule