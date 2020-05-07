`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/05/04 17:44:51
// Design Name: 
// Module Name: test_Complex_Top
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


module test_Complex_Top();
reg     clk;
reg     rst;
reg     EN;
reg     clk1,clk2,clk3,clk4,clk5,clk6,clk7,clk8,clk9,clk10,clk11,clk12,clk13,clk14,clk15;
reg     rx;
wire    tx;

initial 
begin
  #0           clk=1'b0;
               clk1=1'b0;
               clk2=1'b0;
               clk3=1'b0;
               clk4=1'b0;
               clk5=1'b0;
               clk6=1'b0;
               clk7=1'b0;
               clk8=1'b0;
               clk9=1'b0;
               clk10=1'b0;
               clk11=1'b0;
               clk12=1'b0;
               clk13=1'b0;
               clk14=1'b0;
               clk15=1'b0;
               rst = 1'b0;
               EN = 1'b0;
               rx = 1'b0;
               
  #3           rst = 1'b1;
               EN = 1'b1;
  #2000000000   $stop;
end

always #7000 begin
    rx = ~rx;
end

always #5                                 //参�?�时钟的频率�?100MHz
 begin 
   clk = ~clk;
 end

always #4.999900                                 //xo时钟频率5MHz
 begin 
    clk1 = ~clk1;
 end  
 
 always #4.999900                                 //xo时钟频率5MHz
 begin 
    clk2 = ~clk2;
 end  

always #4.999900                                  //xo时钟频率5MHz
 begin 
    clk3 = ~clk3;
 end  
 
 always #4.999900                                  //xo时钟频率5MHz
 begin 
    clk4 = ~clk4;
 end  
 
 always #4.999900                                  //xo时钟频率5MHz
 begin 
    clk5 = ~clk5;
 end  
 
 always #4.999990                                 //tcxo时钟频率5MHz
 begin 
    clk6 = ~clk6;
 end  
 
 always #4.999990                                 //tcxo时钟频率5MHz
 begin 
    clk7 = ~clk7;
 end  
 
 always #4.999990                                 //tcxo时钟频率5MHz
 begin 
    clk8 = ~clk8;
 end  
 
always #4.999990                                   //tcxo时钟频率5MHz
begin 
    clk9 = ~clk9;
 end  
 
 always #4.999990                                 //tcxo时钟频率5MHz
 begin 
    clk10 = ~clk10;
 end  
 
 always #4.999998                                 //xo时钟频率5MHz
 begin 
    clk11 = ~clk11;
 end  
 
 always #4.999998                                  //xo时钟频率5MHz
 begin 
    clk12 = ~clk12;
 end  
 
 always #4.999998                                  //xo时钟频率5MHz
 begin 
    clk13 = ~clk13;
 end  
 
 always #4.999998                                  //xo时钟频率5MHz
 begin 
    clk14 = ~clk14;
 end  
 
 always #4.999998                                  //xo时钟频率5MHz
 begin 
    clk15 = ~clk15;
 end  

Complex_Top #
(
.bit_cnt(29),                     //计数结果位数
.frequency_clk_ref(100),            //  参�?�时钟ocxo频率�?100MHz
.Challenge_Bit(8)
)Complex_Top_inst
(
.clk_ocxo(clk),             //参�?�时�?
.rst(rst),
.EN(EN),
.clk1(clk1),
.clk2(clk2),
.clk3(clk3),
.clk4(clk4),
.clk5(clk5),
.clk6(clk6),
.clk7(clk7),
.clk8(clk8),
.clk9(clk9),
.clk10(clk10),
.clk11(clk11),
.clk12(clk12),
.clk13(clk13),
.clk14(clk14),
.clk15(clk15),
.rx(rx),
.tx(tx)
);
endmodule
