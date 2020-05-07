`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/05/02 09:30:24
// Design Name: 
// Module Name: test_modify_Uart
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


module test_modify_UART ();
reg     rst;
reg     clk;
reg     uart_rx;
reg      [7:0]   error1;
reg      [7:0]   error2;
reg      [7:0]   error3;
reg      [7:0]   error4;
reg      [7:0]   error5;
reg      [7:0]   error6;
reg      [7:0]   error7;
reg      [7:0]   error8;
reg      [7:0]   error9;
reg      [7:0]   error10;
reg      [7:0]   error11;
reg      [7:0]   error12;
reg      [7:0]   error13;
reg      [7:0]   error14;
reg      [7:0]   error15;
wire             uart_tx;

initial
begin
    #0      error1=8'd1;
            error2=8'd2;
            error3=8'd3;
            error4=8'd4;
            error5=8'd5;
            error6=8'd6;
            error7=8'd7;
            error8=8'd8;
            error9=8'd9;
            error10=8'd10;
            error11=8'd11;
            error12=8'd12;
            error13=8'd13;
            error14=8'd14;
            error15=8'd15;
            rst=1'b0;
            clk=1'b0;
            uart_rx=1'b0;
    #300      rst=1'b1;
end

always #31.25
    begin
        clk = ~clk;
end

always #7000
    begin
        uart_rx = ~uart_rx;
    end

modify_Uart #
(
.Challenge_Bit(8),
.CLK_FRE(16)
)
modify_Uart_inst
(
.clk(clk),
.n_reset(rst),
.uart_rx(uart_rx),
.error1(error1),
.error2(error2),
.error3(error3),
.error4(error4),
.error5(error5),
.error6(error6),
.error7(error7),
.error8(error8),
.error9(error9),
.error10(error10),
.error11(error11),
.error12(error12),
.error13(error13),
.error14(error14),
.error15(error15),
.uart_tx(uart_tx)
);
endmodule
