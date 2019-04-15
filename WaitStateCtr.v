module WaitStateCtr ( 	Load,
								LoadValue,
								Carry,
								Clk
								);
		
input Load;
input [1:0] LoadValue;
output Carry;
input Clk;
reg [1:0] Count;

always @(posedge Clk)
	if (Load)
		Count = LoadValue;
	else
		Count = Count - 2'b1;
		
wire Carry = Count == 2'b0;
endmodule