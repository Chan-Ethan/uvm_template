`ifndef MY_ENV_SV
`define MY_ENV_SV

class my_env extends uvm_env;
    my_agent i_agt;
    my_agent o_agt;

    function new(string name = "my_env", uvm_component parent = null);
        super.new(name, parent);
        `uvm_info("my_env", "my_env is created", UVM_MEDIUM)
    endfunction

    extern virtual function void build_phase(uvm_phase phase);

    `uvm_component_utils(my_env)

endclass

function void my_env::build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("my_env", "my_env build_phase", UVM_MEDIUM)
    
    i_agt = my_agent::type_id::create("i_agt", this);
    o_agt = my_agent::type_id::create("o_agt", this);
    i_agt.is_active = UVM_ACTIVE;
    o_agt.is_active = UVM_PASSIVE;
endfunction

`endif // MY_ENV_SV