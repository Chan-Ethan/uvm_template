`ifndef MY_MONITOR_SV
`define MY_MONITOR_SV

class my_monitor extends uvm_monitor;
	virtual my_if vif;
	uvm_analysis_port #(my_transaction) ap;

	`uvm_component_utils(my_monitor)
  
  	function new(string name = "my_monitor", uvm_component parent = null);
		super.new(name, parent);
		`uvm_info("my_monitor", "my_monitor is created", UVM_MEDIUM)
  	endfunction

	extern virtual function void build_phase(uvm_phase phase);
  	extern virtual task main_phase(uvm_phase phase);
	extern virtual task collect_one_pkt(my_transaction tr);
endclass

function void my_monitor::build_phase(uvm_phase phase);
	super.build_phase(phase);
	`uvm_info("my_monitor", "my_monitor build_phase", UVM_MEDIUM)

	if (!uvm_config_db#(virtual my_if)::get(this, "", "vif", vif)) begin
		`uvm_fatal("my_monitor", "virtual interface must be set for vif!")
	end

	ap = new("ap", this);
endfunction

task my_monitor::main_phase(uvm_phase phase);
	my_transaction tr;

	while (1) begin
		tr = new("tr");
		collect_one_pkt(tr);
		ap.write(tr);
	end
endtask

task my_monitor::collect_one_pkt(my_transaction tr);
	bit [7:0] 	data_q[$];
	int pload_size;

	while (1) begin
		@(posedge vif.clk);
		if (vif.valid) break;
	end

	`uvm_info("my_monitor", "begin to collect one pkt", UVM_LOW)
	while (vif.valid) begin
		data_q.push_back(vif.data);
		@(posedge vif.clk);
	end

	// pop dmac from data_q
	for (int i = 0; i < 6; i++) begin
		tr.dmac = {tr.dmac[39:0], data_q.pop_front()};
	end

	// pop smac from data_q
	for (int i = 0; i < 6; i++) begin
		tr.smac = {tr.smac[39:0], data_q.pop_front()};
	end

	// pop ether_type from data_q
	tr.ether_type = {data_q.pop_front(), data_q.pop_front()};

	// pop pload from data_q
	pload_size = data_q.size();
    tr.pload = new[pload_size-4];
	for (int i = 0; i < pload_size; i++) begin
		tr.pload[i] = data_q.pop_front();
	end

	// pop crc from data_q
	for (int i = 0; i < 4; i++) begin
		tr.crc = {tr.crc[23:0], data_q.pop_front()};
	end

	`uvm_info("my_monitor", "collect one pkt finish:", UVM_LOW)
	tr.my_print();
endtask

`endif
