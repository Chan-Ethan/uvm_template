#VERDI_HOME = /home/synopsys/verdi/Verdi_O-2018.09-SP2
FILE_LIST = ../../top/flist.f
tc = simple_test
VERBOSITY = HIGH

compile:
	vcs	\
	+v2k \
	+define+SIMULATION \
	-full64 \
	-sverilog \
	-top top_tb \
	-debug_pp \
	-ntb_opts uvm-1.1 \
	-timescale=1ns/1ns \
	-fsdb \
	-f $(FILE_LIST) \
	-l ./comp_log/$(tc).log \
	#-o $(tc).o

sim:
	#./$(tc)
	./simv \
	-l ./sim_log/$(tc).log \
	+UVM_VERBOSITY=$(VERBOSITY) \
	+UVM_TESTNAME=$(tc)	\
	+define+SIMULATION \
	+fsdb+autoflush \
	#+UVM_TR_RECORD \

# show the code coverage
wave:
	verdi \
    -sv \
    +define+SIMULATION \
    -f $(FILE_LIST) \
	-top top_tb \
    -ssf ./fsdb/tb.fsdb \
    & 

clean:
	rm -rf *.log ucli.key vc_hdrs.h csrc simv* verdiLog novas* ./comp_log/* ./sim_log/* ./fsdb/*

all: compile sim
