module uart_rx #(
    parameter CLK_FREQ = 50_000_000,
    parameter BAUD_RATE = 9600,
    parameter IDLE = 3'b000,
    parameter START = 3'b001,
    parameter DATA = 3'b010,
    parameter PARITY = 3'b011,
    parameter STOP = 3'b100
)(
    input clk,rstn,
    input rx_line,
    input parity_mode,
    output reg [7:0] rx_data,
    output reg rx_done,
    output reg rx_error
);
    
    localparam BAUD_CNT_MAX = CLK_FREQ / BAUD_RATE;
    
    reg [2:0] state;
    reg [12:0] baud_cnt;
    reg [3:0] bit_idx;
    reg parity_bit_rx, parity_bit_calc;
    reg [7:0] shift_reg;

    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            state <= IDLE;
            baud_cnt <= 0;
            bit_idx <= 0;
            parity_bit_rx <= 0;
            parity_bit_calc <= 0;
            rx_done <= 0;
            rx_error <= 0;
            rx_data <= 0;
            shift_reg <= 8'b0;
        end
        else begin
            case(state)
                IDLE: begin
                    rx_done <= 0;
                    rx_error <= 0;
                    if(!rx_line) begin
                        baud_cnt <= 0;       // START 비트 감지 시 카운터 초기화
                        state <= START;
                    end
                end

                START: begin
                    if(baud_cnt == BAUD_CNT_MAX/2) begin
                        // START 비트 중앙 샘플링
                        if(rx_line == 0) begin
                            baud_cnt <= baud_cnt + 1;
                        end
                        else begin
                            // START 오류 시 IDLE로 복귀
                            state <= IDLE;
                        end
                    end
                    else if(baud_cnt < BAUD_CNT_MAX-1) begin
                        baud_cnt <= baud_cnt + 1;
                    end
                    else begin
                        baud_cnt <= 0;
                        bit_idx <= 0;
                        state <= DATA;
                    end
                end

                DATA: begin
                    if(baud_cnt == BAUD_CNT_MAX/2) begin
                        shift_reg[bit_idx] <= rx_line; // 중앙 샘플링
                    end
                    if(baud_cnt < BAUD_CNT_MAX-1) begin
                        baud_cnt <= baud_cnt + 1;
                    end
                    else begin
                        baud_cnt <= 0;
                        if(bit_idx == 7) begin
                            state <= PARITY;
                        end
                        bit_idx <= bit_idx + 1;
                    end
                end

                PARITY: begin
                    if(baud_cnt == BAUD_CNT_MAX/2) begin
                        parity_bit_rx <= rx_line;      // 중앙 샘플링
                        parity_bit_calc <= (parity_mode)? ~^shift_reg : ^shift_reg;
                    end
                    if(baud_cnt < BAUD_CNT_MAX-1) begin
                        baud_cnt <= baud_cnt + 1;
                    end
                    else begin
                        baud_cnt <= 0;
                        state <= STOP;
                    end
                end

                STOP: begin
                    if(baud_cnt < BAUD_CNT_MAX-1) begin
                        baud_cnt <= baud_cnt + 1;    // STOP 비트 전체 기다림
                    end
                    else begin
                        baud_cnt <= 0;
                        rx_done <= 1;
                        rx_data <= shift_reg;
                        if(parity_bit_rx != parity_bit_calc)
                            rx_error <= 1;
                        state <= IDLE;
                    end
                end

            endcase
        end
    end
endmodule
