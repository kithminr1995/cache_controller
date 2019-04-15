module Control ( 
						PStrobe, 
						PRW, 
						PReady,
						Match, 
						Valid, 
						Write, 
						CacheDataSelect,
						PDataSelect,
						SysDataOE,
						PDataOE, 
						SysStrobe, 
						SysRW, 
						Reset,
						Clk 
						);


input PStrobe, PRW;
output PReady;
input Match, Valid;
output Write;
output CacheDataSelect;
output PDataSelect;
output SysDataOE, PDataOE;
output SysStrobe, SysRW;
input Reset;
input Clk;


wire [1:0] WaitStateCtrInput = `WAITSTATES - 2'd1;
wire WaitStateCtrCarry;
reg LoadWaitStateCtr;

WaitStateCtr WaitStateCtr( 
									.Load (LoadWaitStateCtr), 
									.LoadValue (WaitStateCtrInput), 
									.Carry (WaitStateCtrCarry),
									.Clk (Clk) 
									);

reg PReadyEnable;
reg SysStrobe,SysRW;
reg SysDataOE;
reg Write, Ready;
reg CacheDataSelect;
reg PDataSelect, PDataOE;
reg [3:0] State, NextState;

initial State = 0;

parameter STATE_IDLE = 0;
parameter STATE_READ = 1;
parameter STATE_READMISS = 2;
parameter STATE_READSYS = 3;
parameter STATE_READDATA = 4;
parameter STATE_WRITE = 5;
parameter STATE_WRITEHIT = 6;
parameter STATE_WRITEMISS = 7;
parameter STATE_WRITESYS = 8;
parameter STATE_WRITEDATA = 9;

always @ (posedge Clk)
	State = NextState;
always @ (State)
	if (Reset) 
		NextState = STATE_IDLE;
	else
		case (State)
			STATE_IDLE: begin
					if (PStrobe && PRW)
						NextState = STATE_READ;
					else if (PStrobe && !PRW)
						NextState = STATE_WRITE;
			end
			STATE_READ: begin
					if (Match && Valid)
						NextState = STATE_IDLE;
					//read hit
					else
						NextState = STATE_READMISS;
						$display ("state = read");
			end
			STATE_READMISS: begin
						NextState = STATE_READSYS;
						$display("state = readmiss");
					end
			STATE_READSYS : begin
					if (WaitStateCtrCarry)
						NextState = STATE_READDATA;
					else NextState = STATE_READSYS;
						$display ("state = readsys");
					end
			STATE_READDATA : begin
						NextState = STATE_IDLE;
						$display ("state = readdata");
					end
			STATE_WRITE : begin
					if (Match && Valid)
						NextState = STATE_WRITEHIT;
					else NextState = STATE_WRITEMISS;
						$display ("state = WRITE");
					end
			STATE_WRITEHIT : begin
						NextState = STATE_WRITESYS;
						$display ("state = WRITEHIT");
					end
			STATE_WRITEMISS : begin
						NextState = STATE_WRITESYS;
						$display ("state = WRITEmiss");
					end
			STATE_WRITESYS :begin
					if (WaitStateCtrCarry)
						NextState = STATE_WRITEDATA;
					else
						NextState = STATE_WRITESYS;
						$display("state = WRITEsys");
					end
			STATE_WRITEDATA : begin
						NextState = STATE_IDLE;
						$display ("“State = WRITEdata");
					end
			endcase
			
task OutputVec;

input [9:0] vector;

begin
	LoadWaitStateCtr=vector[9];
	PReadyEnable=vector[8];
	Ready=vector[7];
	Write=vector[6];
	SysStrobe=vector[5];
	SysRW=vector[4];
	CacheDataSelect=vector[3];
	PDataSelect=vector[2];
	PDataOE=vector[1];
	SysDataOE=vector[0];
end
endtask

always @ (State)
			case (State) //9876543210
				STATE_IDLE: OutputVec(10'b0000000000);
				STATE_READ: OutputVec(10'b0100000010);
				STATE_READMISS: OutputVec(10'b1000110010);
				STATE_READSYS: OutputVec(10'b0000010010);
				STATE_READDATA: OutputVec(10'b0011011110);
				STATE_WRITEHIT: OutputVec(10'b1001101100);
				STATE_WRITE: OutputVec(10'b0100000000);
				STATE_WRITEMISS: OutputVec(10'b1000100001);
				STATE_WRITESYS: OutputVec(10'b0000000001);
				STATE_WRITEDATA: OutputVec(10'b0011001101);
			endcase //9876543210
			
wire PReady = (PReadyEnable && Match && Valid) || Ready;

endmodule