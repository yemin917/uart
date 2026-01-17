module uart_ctrl (
    input clk, rstn,
    
    input [7:0] rx_data,
    input rx_done, rx_error,
    
    output reg [7:0] tx_data,
    output reg tx_start,
    
    input tx_busy
);
    
    reg tx_start_flag;
    
    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            tx_data <= 'h0;
        else if (rx_done & ~rx_error)
            tx_data <= rx_data;
     end
     
     always @(posedge clk or negedge rstn) begin
        if (~rstn)
            tx_start_flag <= 'h0;
        else if (tx_start_flag & tx_start)
            tx_start_flag <= 'h0;
        else if (rx_done & ~rx_error)
            tx_start_flag <= 'h1;
     end
     
     always @(posedge clk or negedge rstn) begin
        if (~rstn)
            tx_start <= 'h0;
        else if (tx_start)
            tx_start <= 'h0;
        else if (tx_start_flag & ~tx_busy)
            tx_start <= 1'b1;
     end
endmodule
