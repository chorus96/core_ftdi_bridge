verilog_src  = src_v/ftdi_bridge.sv
verilog_src += src_v/ftdi_fifo.sv
verilog_src += sim_v/ftdi_sim.sv
verilog_src += src_v/ftdi_sync.sv
verilog_src += src_v/ftdi_top.sv
verilog_src += mdl_v/um232h_bfm.sv
verilog_src += mdl_v/gpio_bfm.sv
verilog_src += mdl_v/axi_bfm.sv
# verilog_src += src_v/ftdi_pkg.sv

all: clean
	mkdir -p out
	iverilog -s ftdi_sim -g2012 -I src_v -o out/ftdi_sim.vpp $(verilog_src)
	vvp out/ftdi_sim.vpp

run:
	vvp out/ftdi_sim.vpp

clean:
	rm -fr out
