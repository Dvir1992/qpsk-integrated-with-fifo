module tb #(parameter FIFO_DEPTH=16 , FIFO_WIDTH=8); 
  reg clk;
  reg reset;
  reg read_en;
  reg write_en;
  reg [FIFO_WIDTH-1:0] data_in;
  wire empty;
  wire full;
  wire [FIFO_WIDTH-1:0] data_out;
  integer i;
  
  
  
  fifo #(.FIFO_DEPTH(16)) fif
  (.clk(clk),
   .reset(reset),
   .read_en(read_en),
   .write_en(write_en),
   .data_in(data_in),
   .empty(empty),
   .full(full),
   .data_out(data_out)
  );
  

   initial begin
    i=0;
    clk=0;
	reset=1;
	read_en=0;
	write_en=0;
	data_in=0;
	#50;
	@(posedge clk);
	reset=0;
	//full check
	write_en=1;
	repeat(FIFO_DEPTH)begin
		data_in=i;
		i=i+1;
		@(posedge clk);
	end
	if (full)
		$display("success");
	else
		$error("%t:failure",$time);
		
	
	// empty and data out check
	read_en=1;
	write_en=0;
	i=0;
	@(posedge clk);
	repeat(FIFO_DEPTH-1)begin //the last one won't be red because we sacrifice one place of the fifo for the simplicity of the empty/full wires.  
		#1;
		$display("i=%d,data_out=%d",i,data_out);
		if(data_out==i)
			$display("success");
		else
		$error("%t:failure",$time);
		i=i+1;
		@(posedge clk);		
	end
	if (empty)
		$display("success");
	else
		$error("%t:failure",$time);
	
    $finish;	
    

   end
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end
  

  always#5 clk=~clk;

    
  
      
endmodule



