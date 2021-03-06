module TagRam(	Address, 
					TagIn, 
					TagOut, 
					Write, 
					Clk
					);
					
input [`INDEX] Address;
input [`TAG] TagIn;
output [`TAG] TagOut;
input Write;
input Clk;

reg [`TAG] TagOut;
reg [`TAG] TagRam [0:`CACHESIZE-1];

always @ (negedge Clk)
begin 
if (Write) 
TagRam[Address]=TagIn; // write
end
always @ (posedge Clk) 
begin
TagOut = TagRam[Address]; // read
end
endmodule