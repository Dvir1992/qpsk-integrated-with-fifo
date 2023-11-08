/*
//////////////////////////////////////////////////////////////////////
Module name:            full_design
Description:  This module connects between the qpsk module and fifo module. The data moves between the qpsk to the fifo.
//////////////////////////////////////////////////////////////////////
*/
module full_design (
input clk, // Clock 
input reset, // Reset 
input signed [7:0] sym_i, // Symbol input I value (scaled to 0-255) 
input signed [7:0] sym_q, // Symbol inpit Q value (scaled to 0-255) 
input iq_valid , // I,Q symbol inputs are valid 
input read_en,
output empty, // demapped data out 'character' (for every 4 //symbols) 
output full,// data out valid 
output [7:0] data_out
);

 wire [7:0] data; 
 wire data_valid; 

qpsk qpsk_(
	.clk(clk),
	.reset(reset),
	.sym_i(sym_i),
	.sym_q(sym_q),
	.iq_valid(iq_valid),
	.data(data),
	.data_valid(data_valid)
	);
	
fifo fifo_(
	.clk(clk),
	.reset(reset),
	.read_en(read_en),
	.write_en(data_valid),
	.data_in(data),
	.empty(empty),
	.full(full),
	.data_out(data_out)
	);
	
endmodule
	
