`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/12/13 09:03:47
// Design Name: 
// Module Name: UART_RX
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


module modify_Uart_rx #
(
    parameter Challenge_Bit = 8,
	parameter frequency_clk_ref = 100,      //clock frequency(Mhz)
	parameter BAUD_RATE = 115200 //serial baud rate
)
(
	input                                      clk,              //clock input
	input                                      n_reset,            //asynchronous reset input, low active 
	output     reg     [Challenge_Bit - 1:0]   rx_data,          //received serial data
	output     reg                             rx_data_valid,    //received serial data is valid    
	input                                      rx_pin            //serial data input
);
//calculates the clock cycle for baud rate 
localparam                                      CYCLE = frequency_clk_ref * 1000000 / BAUD_RATE; 
//state machine code
localparam                                      STATE       = 2;
localparam                                      S_IDLE      = 1;
localparam                                      S_START     = 2; //start bit
localparam                                      S_REC_BYTE  = 3; //data bits
localparam                                      S_STOP      = 4; //stop bit
localparam                                      S_DATA      = 5;

reg             [            STATE:0]           state;
reg             [            STATE:0]           next_state;
reg                                             rx_d0;            //delay 1 clock for rx_pin
reg                                             rx_d1;            //delay 1 clock for rx_d0
wire                                            rx_negedge;       //negedge of rx_pin
reg             [Challenge_Bit - 1:0]           rx_bits;          //temporary storage of received data
reg             [               15:0]           cycle_cnt;        //baud counter    
reg             [                4:0]           bit_cnt;          //bit counter
reg 											rx_data_ready;	  //data receiver module ready

always @ (posedge clk or negedge n_reset)
begin
	if(n_reset == 1'b0)
		state <= S_IDLE;
	else
		state <= next_state;
end

assign rx_negedge = rx_d1 && ~rx_d0;                         //The processing for rx_pin

always @ (posedge clk or negedge n_reset)              
begin
	if(n_reset == 1'b0)
	begin
		rx_d0 <= 1'b0;
		rx_d1 <= 1'b0;	
	end
	else
	begin
		rx_d0 <= rx_pin;
		rx_d1 <= rx_d0;           
	end
end

always @ (*)
begin
	case(state)
		S_IDLE:
			if(rx_negedge)
				next_state = S_START;
			else
				next_state = S_IDLE;
		S_START:
			if(cycle_cnt == CYCLE)//one data cycle 
				next_state = S_REC_BYTE;
			else
				next_state = S_START;
		S_REC_BYTE:
			if(cycle_cnt == CYCLE  && bit_cnt == 5'd8)  //receive 8bit data
				next_state = S_STOP;
			else
				next_state = S_REC_BYTE;
		S_STOP:
			if(cycle_cnt == CYCLE/2 - 1)//half bit cycle,to avoid missing the next byte receiver
				next_state = S_DATA;
			else
				next_state = S_STOP;
		S_DATA:
			if(!rx_data_ready)    //data receive complete
				next_state = S_IDLE;
			else
				next_state = S_DATA;
		default:
			next_state = S_IDLE;
	endcase
end

always @(posedge clk or negedge n_reset) begin
	if (!n_reset) begin
		rx_data_valid <= 1'b0;
		rx_data_ready <= 1'b0;
		rx_data <= #Challenge_Bit'd0;
		bit_cnt <= 5'b0;
		cycle_cnt <= 16'b0;
		rx_bits <= #Challenge_Bit'd0;
	end
	else begin
		case(next_state)
			S_IDLE:	begin
				rx_data <= #Challenge_Bit'd0;
				bit_cnt <= 5'b0;
				cycle_cnt <= 16'b0;
				rx_bits <= #Challenge_Bit'd0;
                rx_data_valid <= 1'b0;
		        rx_data_ready <= 1'b0;
			end
			S_START:	begin
				rx_data <= #Challenge_Bit'd0;
				rx_bits <= #Challenge_Bit'd0;
				rx_data_valid <= 1'b0;
				rx_data_ready <= 1'b1;
				if (cycle_cnt < CYCLE) begin
					cycle_cnt <= cycle_cnt + 1'b1;
					bit_cnt <= bit_cnt;
				end
				else begin
					cycle_cnt <= 16'b0;
					bit_cnt <= bit_cnt + 1'b1;
				end
			end
			S_REC_BYTE:	begin
				rx_data_valid <= 1'b0;
				rx_data_ready <= 1'b1;
				if (cycle_cnt < CYCLE) begin
						cycle_cnt <= cycle_cnt +1'b1;
						bit_cnt <= bit_cnt;
						if (cycle_cnt == CYCLE /2 -1) begin
							rx_bits[bit_cnt-1] <= rx_pin;
						end
						else begin
							rx_bits <= rx_bits;
						end
				end
				else begin
					cycle_cnt <= 16'b0;
					bit_cnt <= bit_cnt + 1'b1;
				end
			end
			S_STOP:	begin
				if (cycle_cnt < CYCLE/2 -1) begin
					cycle_cnt <= cycle_cnt +1'b1;
					bit_cnt <= bit_cnt;
				end
				else begin
					cycle_cnt <= 16'b0;
					bit_cnt <= bit_cnt + 1'b1;
					rx_data_valid <= 1'b1;
					rx_data_ready <= 1'b0;
					rx_data <= rx_bits;
				end
			end
			S_DATA:	begin
				if (rx_data_ready == 1'b0) begin
					rx_data_valid <= 1'b0;
				end
				else begin
					rx_data_valid <= 1'b1;
				end
			end		
			default:	begin
				rx_data_valid <= 1'b0;
				rx_data <= #Challenge_Bit'd0;
				bit_cnt <= 5'b0;
				cycle_cnt <= 16'b0;
				rx_bits <= #Challenge_Bit'd0;
			end
		endcase
	end
end
endmodule
