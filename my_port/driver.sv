class my_driver extends uvm_driver;
  	`uvm_component_utils(my_driver)
	virtual my_if vif;
  
  	function new(string name = "my_driver", uvm_component parent = null);
    	super.new(name, parent);
		`uvm_info("my_driver", "my_driver is created", UVM_LOW)
  	endfunction

  	extern virtual task main_phase(uvm_phase phase);
	extern virtual function void build_phase(uvm_phase phase);
endclass

function void my_driver::build_phase(uvm_phase phase);
	super.build_phase(phase);
	`uvm_info("my_driver", "my_driver build_phase", UVM_LOW)
	if (!uvm_config_db#(virtual my_if)::get(this, "", "vif", vif)) begin
		`uvm_fatal("my_driver", "virtual interface must be set for vif!")
	end
endfunction

task my_driver::main_phase(uvm_phase phase);
	phase.raise_objection(this);
	`uvm_info("my_driver", "my_driver main_phase", UVM_LOW)

	vif.data <= 8'b0;
	vif.valid <= 1'b0;
  	
	while (!vif.rst_n) begin
		@(posedge vif.clk);
  	end

	for (int i = 0; i < 256; i++) begin
		@(posedge vif.clk);
		vif.data <= $urandom_range(0, 255);
		vif.valid <= 1'b1;
		`uvm_info("my_driver", "data is drived", UVM_LOW)
	end
	@(posedge vif.clk);
	vif.valid <= 1'b0;

	phase.drop_objection(this);
endtask
