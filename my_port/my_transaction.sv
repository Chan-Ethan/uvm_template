`ifndef MY_TRANSACTION_SV
`define MY_TRANSACTION_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

class my_transaction extends uvm_sequence_item;
    rand bit [47:0] dmac;
    rand bit [47:0] smac;
    rand bit [15:0] ether_type;
    rand byte       pload[];
    rand bit [31:0] crc;

    `uvm_object_utils_begin(my_transaction)
        `uvm_field_int(dmac, UVM_ALL_ON)
        `uvm_field_int(smac, UVM_ALL_ON)
        `uvm_field_int(ether_type, UVM_ALL_ON)
        `uvm_field_array_int(pload, UVM_ALL_ON)
        `uvm_field_int(crc, UVM_ALL_ON)
    `uvm_object_utils_end

    constraint pload_cons {
        pload.size() >= 46;
        pload.size() <= 1500;
    }

    function bit[31:0] cal_crc();
        return 32'h0;
    endfunction

    function void post_randomize();
        crc = cal_crc();
    endfunction

    `uvm_object_utils(my_transaction)

    function new(string name = "my_transaction");
        super.new(name);
    endfunction
endclass

`endif // MY_TRANSACTION_SV