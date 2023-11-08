/*
//////////////////////////////////////////////////////////////////////
Module name:            tb
Description:  Tb for the qpsk and fifo (the full design module). The testbench send the data message to the qpsk every 3 clock cycles on an average
and fetched out of the fifo on average every 2 cycles.
When message is done, tb is finished.
//////////////////////////////////////////////////////////////////////
*/
module tb ();    // simple counter test-bench 

  localparam MSG_IDX = 5;            // chossing  message between 0 to 9.
  
  reg clk ;                     // Testbench clk
  reg reset ;                     // Testbench reset
   
  reg signed [7:0] sym_i;      // DUT Symbol input I value (scaled to 0-255)  
  reg signed [7:0] sym_q;      // DUT Symbol inpit Q value (scaled to 0-255)
  reg iq_valid;         // DUT I,Q symbol inputs are valid
  reg read_en;
  wire empty;          
  wire full;
  wire [7:0] data_out;      // DUT demapped data out 'charterer' (out of 4 symbols)

localparam MAX_MSG_LENGTH = 40 ; 
localparam NUM_MSGS = 10 ;   
     
reg [(MAX_MSG_LENGTH*4*8)-1:0] qpsk_msg_i [NUM_MSGS-1:0] ;
reg [(MAX_MSG_LENGTH*4*8)-1:0] qpsk_msg_q [NUM_MSGS-1:0] ;

initial begin  
`include "./qpsk/qspk_rx_tb_msgs.vh"
end
    
full_design qpsk_fifo(   
   
     .clk        (clk           ),     
     .reset      (reset         ),
     .sym_i      (sym_i         ),
     .sym_q      (sym_q         ),
     .iq_valid   (iq_valid      ),
	 .read_en	 (read_en		),
	 .empty		 (empty			),
	 .full		 (full			),
     .data_out   (data_out      )   
);

    
  initial begin   // Testbench Wakeup setup
        clk = 0;                  // Initialize clk
        reset = 1;                  // Assert Reset
		sym_i=0;
		sym_q=0;
		iq_valid=0;
		read_en=0;
        #20 reset = 0;              // De-assert Reset after 10 iq_idxime units	  
        
        $write("\n\nQPSK RECIVED TEXT MESSAGE: \n\n");
  end
  
  always #5 clk = !clk ;  // Toggle the clk forever every 5 time units
  
  integer iq_idx = 0 ;
  integer sym_idx = 0 ;
  
  always @(posedge clk)
   if(($random%3)&&!reset) begin // transfer a symbol on average one per 3 cycles
     sym_i <= qpsk_msg_i[MSG_IDX][(sym_idx*8)+7 -: 8] ;
     sym_q <= qpsk_msg_q[MSG_IDX][(sym_idx*8)+7 -: 8] ;      
     iq_valid <= 1 ;
     sym_idx = sym_idx+1 ;     
   end else  iq_valid <= 0 ;   


  
  always @(posedge clk) begin  
	if(($random%2)&&!reset) //data is fetched out of the fifo every 2 clock cycles on average.
		read_en<=1;
	else 
		read_en<=0;
		  
  end
  
  always@(data_out)begin
	if ((data_out<128) && (data_out>0))
      $write("%c",data_out) ; // display character  
    else begin
      if ((data_out==8'd0)||(data_out==8'hff)) begin
       $display("\n\n\n");
      $finish;
      end
	  $display("%d",data_out);
      $write($time,"\nERROR: NON-TEXT CHARCHTER ASCII CODE hex %-2X, QUITTING\n\n", data_out);
      $finish  ;    
    end
	
  end
	

  
  always @(posedge clk) begin
   if   (sym_idx==MAX_MSG_LENGTH*4*8)//If sym_idx is equal to the bits number of the message, finish the simulation.
       $finish ;
   end
endmodule 


