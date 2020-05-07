`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/04/28 14:50:37
// Design Name: 
// Module Name: Counter
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


module Counter #
(
parameter   bit_cnt = 29,                     //计数结果位数
parameter   frequency_clk_ref=100            //  参考时钟ocxo频率为100MHz
)
(
input                     rst,                   //复位信号
input                     EN,                   //使能信号
input                     clk_ocxo,             //参考时钟ocxo
input                     ixo1,
input                     ixo2,
input                     ixo3,
input                     ixo4,
input                     ixo5,
input                     itcxo1,
input                     itcxo2,
input                     itcxo3,
input                     itcxo4,
input                     itcxo5,
input                     itcxo6,
input                     itcxo7,
input                     itcxo8,
input                     itcxo9,
input                     itcxo10,
output      reg     [bit_cnt-1:0]             error1,
output      reg     [bit_cnt-1:0]             error2,
output      reg     [bit_cnt-1:0]             error3,
output      reg     [bit_cnt-1:0]             error4,
output      reg     [bit_cnt-1:0]             error5,
output      reg     [bit_cnt-1:0]             error6,
output      reg     [bit_cnt-1:0]             error7,
output      reg     [bit_cnt-1:0]             error8,
output      reg     [bit_cnt-1:0]             error9,
output      reg     [bit_cnt-1:0]             error10,
output      reg     [bit_cnt-1:0]             error11,
output      reg     [bit_cnt-1:0]             error12,
output      reg     [bit_cnt-1:0]             error13,
output      reg     [bit_cnt-1:0]             error14,
output      reg     [bit_cnt-1:0]             error15,
output      reg     [bit_cnt-1:0]             ocxo_cnt,
output      reg     [bit_cnt-1:0]             oxo1,       
output      reg     [bit_cnt-1:0]             oxo2,       
output      reg     [bit_cnt-1:0]             oxo3,       
output      reg     [bit_cnt-1:0]             oxo4,       
output      reg     [bit_cnt-1:0]             oxo5,       
output      reg     [bit_cnt-1:0]             otcxo1,     
output      reg     [bit_cnt-1:0]             otcxo2,     
output      reg     [bit_cnt-1:0]             otcxo3,     
output      reg     [bit_cnt-1:0]             otcxo4,    
output      reg     [bit_cnt-1:0]             otcxo5,     
output      reg     [bit_cnt-1:0]             otcxo6,     
output      reg     [bit_cnt-1:0]             otcxo7,     
output      reg     [bit_cnt-1:0]             otcxo8,     
output      reg     [bit_cnt-1:0]             otcxo9,     
output      reg     [bit_cnt-1:0]             otcxo10    
);

localparam          cycle = 100000000 * frequency_clk_ref;         //参考时钟ocxo的周期
localparam          STATE=2;

localparam          IDLE = 1;
localparam          COUNT = 2;
localparam          STAY = 3;


reg     [STATE:0]   state;
reg     [STATE:0]   next_state;

//OCXO
//三段式状态机
always @ (posedge clk_ocxo or negedge rst)   //OCXO是基准时钟，决定整个系统的状态，所以这里用posedge clk_ocxo
begin
    if(rst == 1'b0)
        state <= IDLE;
    else
        state <= next_state;
end

always @ (*)
begin
    case(state)
        IDLE:
            if(rst==1'b1 && EN==1'b1)
                next_state = COUNT;
            else
                next_state = IDLE;
        COUNT:
            if(rst==1'b1  &&  EN==1'b1 && ocxo_cnt == cycle)
                next_state = STAY;
            else if (rst==1'b0 || EN==1'b0)
                next_state = IDLE;
            else
                next_state = COUNT;
        STAY:
            if(rst==1'b0  ||  EN==1'b0)
                next_state = IDLE;
            else
                next_state = STAY;
    endcase
end

always @ (posedge clk_ocxo or negedge rst)
    begin
        if (!rst) begin
            ocxo_cnt <= 25'b0;
        end
        else begin
            case(next_state)
                IDLE:   ocxo_cnt <= 25'b0;
                COUNT:  ocxo_cnt <= ocxo_cnt + 1'b1;
                STAY:   ocxo_cnt <= ocxo_cnt;
            endcase   
        end
    end

always @ (posedge ixo1 or negedge rst)
    begin
        if (!rst) begin
            oxo1 <= 25'b0;
        end
        else begin
            case(next_state)
            IDLE:   
                begin
                    oxo1 <= 25'b0; error1 <= 8'b0;
                end
            COUNT:  
                begin
                    oxo1 <= oxo1 + 1'b1; error1 <= 8'b0;
                end
            STAY:   
                begin
                    oxo1 <= oxo1;
                    if (oxo1 >= cycle)
                        error1 <= (oxo1 - cycle) * 1000000 / cycle;
                    else
                        error1 <= (cycle - oxo1) * 1000000 / cycle;
                end
            endcase   
        end
    end

always @ (posedge ixo2 or negedge rst)
    begin
        if (!rst) begin
            oxo2 <= 25'b0;
        end
        else begin
            case(next_state)
            IDLE:   
                begin
                    oxo2 <= 25'b0; error2 <= 8'b0;
                end
            COUNT:  
                begin
                    oxo2 <= oxo2 + 1'b1; error2 <= 8'b0;
                end    
            STAY:   
                begin
                oxo2 <= oxo2;
                    if (oxo2 >= cycle)
                        error2 <= (oxo2 - cycle) * 1000000 / cycle;
                    else
                        error2 <= (cycle - oxo2) * 1000000 / cycle;
                end
            endcase   
        end  
    end

always @ (posedge ixo3 or negedge rst)
    begin
        if (!rst) begin
            oxo3 <= 25'b0;
        end
        else begin
            case(next_state)
            IDLE:   
                begin 
                    oxo3 <= 25'b0; error3 <= 8'b0;
                end
            COUNT:  
                begin
                    oxo3 <= oxo3 + 1'b1; error3 <= 8'b0;
                end
            STAY:   
                begin
                oxo3 <= oxo3;
                    if (oxo3 >= cycle)
                        error3 <= (oxo3 - cycle) * 1000000 / cycle;
                    else
                        error3 <= (cycle - oxo3) * 1000000 / cycle;
                end
            endcase   
        end
    end

always @ (posedge ixo4 or negedge rst)
    begin
        if (!rst) begin
            oxo4 <= 25'b0;
        end
        else begin
            case(next_state)
            IDLE:   
                begin
                    oxo4 <= 25'b0; error4 <= 8'b0;
                end  
            COUNT:  
                begin
                    oxo4 <= oxo4 + 1'b1; error4 <= 8'b0;
                end  
            STAY:   
                begin
                oxo4 <= oxo4;
                    if (oxo4 >= cycle)
                        error4 <= (oxo4 - cycle) * 1000000 / cycle;
                    else
                        error4 <= (cycle - oxo4) * 1000000 / cycle;
                end
            endcase   
        end
    end

always @ (posedge ixo5 or negedge rst)
    begin
        if (!rst) begin
            oxo5 <= 25'b0;
        end
        else begin
            case(next_state)
            IDLE:   
                begin
                    oxo5 <= 25'b0; error5 <= 8'b0;
                end   
            COUNT: 
                begin
                    oxo5 <= oxo5 + 1'b1; error5 <= 8'b0;
                end  
            STAY:   
                begin
                oxo5 <= oxo5;
                    if (oxo5 >= cycle)
                        error5 <= (oxo5 - cycle) * 1000000 / cycle;
                    else
                        error5 <= (cycle - oxo5) * 1000000 / cycle;
                end
            endcase   
        end
    end

always @ (posedge itcxo1 or negedge rst)
    begin
        if (!rst) begin
            otcxo1 <= 25'b0;
        end
        else begin
            case(next_state)
            IDLE:   
                begin
                    otcxo1 <= 25'b0; error6 <= 8'b0;
                end       
            COUNT:  
                begin
                    otcxo1 <= otcxo1 + 1'b1; error6 <= 8'b0;
                end       
            STAY:   
                begin
                otcxo1 <= otcxo1;
                    if (otcxo1 >= cycle)
                        error6 <= (otcxo1 - cycle) * 1000000 / cycle;
                    else
                        error6 <= (cycle - otcxo1) * 1000000 / cycle;
                end
            endcase   
        end 
    end

always @ (posedge itcxo2 or negedge rst)
    begin
        if (!rst) begin
            otcxo2 <= 25'b0;
        end
        else begin
            case(next_state)
            IDLE:   
                begin
                    otcxo2 <= 25'b0; error7 <= 8'b0;
                end        
            COUNT:  
                begin
                    otcxo2 <= otcxo2 + 1'b1; error7 <= 8'b0;
                end      
            STAY:   
                begin
                otcxo2 <= otcxo2;
                    if (otcxo2 >= cycle)
                        error7 <= (otcxo2 - cycle) * 1000000 / cycle;
                    else
                        error7 <= (cycle - otcxo2) * 1000000 / cycle;
                end
            endcase   
        end    
    end

always @ (posedge itcxo3 or negedge rst)
    begin
        if (!rst) begin
            otcxo3 <= 25'b0;
        end
        else begin
            case(next_state)
            IDLE:   
                begin
                    otcxo3 <= 25'b0; error8 <= 8'b0;
                end
            COUNT:  
                begin
                    otcxo3 <= otcxo3 + 1'b1; error8 <= 8'b0;
                end  
            STAY:   
                begin
                otcxo3 <= otcxo3;
                    if (otcxo3 >= cycle)
                        error8 <= (otcxo3 - cycle) * 1000000 / cycle;
                    else
                        error8 <= (cycle - otcxo3) * 1000000 / cycle;
                end
            endcase   
        end 
    end

always @ (posedge itcxo4 or negedge rst)
    begin
        if (!rst) begin
            otcxo4 <= 25'b0;
        end
        else begin
            case(next_state)
            IDLE:   
                begin
                    otcxo4 <= 25'b0; error9 <= 8'b0;
                end 
            COUNT:  
                begin
                    otcxo4 <= otcxo4 + 1'b1; error9 <= 8'b0;
                end   
            STAY:   
                begin
                otcxo4 <= otcxo4;
                    if (otcxo4 >= cycle)
                        error9 <= (otcxo4 - cycle) * 1000000 / cycle;
                    else
                        error9 <= (cycle - otcxo4) * 1000000 / cycle;
                end
            endcase   
        end
    end

always @ (posedge itcxo5 or negedge rst)
    begin
        if (!rst) begin
            otcxo5 <= 25'b0;
        end
        else begin
            case(next_state)
            IDLE:   
                begin
                    otcxo5 <= 25'b0; error10 <= 8'b0;
                end
                    
            COUNT:  
                begin
                    otcxo5 <= otcxo5 + 1'b1; error10 <= 8'b0;
                end
            STAY:   
                begin
                otcxo5 <= otcxo5;
                    if (otcxo5 >= cycle)
                        error10 <= (otcxo5 - cycle) * 1000000 / cycle;
                    else
                        error10 <= (cycle - otcxo5) * 1000000 / cycle;
                end
            endcase   
        end
    end

always @ (posedge itcxo6 or negedge rst)
    begin
        if (!rst) begin
            otcxo6 <= 25'b0;
        end
        else begin
            case(next_state)
            IDLE:   
                begin
                    otcxo6 <= 25'b0; error11 <= 8'b0;
                end
            COUNT:  
                begin
                    otcxo6 <= otcxo6 + 1'b1; error11 <= 8'b0;
                end
            STAY:   
                begin
                otcxo6 <= otcxo6;
                    if (otcxo6 >= cycle)
                        error11 <= (otcxo6 - cycle) * 1000000 / cycle;
                    else
                        error11 <= (cycle - otcxo6) * 1000000 / cycle;
                end
            endcase   
        end
    end

always @ (posedge itcxo7 or negedge rst)
    begin
        if (!rst) begin
            otcxo7 <= 25'b0;
        end
        else begin
            case(next_state)
            IDLE:   
                begin
                    otcxo7 <= 25'b0; error12 <= 8'b0;
                end
            COUNT: 
                begin
                     otcxo7 <= otcxo7 + 1'b1; error12 <= 8'b0;
                 end
            STAY:   
                begin
                otcxo7 <= otcxo7;
                    if (otcxo7 >= cycle)
                        error12 <= (otcxo7 - cycle) * 1000000 / cycle;
                    else
                        error12 <= (cycle - otcxo7) * 1000000 / cycle;
                end
            endcase   
        end
    end

always @ (posedge itcxo8 or negedge rst)
    begin
        if (!rst) begin
            otcxo8 <= 25'b0;
        end
        else begin
            case(next_state)
            IDLE:   
            begin
                otcxo8 <= 25'b0; error13 <= 8'b0;
            end
            COUNT:  
            begin
                otcxo8 <= otcxo8 + 1'b1; error13 <= 8'b0;
            end 
            STAY:   
                begin
                otcxo8 <= otcxo8;
                    if (otcxo8 >= cycle)
                        error13 <= (otcxo8 - cycle) * 1000000 / cycle;
                    else
                        error13 <= (cycle - otcxo8) * 1000000 / cycle;
                end
            endcase   
        end
    end

always @ (posedge itcxo9 or negedge rst)
    begin
        if (!rst) begin
            otcxo9 <= 25'b0;
        end
        else begin
            case(next_state)
            IDLE:   
            begin
                otcxo9 <= 25'b0; error14 <= 8'b0;
            end  
            COUNT: 
            begin
                 otcxo9 <= otcxo9 + 1'b1; error14 <= 8'b0;
             end      
            STAY:   
                begin
                otcxo9 <= otcxo9;
                    if (otcxo9 >= cycle)
                        error14 <= (otcxo9 - cycle) * 1000000 / cycle;
                    else
                        error14 <= (cycle - otcxo9) * 1000000 / cycle;
                end
            endcase   
        end
    end

always @ (posedge itcxo10 or negedge rst)
    begin
        if (!rst) begin
            otcxo10 <= 25'b0;
        end
        else begin
            case(next_state)
            IDLE:   
                begin
                    otcxo10 <= 25'b0; error15 <= 8'b0;
                end
            COUNT: 
                begin
                     otcxo10 <= otcxo10 + 1'b1; error15 <= 8'b0;
                 end 
            STAY:   
                begin
                otcxo10 <= otcxo10;
                    if (otcxo10 >= cycle)
                        error15 <= (otcxo10 - cycle) * 1000000 / cycle;
                    else
                        error15 <= (cycle - otcxo10) * 1000000 / cycle;
                end
            endcase   
        end
    end

endmodule
