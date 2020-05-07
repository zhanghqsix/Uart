`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/04/30 18:41:31
// Design Name: 
// Module Name: test_modify_Uart_rx
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module test_modify_Uart_rx();
reg           rst;
reg           clk;
wire  [7:0]   rx_data;
wire          rx_data_valid;
reg           rx;

initial
begin
    #0          rst=1'b0;
                clk=1'b0;
                rx=0;
    #100        rst=1'b1;
    #(300000000)   $stop;
end

always #31.25	begin
    clk = ~clk;
end

always #60000 begin
	rx = ~rx;
end

modify_Uart_rx #
(
.Challenge_Bit(8),
.CLK_FRE(16),
.BAUD_RATE(115200)
)
modify_Uart_rx_inst
(
.clk(clk),
.n_reset(rst),
.rx_data(rx_data),
.rx_data_valid(rx_data_valid),
.rx_pin(rx)
);
endmodule
