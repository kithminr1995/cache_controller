module DataMux (	S,
						A,
						B,
						Z
						);
						
input S;
input [`DATA] A,B;
inout [`DATA] Z;
wire [`DATA] Z = S ? A: B;

endmodule