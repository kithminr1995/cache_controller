`timescale 1ns / 100ps

module test_main_cache();

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

wire [`DATA] DataRamDataOut;
wire [`DATA] DataRamDataIn;

main_cache main(  .PStrobe(PStrobe), 
						.PAddress(PAddress), 
						.PData(PData), 
						.PRW(PRW), 
						.PReady(PReady), 
						.SysStrobe(SysStrobe), 
						.SysAddress(SysAddress), 
						.SysData(SysData), 
						.SysRW(SysRW), 
						.Reset(Reset), 
						.Clk(Clk) 
						);
						
initial begin
clock = 1'd0;
forever
#10 clock = ~clock;
end
						
endmodule
