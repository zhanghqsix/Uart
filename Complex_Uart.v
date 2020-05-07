`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/05/04 08:34:40
// Design Name: 
// Module Name: Complex_Uart
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


module Complex_Uart #
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
    output       	                uart_tx
);

localparam							STATE = 2;
localparam							SYSTEM_IDLE = 0;
localparam 							SYSTEM_SEND = 1;
localparam 							SYSTEM_WAIT = 2;
localparam 							SYSTEM_PAUSE = 3;

reg     [Challenge_Bit - 1:0]       tx_data;
reg     [Challenge_Bit - 1:0]       tx_string;

reg                                 tx_data_valid;
wire                                tx_data_ready;
wire							    tx_data_ready_flag;

reg     [Challenge_Bit - 1:0]       tx_cnt;
reg     [               32:0]       wait_cnt;

wire    [Challenge_Bit - 1:0]       rx_data;
wire                                rx_data_valid;

reg     [            STATE:0]       state;
reg 	[			 STATE:0]		next_state;


always @(posedge clk or n_reset) begin
	if (!n_reset) begin
		state <= SYSTEM_IDLE;
	end
	else begin
		state <= next_state;
	end
end

always @(*) begin
	if (!n_reset) begin
		next_state = SYSTEM_IDLE;
	end
	else begin
		case(state)
		SYSTEM_IDLE:
			next_state = SYSTEM_SEND;
		SYSTEM_SEND:	begin
			if ( rx_data == 8'b1) begin
				next_state = SYSTEM_PAUSE;
			end
			else if (tx_cnt == 8'd15 && tx_data_ready_flag) begin
				next_state = SYSTEM_WAIT;
			end
			else begin
				next_state = SYSTEM_SEND;
			end
		end			
		SYSTEM_WAIT:	begin
			if (wait_cnt == frequency_clk_ref * 1000) begin
				next_state = SYSTEM_SEND;
			end
			else begin
				next_state = SYSTEM_WAIT;
			end
		end
		SYSTEM_PAUSE:	begin
			if (rx_data != 8'b1) begin
				next_state = SYSTEM_SEND;
			end
			else begin
				next_state = SYSTEM_PAUSE;
			end
		end
	   endcase
	end
end
always @(posedge clk or negedge n_reset) begin
	if (!n_reset) begin
		tx_data <= #Challenge_Bit'b0;
		tx_string <= #Challenge_Bit'b0;
		tx_data_valid <= 1'b0;
		tx_cnt <= #Challenge_Bit'b0;
		wait_cnt <= 33'b0;
	end
	else begin
		case(next_state)
			SYSTEM_IDLE:	begin
				tx_data <= #Challenge_Bit'b0;
				tx_string <= #Challenge_Bit'b0;
				tx_data_valid <= 1'b0;
				tx_cnt <= #Challenge_Bit'b0;
				wait_cnt <= 33'b0;
			end
			SYSTEM_SEND:	begin
				tx_data <= tx_string;
				tx_data_valid <= rx_data_valid;
				wait_cnt <= 33'b0;
				if (tx_data_ready_flag == 1'b1 && tx_cnt < 8'd15) begin
					tx_cnt <= tx_cnt + 1'b1;
				end
				case(tx_cnt)
					8'd0: tx_string <= error1;
					8'd1: tx_string <= error2;
					8'd2: tx_string <= error3;
					8'd3: tx_string <= error4;
					8'd4: tx_string <= error5;
					8'd5: tx_string <= error6;
					8'd6: tx_string <= error7;
					8'd7: tx_string <= error8;
					8'd8: tx_string <= error9;
					8'd9: tx_string <= error10;
					8'd10: tx_string <= error11;
					8'd11: tx_string <= error12;
					8'd12: tx_string <= error13;
					8'd13: tx_string <= error14;
					8'd14: tx_string <= error15;
				endcase
			end
			SYSTEM_WAIT:	begin
				tx_string <= #Challenge_Bit'b0;
				tx_data <= rx_data;
				wait_cnt <= wait_cnt + 1'b1;
				tx_cnt <= #Challenge_Bit'b0;
				tx_data_valid <= 1'b0;
			end
			SYSTEM_PAUSE:	begin
				tx_string <= #Challenge_Bit'b0;
				tx_data <= #Challenge_Bit'b0;
				tx_data_valid <= 1'b0;
				tx_cnt <= tx_cnt;
				wait_cnt <= 33'b0;
			end
			default:	begin
				tx_data <= #Challenge_Bit'b0;
				tx_string <= #Challenge_Bit'b0;
				tx_data_valid <= 1'b0;
				tx_cnt <= #Challenge_Bit'b0;
				wait_cnt <= 33'b0;
			end
		endcase
	end
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
	.tx_pin                     (uart_tx                  ),
	.tx_data_ready_flag         (tx_data_ready_flag       )
);

endmodule
