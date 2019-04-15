`define READ 1
`define WRITE 0
`define CACHESIZE 1024
`define WAITSTATES 2
//number of wait states
//required for system accesses
`define ADDR 15:0
`define INDEX 9:0
`define TAG 15:10
`define DATAWIDTH 32
`define DATA `DATAWIDTH-1:0
`define PRESENT 1
`define ABSENT !`PRESENT

module main_cache( 	PStrobe, 
							PAddress, 
							PData, 
							PRW, 
							PReady, 
							SysStrobe, 
							SysAddress, 
							SysData, 
							SysRW, 
							Reset, 
							Clk 
							);
input PStrobe;
input [`ADDR] PAddress;
inout [`DATA] PData;
input PRW;
output PReady;

output SysStrobe;
output [`ADDR] SysAddress;
inout [`DATA] SysData;
output SysRW;
input Reset;
input Clk;

//Bidirectional buses
wire PDataOE;
wire SysDataOE;
wire [`DATA] PDataOut;
wire [`DATA] PData=PDataOE ? PDataOut : `DATAWIDTH'bz;
wire [`DATA] SysData=SysDataOE ? PData : `DATAWIDTH'bz;
wire [`ADDR] SysAddress = PAddress;
wire [`TAG] TagRamTag;


TagRam TagRam ( 	.Address (PAddress[`INDEX]), 
						.TagIn (PAddress[`TAG]), 
						.TagOut (TagRamTag[`TAG]), 
						.Write (Write), 
						.Clk (Clk)
					);
ValidRam ValidRam( 
						.Address (PAddress[`INDEX]), 
						.ValidIn (1'b1), 
						.ValidOut (Valid), 
						.Write (Write), 
						.Reset (Reset), 
						.Clk (Clk)
						);


wire [`DATA] DataRamDataOut;
wire [`DATA] DataRamDataIn;

DataMux CacheDataInputMux( 
									.S(CacheDataSelect), 
									.A(SysData), 
									.B(Pdata),
									.Z(DataRamDataIn)
									);
DataMux PDataMax(
						.S(PDataSelect),
						.A(SysData),
						.B(DataRamDataOut),
						.Z(PDataOut)
						);
						
DataRam DataRam ( .Address(PAddress[`INDEX]),
						.DataIn (DataRamDataIn), 
						.DataOut (DataRamDataOut), 
						.Write (Write), 
						.Clk (Clk)
					);
					
Comparator Comparator ( 
								.Tag1 (PAddress[`TAG]), 
								.Tag2 (TagRamTag), 
								.Match (Match) 
								);

Control Control ( 
						.PStrobe(PStrobe), 
						.PRW (PRW), 
						.PReady (PReady), 
						.Match (Match), 
						.Valid (Valid), 
						.CacheDataSelect(CacheDataSelect), 
						.PDataSelect (PDataSelect), 
						.SysDataOE (SysDataOE), 
						.Write (Write), 
						.PDataOE (PDataOE), 
						.SysStrobe (SysStrobe), 
						.SysRW (SysRW), 
						.Reset (Reset), 
						.Clk (Clk) 
						);
						
endmodule
