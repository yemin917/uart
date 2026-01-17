`timescale 1ns / 1ps

module tb_top();
    reg clk, rstn;
    reg tx_start_pc;
    reg [7:0] tx_data_pc;
    reg parity_mode_pc;
    
    wire uart_tx;          // FPGA -> PC 출력
    wire tx_busy_pc;
    wire tx_line_pc_in;       // PC uart_tx 출력 -> FPGA uart_rx 입력
    wire tx_line_pc_out;
    
    assign tx_line_pc_in = tx_line_pc_out;
    
    parameter CLK_FREQ = 50_000_000;
    parameter BAUD_RATE = 9600;

    // FPGA top 모듈 인스턴스
    top #(
        .CLK_FREQ(CLK_FREQ),
        .BAUD_RATE(BAUD_RATE)
    ) top_inst (
        .clkp(clk),
        .clkn(~clk),
        .rstn(rstn),
        .uart_rx(tx_line_pc_in), // PC UART 출력 연결
        .parity_mode_pc(parity_mode_pc),
        .uart_tx(uart_tx)
    );

    // PC 역할 uart_tx 모듈
    uart_tx #(
        .CLK_FREQ(CLK_FREQ),
        .BAUD_RATE(BAUD_RATE)
    ) uart_tx_inst (
        .clk(clk),
        .rstn(rstn),
        .tx_start(tx_start_pc),
        .tx_data(tx_data_pc),
        .parity_mode(parity_mode_pc),
        .tx_line(tx_line_pc_out),  // FPGA uart_rx로 연결
        .tx_busy(tx_busy_pc)
    );

    // Clock 생성
    initial clk = 0;
    always #10 clk = ~clk; // 50MHz -> 20ns 주기

    // 초기화
    initial begin
        rstn = 0;
        tx_start_pc = 0;
        tx_data_pc = 8'h00;
        parity_mode_pc = 0;
        #100 rstn = 1; // reset 해제
    end

    // PC -> FPGA 데이터 전송
    initial begin
        // reset 해제 후 충분히 대기
        #150;

        // 첫 번째 전송
        tx_data_pc = 8'hA5;
        tx_start_pc = 1;
        #20 tx_start_pc = 0;

        // 충분히 대기 후 두 번째 전송
        /*#2000;
        tx_data_pc = 8'h5A;
        tx_start_pc = 1;
        #20 tx_start_pc = 0;*/
    end

    // FPGA uart_tx 출력 모니터링
    initial begin
        forever begin
            @(posedge uart_tx);
            $display("Time %t : FPGA uart_tx toggled!", $time);
        end
    end
endmodule
