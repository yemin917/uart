`timescale 1ns / 1ps

module tb_uart();
    reg clk, rstn;
    reg tx_start;
    reg parity_mode;
    reg [7:0] tx_data;
    //rx_line은 tx모듈의 출력과 연결되므로 reg선언X
    
    wire tx_line;
    wire tx_busy;
    wire [7:0] rx_data;
    wire rx_done;
    wire rx_error;
    
    uart_tx#(
        .CLK_FREQ(50_000_000),
        .BAUD_RATE(9600)
    )
    uart_tx_inst(
        .clk(clk),
        .rstn(rstn),
        .tx_start(tx_start),
        .tx_data(tx_data),
        . parity_mode(parity_mode),
        .tx_line(tx_line),
        .tx_busy(tx_busy)
    );
    
    uart_rx #(
        .CLK_FREQ(50_000_000),
        .BAUD_RATE(9600)
    )
    uart_rx_inst(
        .clk(clk),
        .rstn(rstn),
        .rx_line(tx_line),
        .parity_mode(parity_mode),
        .rx_data(rx_data),
        .rx_done(rx_done),
        .rx_error(rx_error)
    );
    
    initial 
        clk = 0;
    
    always
        #10 clk = ~clk;
        
    initial begin
        rstn = 0; 
        tx_start = 0; 
        tx_data = 0; 
        parity_mode = 0;
        
        #100 rstn = 1;
        
        //test case1
        tx_data = 8'hA5;
        parity_mode = 0; //even parity
        tx_start = 1; //transmission start
        
        wait(rx_done==1); //wait for reception success
        
        if (rx_data == 8'hA5 && rx_error == 0)
            $display("Test case 1 passed!");
        else begin
            $display("Test case 1 passed!");
            $stop;
        end
   
        $finish;        
    end
endmodule
