module top_tb (
    
);
    reg clk;
    initial begin
        clk = 0;
        $display("uvm top_tb");
    end

    forever begin
        #4ns;   clk <= ~clk;
    end

    dut_top dut(clk);
endmodule