`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/05/04 17:30:15
// Design Name: 
// Module Name: Complex_Top
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


module Complex_Top #(
	parameter   bit_cnt = 29,                    
	parameter   frequency_clk_ref=100,            
	parameter   Challenge_Bit = 8
    )
(
input   clk_ocxo,           
input   rst,
input   EN,
input   clk1,clk2,clk3,clk4,clk5,clk6,clk7,clk8,clk9,clk10,clk11,clk12,clk13,clk14,clk15,
input   rx,
output  tx
);
wire     [Challenge_Bit-1:0]             error1;
wire     [Challenge_Bit-1:0]             error2;
wire     [Challenge_Bit-1:0]             error3;
wire     [Challenge_Bit-1:0]             error4;
wire     [Challenge_Bit-1:0]             error5;
wire     [Challenge_Bit-1:0]             error6;
wire     [Challenge_Bit-1:0]             error7;
wire     [Challenge_Bit-1:0]             error8;
wire     [Challenge_Bit-1:0]             error9;
wire     [Challenge_Bit-1:0]             error10;
wire     [Challenge_Bit-1:0]             error11;
wire     [Challenge_Bit-1:0]             error12;
wire     [Challenge_Bit-1:0]             error13;
wire     [Challenge_Bit-1:0]             error14;
wire     [Challenge_Bit-1:0]             error15;

Counter   #
(
.bit_cnt(bit_cnt),
.frequency_clk_ref(frequency_clk_ref)
)Counter_inst
(
.rst(rst),  
.EN(EN),                
.clk_ocxo(clk_ocxo),  
.ixo1(clk1),
.ixo2(clk2),
.ixo3(clk3),
.ixo4(clk4),
.ixo5(clk5),
.itcxo1(clk6),
.itcxo2(clk7),
.itcxo3(clk8),
.itcxo4(clk9),
.itcxo5(clk10),
.itcxo6(clk11),
.itcxo7(clk12),
.itcxo8(clk13),
.itcxo9(clk14),
.itcxo10(clk15),
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
.error15(error15)
);
Complex_Uart #
(
.Challenge_Bit(Challenge_Bit),
.frequency_clk_ref(frequency_clk_ref)
)Complex_Uart_inst
(
.clk(clk_ocxo),
.n_reset(rst),
.uart_rx(rx),
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
.uart_tx(tx)
);
endmodule
