`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/04/30 10:41:46
// Design Name: 
// Module Name: test_modify_Uart_tx
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


module test_modify_Uart_tx();
reg           rst;
reg           clk;
reg  [7:0]    tx_data;
reg           tx_data_valid;
wire          tx_data_ready;
wire          tx;

initial
begin
    #0          rst=1'b0;
                clk=1'b0;
                tx_data_valid=1'b0;
                tx_data=8'b0;
    #100        rst=1'b1;
    #(3625)     tx_data[0]=1;
                tx_data[1]=0;
                tx_data[2]=0;
                tx_data[3]=1;
                tx_data[4]=0;
                tx_data[5]=1;
                tx_data[6]=1;
                tx_data[7]=0;
                tx_data_valid=1;   
   #(3000000)   $stop;
end

always #100000
begin
        tx_data_valid=~tx_data_valid;
end

always #31.25
begin
        clk = ~clk;
end

modify_Uart_tx #
(
.Challenge_Bit(8),
.CLK_FRE(16),
.BAUD_RATE(115200)
)
modify_Uart_tx_inst
(
.clk(clk),
.n_reset(rst),
.tx_data(tx_data),
.tx_data_valid(tx_data_valid),
.tx_data_ready(tx_data_ready),
.tx_pin(tx)
);
endmodule
