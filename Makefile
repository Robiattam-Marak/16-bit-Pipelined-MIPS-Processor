PROJECT = cpu16_pipeline
TB = cpu16_pipeline_tb

all:
	@echo "Available Targets:"
	@echo "  make sim"
	@echo "  make clean"

sim:
	xvlog rtl/*.v
	xvlog testbench/$(TB).v
	xelab $(TB)
	xsim $(TB)

clean:
	rm -rf xsim.dir
	rm -f *.log
	rm -f *.jou
	rm -f *.pb
	rm -f *.wdb
	rm -f *.vcd