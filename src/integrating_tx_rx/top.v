module top #(
    CLK_FREQ = 50_000_000,
    BAUD_RATE = 9600
)(
    input clkp,
    input clkn,
    input rstn,
    input parity_mode_pc,
    input uart_rx,
    output uart_tx
);
    
    wire [7:0] tx_data;
    wire [7:0] rx_data;
    wire tx_start;
    wire rx_done;
    
    clk_wiz_0 clk_gen_inst(
        .clk_in1_p(clkp),
        .clk_in1_n(clkn),
        .resetn(rstn),
        .locked(clk_locked),
        .clk_out1(clk50)
    );
    
    uart_rx #(
        .CLK_FREQ(CLK_FREQ),
        .BAUD_RATE(BAUD_RATE)
    ) uart_rx_inst (
        .clk(clk50),
        .rstn(rstn),
        .rx_line(uart_rx),
        .parity_mode(parity_mode_pc),
        .rx_data(rx_data),
        .rx_done(rx_done),
        .rx_error(rx_error)
    );
    
    uart_tx #(
        .CLK_FREQ(CLK_FREQ),
        .BAUD_RATE(BAUD_RATE)
    ) uart_tx_inst (
        .clk(clk50),
        .rstn(rstn),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .parity_mode(parity_mode_pc),
        .tx_line(uart_tx),
        .tx_busy(tx_busy)
    );

     uart_ctrl uart_ctrl_inst(
        .clk(clk50),
        .rstn(rstn),
        .rx_data(rx_data),
        .rx_done(rx_done),
        .rx_error(rx_error),
        .tx_data(tx_data),
        .tx_start(tx_start),
        .tx_busy(tx_busy)
    );
endmodule
