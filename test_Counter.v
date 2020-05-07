`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/04/28 19:52:14
// Design Name: 
// Module Name: test_Counter
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


module test_Counter();
reg           rst;
reg           EN;
reg           clk_ref;
reg           clk_xo1;
reg           clk_xo2;
reg           clk_xo3;
reg           clk_xo4;
reg           clk_xo5;
reg           clk_xo6;
reg           clk_xo7;
reg           clk_xo8;
reg           clk_xo9;
reg           clk_xo10;
reg           clk_xo11;
reg           clk_xo12;
reg           clk_xo13;
reg           clk_xo14;
reg           clk_xo15;

wire    [24:0]  Q;
wire    [24:0]  Q1,     error1;
wire    [24:0]  Q2,     error2;
wire    [24:0]  Q3,     error3;
wire    [24:0]  Q4,     error4;
wire    [24:0]  Q5,     error5;
wire    [24:0]  Q6,     error6;
wire    [24:0]  Q7,     error7;
wire    [24:0]  Q8,     error8;
wire    [24:0]  Q9,     error9;
wire    [24:0]  Q10,    error10;
wire    [24:0]  Q11,    error11;
wire    [24:0]  Q12,    error12;
wire    [24:0]  Q13,    error13;
wire    [24:0]  Q14,    error14;
wire    [24:0]  Q15,    error15;  

initial 
begin
  #0           clk_ref=1'b0;
               clk_xo1=1'b0;
               clk_xo2=1'b0;
               clk_xo3=1'b0;
               clk_xo4=1'b0;
               clk_xo5=1'b0;
               clk_xo6=1'b0;
               clk_xo7=1'b0;
               clk_xo8=1'b0;
               clk_xo9=1'b0;
               clk_xo10=1'b0;
               clk_xo11=1'b0;
               clk_xo12=1'b0;
               clk_xo13=1'b0;
               clk_xo14=1'b0;
               clk_xo15=1'b0;
               rst = 1'b0;
               EN = 1'b0;
               
  #3           rst = 1'b1;
               EN = 1'b1;
  #150000  $stop;
end

always #31.25                                 
 begin 
   clk_ref = ~clk_ref;
 end

always #31.249375                                 
 begin 
    clk_xo1 = ~clk_xo1;
 end  
 
 always #31.249375                                 
 begin 
    clk_xo2 = ~clk_xo2;
 end  

always #31.249375                                  
 begin 
    clk_xo3 = ~clk_xo3;
 end  
 
 always #31.249375                                  
 begin 
    clk_xo4 = ~clk_xo4;
 end  
 
 always #31.249375                                  
 begin 
    clk_xo5 = ~clk_xo5;
 end  
 
 always #31.249938                                 
 begin 
    clk_xo6 = ~clk_xo6;
 end  
 
 always #31.249938                                 
 begin 
    clk_xo7 = ~clk_xo7;
 end  
 
 always #31.249938                                 
 begin 
    clk_xo8 = ~clk_xo8;
 end  
 
always #31.249938                                   
begin 
    clk_xo9 = ~clk_xo9;
 end  
 
 always #31.249938                                 
 begin 
    clk_xo10 = ~clk_xo10;
 end  
 
 always #31.249984                                 
 begin 
    clk_xo11 = ~clk_xo11;
 end  
 
 always #31.249984                                 
 begin 
    clk_xo12 = ~clk_xo12;
 end  
 
 always #31.249984                                 
 begin 
    clk_xo13 = ~clk_xo13;
 end  
 
 always #31.249984                                 
 begin 
    clk_xo14 = ~clk_xo14;
 end  
 
 always #31.249984                                 
 begin 
    clk_xo15 = ~clk_xo15;
 end  
 
 
Counter #
(
    .bit_cnt(25),
    .frequency_clk_ref(16)
)
Counter_inst
(
    .EN(EN),
    .rst(rst), 
    .clk_ocxo(clk_ref), 
    .ixo1(clk_xo1), 
    .ixo2(clk_xo2),
    .ixo3(clk_xo3),
    .ixo4(clk_xo4),
    .ixo5(clk_xo5),
    .itcxo1(clk_xo6),
    .itcxo2(clk_xo7),
    .itcxo3(clk_xo8),
    .itcxo4(clk_xo9),
    .itcxo5(clk_xo10),
    .itcxo6(clk_xo11),
    .itcxo7(clk_xo12),
    .itcxo8(clk_xo13),
    .itcxo9(clk_xo14),
    .itcxo10(clk_xo15),
    .ocxo_cnt(Q),
    .oxo1(Q1),
    .oxo2(Q2),
    .oxo3(Q3),
    .oxo4(Q4),
    .oxo5(Q5),
    .otcxo1(Q6),
    .otcxo2(Q7),
    .otcxo3(Q8),
    .otcxo4(Q9),
    .otcxo5(Q10),
    .otcxo6(Q11),
    .otcxo7(Q12),
    .otcxo8(Q13),
    .otcxo9(Q14),
    .otcxo10(Q15),
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
endmodule
