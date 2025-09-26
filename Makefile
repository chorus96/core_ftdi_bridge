verilog_src  = src_v/ftdi_async.v
verilog_src += src_v/ftdi_bridge.v
verilog_src += src_v/ftdi_fifo.v
verilog_src += src_v/ftdi_sim.sv
verilog_src += src_v/ftdi_sync.v
verilog_src += src_v/ftdi_top.sv

all:
	mkdir -p out
	iverilog -o out/ftdi_sim.vpp $(verilog_src)
	vvp out/ftdi_sim.vpp

run:
	vvp out/ftdi_sim.vpp

clean:
	rm -fr out
