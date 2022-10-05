module top_tb (
    
);
    reg clk;
    shortint a = 'hff89;
    shortint b = 'h0089;
    bit [3:0] c = '1;
    initial begin
        $display("a = %b \nb = %b", a, b);
        $display("c = %b", c);
    end
    initial begin   
        clk = 0;
        $display("uvm top_tb");
        #100us;
        $finish();
    end

    initial begin
        $fsdbDumpfile("testname.fsdb");  //记录波形，波形名字testname.fsdb
        $fsdbDumpvars("+all");  //+all参数，dump SV中的struct结构体
        $fsdbDumpSVA();   //将assertion的结果存在fsdb中
        //$fsdbDumpMDA(0, top);  //dump memory arrays
    end

    always begin
        #4ns;   clk <= ~clk;
    end

    dut_top dut(clk);
endmodule
