/*
//////////////////////////////////////////////////////////////////////
Module name:            qpsk
Description:  Quadrature Phase Shift Keying (QPSK) is a form of Phase Shift Keying in which two bits are modulated at once, 
selecting one of four possible carrier phase shifts (0, 90, 180, or 270 degrees).
//////////////////////////////////////////////////////////////////////
*/
module qpsk (
input clk, // Clock 
input reset, // Reset 
input signed [7:0] sym_i, // Symbol input I value (scaled to 0-255) 
input signed [7:0] sym_q, // Symbol inpit Q value (scaled to 0-255) 
input iq_valid , // I,Q symbol inputs are valid 
output reg [7:0] data, // demapped data out 'character' (for every 4 //symbols) 
output reg data_valid // data out valid );
);

reg [3:0] symb_counter;
reg [3:0] last_symb_counter;
reg [7:0] changed_data;
wire [15:0] sel;



always@ (posedge clk) begin
	if(reset)begin
		changed_data<=0;
		symb_counter<=0;
		last_symb_counter<=0;
	end
	else if(iq_valid)begin
		case(sel)
			16'h4040: changed_data[symb_counter+:2]<=2'b11;
			16'h40C0: changed_data[symb_counter+:2]<=2'b10;
			16'hC040: changed_data[symb_counter+:2]<=2'b01;
			16'hC0C0: changed_data[symb_counter+:2]<=2'b00;
			default:  changed_data<=0;
		endcase	
		symb_counter<=(symb_counter+2)%8;	
	end	
	last_symb_counter<=symb_counter;
				
end


always@(posedge clk) begin
	if (reset) begin
		data_valid<=0;
		data<=0;
	end
	else if((symb_counter%8==0)&&(changed_data>0)&&(symb_counter!=last_symb_counter))begin
			data_valid<=1;
			data<=changed_data;
		end	
	if(data_valid)
		data_valid<=0;
end


assign sel={sym_q,sym_i};

endmodule 