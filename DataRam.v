

module DataRam(
					Address, 
					DataIn, 
					DataOut, 
					Write, 
					Clk
					);
					
input [`INDEX] Address;
input [`DATA] DataIn;
output [`DATA] DataOut;
input Write;
input Clk;
reg [`DATA] DataOut;
reg [`DATA] DataRam [`CACHESIZE-1:0];

always @ (negedge Clk) 
	if (Write) 
		DataRam[Address]=DataIn; // write
always @ (posedge Clk) 
	DataOut = DataRam [Address]; // read

endmodule