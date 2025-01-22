`ifndef MY_DRIVER_SV
`define MY_DRIVER_SV

class my_driver extends uvm_driver;
  	`uvm_component_utils(my_driver)
	virtual my_if vif;
  
  	function new(string name = "my_driver", uvm_component parent = null);
    	super.new(name, parent);
		`uvm_info("my_driver", "my_driver is created", UVM_LOW)
  	endfunction

  	extern virtual task main_phase(uvm_phase phase);
	extern virtual function void build_phase(uvm_phase phase);
	extern virtual task drive_one_pkt(my_transaction tr);
endclass

function void my_driver::build_phase(uvm_phase phase);
	super.build_phase(phase);
	`uvm_info("my_driver", "my_driver build_phase", UVM_LOW)
	if (!uvm_config_db#(virtual my_if)::get(this, "", "vif", vif)) begin
		`uvm_fatal("my_driver", "virtual interface must be set for vif!")
	end
endfunction

task my_driver::main_phase(uvm_phase phase);
	my_transaction tr;

	phase.raise_objection(this);
	`uvm_info("my_driver", "my_driver main_phase", UVM_LOW)

	vif.data <= 8'b0;
	vif.valid <= 1'b0;
  	
	while (!vif.rst_n) begin
		@(posedge vif.clk);
  	end

	for(int i = 0; i < 2; i++) begin
		tr = new("tr");
		assert (tr.randomize() with {pload.size() == 200;})
		drive_one_pkt(tr);
	end

	phase.drop_objection(this);
endtask

task my_driver::drive_one_pkt(my_transaction tr);
	bit [47:0]	tmp_data;
	bit [7:0] 	data_q[$];

	// push dmac to data_q
	tmp_data = tr.dmac;
	for(int i = 0; i < 6; i++) begin
		data_q.push_back(tmp_data[7:0]);
		tmp_data = tmp_data >> 8;
	end

	// push smac to data_q
	tmp_data = tr.smac;
	for(int i = 0; i < 6; i++) begin
		data_q.push_back(tmp_data[7:0]);
		tmp_data = tmp_data >> 8;
	end

	// push ether_type to data_q
	tmp_data = tr.ether_type;
	for(int i = 0; i < 2; i++) begin
		data_q.push_back(tmp_data[7:0]);
		tmp_data = tmp_data >> 8;
	end

	// push pload to data_q
	for(int i = 0; i < tr.pload.size(); i++) begin
		data_q.push_back(tr.pload[i]);
	end

	// push crc to data_q
	tmp_data = tr.crc;
	for(int i = 0; i < 4; i++) begin
		data_q.push_back(tmp_data[7:0]);
		tmp_data = tmp_data >> 8;
	end

	`uvm_info("my_driver", "begin to drive one pkt", UVM_LOW)
	repeat(3) @(posedge vif.clk);

	while(data_q.size() > 0) begin
		@(posedge vif.clk);
		vif.valid <= 1'b1;
		vid.data <= data_q.pop_front();
	end

	@(posedge vif.clk);
	vif.valid <= 1'b0;
	`uvm_info("my_driver", "drive one pkt done", UVM_LOW)

endtask

`endif