module uart_tx #(
    parameter CLK_FREQ = 50_000_000,
    parameter BAUD_RATE = 9600,
    parameter IDLE = 3'b000,
    parameter START = 3'b001,
    parameter DATA = 3'b010,
    parameter PARITY = 3'b011,
    parameter STOP = 3'b100
)(
    input clk, rstn,
    input tx_start,
    input parity_mode,
    input [7:0] tx_data,
    output reg parity_bit,
    output reg tx_line,
    output reg tx_busy
);

    reg [2:0] state;
    reg [12:0]baud_cnt;
    reg [3:0] bit_idx;
    reg [7:0] shift_reg;
    
    localparam BAUD_CNT_MAX = CLK_FREQ / BAUD_RATE;

    //FSM
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            state <= IDLE;
            tx_line <= 1;
            tx_busy <= 0;
            baud_cnt <= 0;
            bit_idx <= 0;
            parity_bit <= 'h0;
        end
        else begin
            case (state)
                IDLE : begin
                    if(tx_start) begin
                        shift_reg <= tx_data;
                        parity_bit <= (parity_mode)? ~^tx_data : ^tx_data;
                        tx_line <= 0;
                        tx_busy <= 1;
                        baud_cnt <= 0;
                        bit_idx <= 0;
                        state <= START;
                    end
                end
                START : begin
                    if(baud_cnt == BAUD_CNT_MAX-1) begin
                        baud_cnt <= 0;
                        tx_line <= shift_reg[0];
                        shift_reg <= shift_reg >> 1;
                        bit_idx <= 1;
                        state <= DATA;
                    end
                    else begin
                        baud_cnt <= baud_cnt + 1;
                    end
                end
                DATA : begin
                    if(baud_cnt == BAUD_CNT_MAX-1) begin
                        baud_cnt <= 0;
                        if(bit_idx < 8) begin
                            tx_line <= shift_reg[0];
                            shift_reg <= shift_reg >> 1;
                            bit_idx <= bit_idx + 1;
                        end
                        else begin
                            tx_line <= parity_bit;
                            state <= PARITY;
                        end
                    end
                    else begin
                        baud_cnt <= baud_cnt + 1;
                    end
                end
                PARITY : begin
                    if(baud_cnt == BAUD_CNT_MAX-1) begin
                        baud_cnt <= 0;
                        tx_line <= 1;
                        state <= STOP;
                    end
                    else begin
                        baud_cnt <= baud_cnt + 1;
                    end
                end
                STOP:  begin
                    if(baud_cnt == BAUD_CNT_MAX-1) begin
                        baud_cnt <= 0;
                        tx_busy <= 0;
                        state <= IDLE;
                    end
                    else begin
                        baud_cnt <= baud_cnt + 1;
                    end
                end
            endcase 
        end
    end                                             
endmodule
