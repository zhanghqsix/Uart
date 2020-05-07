`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/12/13 09:03:21
// Design Name: 
// Module Name: UART_TX
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


module modify_Uart_tx #
(
	parameter Challenge_Bit = 8,
	parameter frequency_clk_ref = 50,      //clock frequency(Mhz)
	parameter BAUD_RATE = 115200 //serial baud rate
)
(
	input                                  clk,              //clock input
	input                                  n_reset,          //asynchronous reset input, low active 
	input      [Challenge_Bit - 1:0]       tx_data,          //data to send                                   //并行输入数据tx_data
	input                                  tx_data_valid,    //data to be sent is valid                       //tx_data_valid和tx_data_ready均为控制信号
	output     reg                         tx_data_ready,    //send ready
	output                                 tx_pin,           //serial data output                             //串行输出数据tx_pin
	output	   reg						   tx_data_ready_flag
);

//calculates the clock cycle for baud rate 
localparam                                 CYCLE = frequency_clk_ref * 1000000 / BAUD_RATE;
//state machine code
localparam                                 STATE        = 2;
localparam                                 S_IDLE       = 1;
localparam                                 S_START      = 2;//start bit
localparam                                 S_SEND_BYTE  = 3;//data bits
localparam                                 S_STOP       = 4;//stop bit

reg             [            STATE:0]       state;
reg             [            STATE:0]       next_state;
reg             [               15:0]       cycle_cnt; //baud counter
reg             [                4:0]       bit_cnt;//bit counter
reg             [Challenge_Bit - 1:0]       tx_data_latch; //latch data to send
reg                                         tx_reg; //serial data output

assign tx_pin = tx_reg;

always @ (posedge clk or negedge n_reset)
begin
	if(n_reset == 1'b0)
		state <= S_IDLE;
	else
		state <= next_state;
end

always @ (*)
begin
	case(state)
		S_IDLE:
			if(tx_data_valid == 1'b1)
				next_state = S_START;
			else
				next_state = S_IDLE;
		S_START:
			if(cycle_cnt == CYCLE)
				next_state = S_SEND_BYTE;
			else
				next_state = S_START;
		S_SEND_BYTE:
			if(cycle_cnt == CYCLE  && bit_cnt == 5'd8)
				next_state = S_STOP;
			else
				next_state = S_SEND_BYTE;
		S_STOP:
			if(cycle_cnt == CYCLE)
				next_state = S_IDLE;
			else
				next_state = S_STOP;
		default:
			next_state = S_IDLE;
	endcase
end

always @ (posedge clk or negedge n_reset) begin
	if (!n_reset) begin
		tx_data_ready <= 1'b0;
		tx_data_ready_flag <= 1'b0;
		tx_data_latch <= #Challenge_Bit'b0;
		bit_cnt <= 5'b0;
		cycle_cnt <= 16'b0;
		tx_reg <= 1'b1;
	end
	else begin
		case(next_state)
		S_IDLE:	begin
			bit_cnt <= 5'b0;
			cycle_cnt <= 16'b0;
			tx_reg <= 1'b1;
			tx_data_ready <= 1'b0;
			tx_data_ready_flag <= 1'b0;
			tx_data_latch <= #Challenge_Bit'b0;
		end
		S_START:	begin
			tx_reg <= 1'b0;
			tx_data_ready <= 1'b1;
			tx_data_ready_flag <= 1'b0;
			tx_data_latch <= tx_data;
			if (cycle_cnt < CYCLE) begin
				cycle_cnt <= cycle_cnt + 1'b1;
				bit_cnt <= bit_cnt;
			end
			else begin
				cycle_cnt <= 16'b0;
				bit_cnt <= bit_cnt + 1'b1;
			end
		end	
		S_SEND_BYTE:	begin
			begin
				if (bit_cnt == 5'd0) begin
					tx_reg <= tx_data_latch[bit_cnt];
				end
				else begin
					tx_reg <= tx_data_latch[bit_cnt -1];
				end
			end
			tx_data_ready <= 1'b1;
			tx_data_ready_flag <= 1'b0;
			if (cycle_cnt < CYCLE) begin
				cycle_cnt <= cycle_cnt + 1'b1;
				bit_cnt <= bit_cnt;
			end
			else begin
				cycle_cnt <= 16'b0;
				bit_cnt <= bit_cnt + 1'b1;
			end
		end
		S_STOP:	begin
			begin
				if (cycle_cnt == CYCLE -1 && bit_cnt == 5'd9) begin
					tx_data_ready_flag <= 1'b1;
				end
			end
			tx_reg <= 1'b1;
			if (cycle_cnt < CYCLE) begin
				cycle_cnt <= cycle_cnt + 1'b1;
				bit_cnt <= bit_cnt;
				tx_data_ready <= 1'b1;
			end
			else if (cycle_cnt == CYCLE && bit_cnt == 5'd9) begin
				tx_data_ready <= 1'b0;
				tx_data_ready_flag <= 1'b0;
			end
			else begin
				cycle_cnt <= 16'b0;
				bit_cnt <= bit_cnt + 1'b1;
			end
		end
		default:	begin
			tx_data_ready <= 1'b0;
			tx_data_ready_flag <= 1'b0;
			tx_data_latch <= #Challenge_Bit'b0;
			bit_cnt <= 5'b0;
			cycle_cnt <= 16'b0;
			tx_reg <= 1'b1;
		end
		endcase
	end
end

endmodule