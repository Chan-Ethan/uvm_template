`ifndef MY_AGENT_SV
`define MY_AGENT_SV

class my_agent extends uvm_agent;
    my_driver drv;
    my_monitor mon;

    `uvm_component_utils(my_agent)

    function new(string name = "my_agent", uvm_component parent = null);
        super.new(name, parent);
        `uvm_info("my_agent", "my_agent is created", UVM_MEDIUM)
    endfunction

    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);

endclass

function void my_agent::build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("my_agent", "my_agent build_phase", UVM_MEDIUM)
    
    if (is_active == UVM_ACTIVE) begin
        drv = my_driver::type_id::create("drv", this);
    end
    mon = my_monitor::type_id::create("mon", this);
endfunction

function void my_agent::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("my_agent", "my_agent connect_phase", UVM_MEDIUM)
endfunction

`endif // MY_AGENT_SV