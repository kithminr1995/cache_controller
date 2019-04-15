

module ValidRam (
						Address, 
						ValidIn, 
						ValidOut, 
						Write, 
						Reset, 
						Clk 
						);
						
input [`INDEX] Address;
input ValidIn;
output ValidOut;
input Write;
input Reset;
input Clk;

reg ValidOut;
reg [`CACHESIZE-1:0] ValidBits;

integer i;

always @ (negedge Clk) // Write
			if (Write && !Reset)
				ValidBits[Address]=ValidIn; // write
			else if (Reset)
				for (i=0;i<`CACHESIZE;i=i+1) 
					ValidBits[i]=`ABSENT; //reset
			always @ (posedge Clk)
				ValidOut = ValidBits[Address]; // read

endmodule