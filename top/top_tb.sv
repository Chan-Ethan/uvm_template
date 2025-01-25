module top_tb (
    
);
    logic           clk     ;
    logic           rst_n   ;
    logic   [7: 0]  rxd     ;
    logic           rx_dv   ;
    logic   [7: 0]  txd     ;
    logic           tx_en   ;

    my_if   input_if(clk, rst_n);
    my_if   output_if(clk, rst_n);

    initial begin   
        clk = 1'b0;
        rst_n = 1'b1;
        $display("uvm top_tb");

        // #100us;
        rst_n = 1'b0;
        $display("rst_n active");
        
        #200us;
        rst_n = 1'b1;
        $display("reset finish");

        // #600us;
        // $finish();
    end

    initial begin
        $fsdbDumpfile("./fsdb/tb.fsdb");  //记录波形，波形名字testname.fsdb
        $fsdbDumpvars("+all");  //+all参数，dump SV中的struct结构体
        $fsdbDumpSVA();   //将assertion的结果存在fsdb中
        //$fsdbDumpMDA(0, top);  //dump memory arrays
    end

    always begin
        #4ns;   clk <= ~clk;
    end

    dut_top dut_top (
        .clk    (clk            ),
        .rst_n  (rst_n          ),
        .rxd    (input_if.data  ),
        .rx_dv  (input_if.valid ),
        .txd    (output_if.data ),
        .tx_en  (output_if.valid)
    );

    initial begin
        run_test();
        $finish();
    end

    initial begin
        uvm_config_db#(virtual my_if)::set(null, "uvm_test_top.env.i_agt.drv", "vif", input_if);
        uvm_config_db#(virtual my_if)::set(null, "uvm_test_top.env.i_agt.mon", "vif", input_if);
        uvm_config_db#(virtual my_if)::set(null, "uvm_test_top.env.o_agt.mon", "vif", output_if);
    end
endmodule
