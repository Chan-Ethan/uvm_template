module top_tb (
    
);
    logic           clk     ;
    logic           rst_n   ;
    logic   [7: 0]  rxd     ;
    logic           rx_dv   ;
    logic   [7: 0]  txd     ;
    logic           tx_en   ;

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
        .clk    (clk    ),
        .rst_n  (rst_n  ),
        .rxd    (rxd    ),
        .rx_dv  (rx_dv  ),
        .txd    (txd    ),
        .tx_en  (tx_en  )
    );

    initial begin
        my_driver drv;
        drv = new("drv", null);
        drv.main_phase(null);
        $finish();
    end
endmodule
