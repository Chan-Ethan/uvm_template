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

    extern virtual function void my_print();
    extern virtual function void my_copy(my_transaction tr);
    extern virtual function bit my_compare(my_transaction tr);
endclass

function void my_transaction::my_print();
    $display("dmac = %0h", dmac);
    $display("smac = %0h", smac);
    $display("ether_type = %0h", ether_type);
    for (int i = 0; i < pload.size(); i++) begin
        $display("pload[%0d] = %0h", i, pload[i]);
    end
    $display("crc = %0h", crc);
endfunction

function void my_transaction::my_copy(my_transaction tr);
    if (tr == null) begin
        `uvm_error("my_transaction", "null transaction")
        return;
    end

    dmac = tr.dmac;
    smac = tr.smac;
    ether_type = tr.ether_type;
    pload = new[tr.pload.size()];
    foreach (tr.pload[i]) begin
        pload[i] = tr.pload[i];
    end
    crc = tr.crc;
endfunction

function bit my_transaction::my_compare(my_transaction tr);
    if (tr == null) begin
        `uvm_error("my_transaction", "null transaction")
        return 0;
    end

    if (dmac != tr.dmac) begin
        `uvm_error("my_transaction", "dmac mismatch")
        return 0;
    end

    if (smac != tr.smac) begin
        `uvm_error("my_transaction", "smac mismatch")
        return 0;
    end

    if (ether_type != tr.ether_type) begin
        `uvm_error("my_transaction", "ether_type mismatch")
        return 0;
    end

    if (pload.size() != tr.pload.size()) begin
        `uvm_error("my_transaction", "pload size mismatch")
        return 0;
    end

    for (int i = 0; i < pload.size(); i++) begin
        if (pload[i] != tr.pload[i]) begin
            `uvm_error("my_transaction", $sformatf("pload[%0d] mismatch", i))
            return 0;
        end
    end

    if (crc != tr.crc) begin
        `uvm_error("my_transaction", "crc mismatch")
        return 0;
    end

    return 1;
endfunction

`endif // MY_TRANSACTION_SV