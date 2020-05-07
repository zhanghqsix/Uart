`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/12/13 09:02:37
// Design Name: 
// Module Name: UART
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


module modify_Uart #
(
    parameter Challenge_Bit = 8,
    parameter frequency_clk_ref = 100
)
(
    input                           clk,
    input                           n_reset,
    input                           uart_rx,
    input   [Challenge_Bit - 1:0]   error1,
    input   [Challenge_Bit - 1:0]   error2,
    input   [Challenge_Bit - 1:0]   error3,
    input   [Challenge_Bit - 1:0]   error4,
    input   [Challenge_Bit - 1:0]   error5,
    input   [Challenge_Bit - 1:0]   error6,
    input   [Challenge_Bit - 1:0]   error7,
    input   [Challenge_Bit - 1:0]   error8,
    input   [Challenge_Bit - 1:0]   error9,
    input   [Challenge_Bit - 1:0]   error10,
    input   [Challenge_Bit - 1:0]   error11,
    input   [Challenge_Bit - 1:0]   error12,
    input   [Challenge_Bit - 1:0]   error13,
    input   [Challenge_Bit - 1:0]   error14,
    input   [Challenge_Bit - 1:0]   error15,
    output                          uart_tx
);

localparam                          STATE = 3;
localparam                          IDLE =  0;
localparam                          SEND =  1;   
localparam                          WAIT =  2;   

reg     [Challenge_Bit - 1:0]       tx_data;
reg     [Challenge_Bit - 1:0]       tx_str;
reg                                 tx_data_valid;
wire                                tx_data_ready;
reg     [Challenge_Bit - 1:0]       tx_cnt;
wire    [Challenge_Bit - 1:0]       rx_data;
wire                                rx_data_valid;
wire                                rx_data_ready;
reg     [               32:0]       wait_cnt;
reg     [            STATE:0]       state;
reg 	[			 STATE:0]		next_state;

assign rx_data_ready = 1'b1;//always can receive data,
							//if HELLO ALINX\r\n is being sent, the received data is discarded

always @(posedge clk or posedge n_reset) begin
	if (!n_reset) begin
		state <= IDLE;	
	end
	else begin
		state <= next_state;
	end
end

always @(*) begin
	case(state)
		IDLE:	begin
			if (n_reset) begin
				next_state = SEND;
			end
			else begin
				next_state = IDLE;
			end
		end
		SEND:	begin
			if (!n_reset) begin
				next_state = IDLE;
			end
			else if (tx_data_valid && tx_data_ready && tx_cnt >= 8'd15) begin
				next_state = WAIT;
			end
			else begin
				next_state = SEND;
			end
		end
		WAIT:	begin
			if (!n_reset) begin
				next_state = IDLE;
			end
			else if (wait_cnt >= frequency_clk_ref * 100000) begin
				next_state = SEND;
			end
			else begin
				next_state = WAIT;
			end
		end
		default: begin
			next_state = IDLE;
		end
	endcase
end

always @(posedge clk or n_reset) begin
	if (!n_reset) begin
		wait_cnt <= 8'd0;
		tx_data <= 8'd0;
		tx_cnt <= 8'd0;
		tx_data_valid <= 1'b0;  
	end
	else begin
		case(next_state)
			IDLE:	begin
				wait_cnt <= 8'd0;
				tx_data <= 8'd0;
				tx_cnt <= 8'd0;
				tx_data_valid <= 1'b0;
			end
			SEND:	begin
				wait_cnt <= 8'd0;
				tx_data <= tx_str;
				if (tx_data_valid && tx_data_ready && tx_cnt < 8'd15) begin
					tx_cnt <= tx_cnt + 1'b1;
				end
				else if (tx_data_valid && tx_data_ready) begin
					tx_data_valid <= 1'b0;
					tx_cnt <= 1'b0;
				end
				else if (!tx_data_valid) begin
					tx_data_valid <= 1'b1;
				end
			end
			WAIT:	begin
				wait_cnt <= wait_cnt + 1'b1;
				if(rx_data_valid == 1'b1)	begin
					tx_data_valid <= 1'b1;
					tx_data <= rx_data;   // send uart received data
				end
				else if(tx_data_valid && tx_data_ready)	begin
					tx_data_valid <= 1'b0;
				end
			end
			default:	begin
				wait_cnt <= 8'd0;
				tx_data <= 8'd0;
				tx_cnt <= 8'd0;
				tx_data_valid <= 1'b0;
			end
			endcase
	end
end

always @ (*)
begin
	case(tx_cnt)
		8'd1 :  tx_str = error1;
		8'd2 :  tx_str = error2;
		8'd3 :  tx_str = error3;
		8'd4 :  tx_str = error4;
		8'd5 :  tx_str = error5;
		8'd6 :  tx_str = error6;
		8'd7 :  tx_str = error7;
		8'd8 :  tx_str = error8;
		8'd9 :  tx_str = error9;
		8'd10:  tx_str = error10;
		8'd11:  tx_str = error11;
		8'd12:  tx_str = error12;
		8'd13:  tx_str = error13;
		8'd14:  tx_str = error14;
		8'd15:  tx_str = error15;
		default:tx_str = 8'd0;
	endcase
end

modify_Uart_rx #
(
	.frequency_clk_ref(frequency_clk_ref),
	.BAUD_RATE(115200)
) modify_Uart_rx_inst
(
	.clk                        (clk                      ),
	.n_reset                    (n_reset                  ),
	.rx_data                    (rx_data                  ),
	.rx_data_valid              (rx_data_valid            ),
	.rx_data_ready              (rx_data_ready            ),
	.rx_pin                     (uart_rx                  )
);

modify_Uart_tx #
(
	.frequency_clk_ref(frequency_clk_ref),
	.BAUD_RATE(115200)
) modify_Uart_tx_inst
(
	.clk                        (clk                      ),
	.n_reset                    (n_reset                  ),
	.tx_data                    (tx_data                  ),
	.tx_data_valid              (tx_data_valid            ),
	.tx_data_ready              (tx_data_ready            ),
	.tx_pin                     (uart_tx                  )
);

endmodule
