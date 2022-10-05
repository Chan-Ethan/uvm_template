#VERDI_HOME = /home/synopsys/verdi/Verdi_O-2018.09-SP2

compile:
	vcs	\
	+v2k \
	-full64 \
	-sverilog \
	-top top_tb \
	-debug_pp \
	-ntb_opts uvm-1.1 \
	-timescale=1ns/1ns \
	-fsdb \
	-f ../../top/flist.f \
	-l comp.log
	#-o $(tc).o

sim:
	#./$(tc)
	./simv \
	-l sim.log \
	+UVM_VERBOSITY=HIGH \
	+UVM_TESTNAME=simple_test
	#+UVM_TR_RECORD \

all: compile sim
