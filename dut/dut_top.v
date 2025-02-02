module dut_top (
    input               clk,
    input               rst_n,
    input       [7: 0]  rxd,
    input               rx_dv,
    output reg  [7: 0]  txd,
    output reg          tx_en
);
    always @(posedge clk) begin
        if (!rst_n) begin
            txd <= 8'b0;
            tx_en <= 1'b0;
        end
        else begin
            txd <= rxd;
            tx_en <= rx_dv;
        end
    end

endmodule
