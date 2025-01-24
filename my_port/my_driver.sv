`ifndef MY_DRIVER_SV
`define MY_DRIVER_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

class my_driver extends uvm_driver);
  	`uvm_component_utils(my_driver)
	virtual my_if vif;
  
  	function new(string name = "my_driver", uvm_component parent = null);
    	super.new(name, parent);
		`uvm_info("my_driver", "my_driver is created", UVM_MEDIUM)
  	endfunction

	extern virtual function void build_phase(uvm_phase phase);
  	extern virtual task main_phase(uvm_phase phase);
	extern virtual task drive_one_pkt(my_transaction tr);
endclass

function void my_driver::build_phase(uvm_phase phase);
	super.build_phase(phase);
	`uvm_info("my_driver", "my_driver build_phase", UVM_MEDIUM)
	if (!uvm_config_db#(virtual my_if)::get(this, "", "vif", vif)) begin
		`uvm_fatal("my_driver", "virtual interface must be set for vif!")
	end
endfunction

task my_driver::main_phase(uvm_phase phase);
	my_transaction tr;

	phase.raise_objection(this);
	`uvm_info("my_driver", "my_driver main_phase", UVM_MEDIUM)

	vif.data <= 8'b0;
	vif.valid <= 1'b0;
  	
	// wait for reset to be released
	while (!vif.rst_n) begin
		@(posedge vif.clk);
  	end

	for(int i = 0; i < 2; i++) begin
		// generate a random transaction and drive it
		tr = new("tr");
		assert (tr.randomize() with {pload.size() == 200;})
		drive_one_pkt(tr);
	end

	# 100us;
	phase.drop_objection(this);
endtask

task my_driver::drive_one_pkt(my_transaction tr);
	bit [7:0] 	data_q[$];
	int  		data_size;

	data_size = tr.pack_bytes(data_q) / 8;

	`uvm_info("my_driver", "begin to drive one pkt", UVM_LOW)
	repeat(3) @(posedge vif.clk);

	while(data_q.size() > 0) begin
		@(posedge vif.clk);
		vif.valid <= 1'b1;
		vif.data <= data_q.pop_front();
	end

	@(posedge vif.clk);
	vif.valid <= 1'b0;
	`uvm_info("SNED_PKT", "drive one pkt done", UVM_LOW)
endtask

`endif
