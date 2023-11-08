/*
//////////////////////////////////////////////////////////////////////
Module name:            fifo
Description:  gets data inside a data memory when writing is ok. send data out of the data memory when read is ok.
//////////////////////////////////////////////////////////////////////
*/

module fifo #(parameter FIFO_DEPTH=16 , FIFO_WIDTH=8) (

  input clk,       // Clock
  input reset,     // Reset

  input read_en,   // Read enable 
  input write_en,  // Write enable
  
  input [FIFO_WIDTH-1:0] data_in,             // FIFO Input Data                
  
  output      empty,                          // FIFO empty indication
  output      full,                           // FIFO full indication
  output reg  [FIFO_WIDTH-1:0] data_out       // FIFO Output Data 
  
);

localparam PTR_WIDTH = $clog2(FIFO_DEPTH); // the number of pointer bits needed for FIFO_DEPTH
   
reg [FIFO_WIDTH-1:0]  memory  [FIFO_DEPTH-1:0];

reg [PTR_WIDTH-1:0]  write_ptr; 
reg [PTR_WIDTH-1:0]  read_ptr;

wire [PTR_WIDTH-1:0] write_ptr_next ;  // Write pointer next cycle value
wire [PTR_WIDTH-1:0] read_ptr_next ;   // Read pointer next cycle value

wire write_ok ; // Ok to Write
wire read_ok ;  // Ok to Read

always @( posedge clk or posedge reset)
  if(reset) begin
    write_ptr  <= 0 ;
    read_ptr   <= 0 ;
  end else begin
    write_ptr <= write_ptr_next ;
    read_ptr  <= read_ptr_next ; 
  end

assign write_ok = write_en & !full ;
assign read_ok  = read_en & !empty ;

// Writing data to the FIFO Memory
always @(posedge clk)             
 if (write_ok) memory[write_ptr] <=  data_in;
 
// Reading data from the FIFO Memory
always @ (posedge clk)       
 if (read_ok) data_out <= memory[read_ptr] ; 

// Calculate next pointer and full,empty status 
    
assign write_ptr_next = write_ok ? ((write_ptr+1) % FIFO_DEPTH) : write_ptr ; // Advance and wrap around upon write
assign read_ptr_next  = read_ok  ? ((read_ptr+1)  % FIFO_DEPTH) : read_ptr ;  // Advance and wrap around upon read

assign empty  = (read_ptr == write_ptr) ;  // FIFO empty condition
assign full  =  (write_ptr+1)%FIFO_DEPTH == read_ptr ; // FIFO full condition (Notice we sacrifice a single entry for full/empty simplicity)

   
  
endmodule



