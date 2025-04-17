module data_memory(CLK, RESET, READ, WRITE, ADDRESS, WRITEDATA, READDATA, BUSYWAIT);

input				CLK;
input           	RESET;
input           	READ;
input           	WRITE;
input[27:0]      	ADDRESS;
input[127:0]     	WRITEDATA;
output reg [127:0]	READDATA;
output reg      	BUSYWAIT;

`define READ_WRITE_DELAY #40

//Declare memory array 524288-bits
//512kB
reg [7:0] MEM_ARRAY [524287:0];

integer i;

//Detecting an incoming memory access
reg READACCESS, WRITEACCESS;

always @(*)
begin

	BUSYWAIT = (READ || WRITE)? 1 : 0;
	READACCESS = (READ && !WRITE)? 1 : 0;
	WRITEACCESS = (!READ && WRITE)? 1 : 0;
end

//Reading & writing
always @(posedge CLK)
begin
	if(READACCESS)
	begin
		READDATA[7:0]       = `READ_WRITE_DELAY MEM_ARRAY[{ADDRESS,4'b0000}];
		READDATA[15:8]      = `READ_WRITE_DELAY MEM_ARRAY[{ADDRESS,4'b0001}];
		READDATA[23:16]     = `READ_WRITE_DELAY MEM_ARRAY[{ADDRESS,4'b0010}];
		READDATA[31:24]     = `READ_WRITE_DELAY MEM_ARRAY[{ADDRESS,4'b0011}];
        	READDATA[39:32]     = `READ_WRITE_DELAY MEM_ARRAY[{ADDRESS,4'b0100}];
		READDATA[47:40]     = `READ_WRITE_DELAY MEM_ARRAY[{ADDRESS,4'b0101}];
		READDATA[55:48]     = `READ_WRITE_DELAY MEM_ARRAY[{ADDRESS,4'b0110}];
		READDATA[63:56]     = `READ_WRITE_DELAY MEM_ARRAY[{ADDRESS,4'b0111}];
        	READDATA[71:64]     = `READ_WRITE_DELAY MEM_ARRAY[{ADDRESS,4'b1000}];
		READDATA[79:72]     = `READ_WRITE_DELAY MEM_ARRAY[{ADDRESS,4'b1001}];
		READDATA[87:80]     = `READ_WRITE_DELAY MEM_ARRAY[{ADDRESS,4'b1010}];
		READDATA[95:88]     = `READ_WRITE_DELAY MEM_ARRAY[{ADDRESS,4'b1011}];
        	READDATA[103:96]    = `READ_WRITE_DELAY MEM_ARRAY[{ADDRESS,4'b1100}];
		READDATA[111:104]   = `READ_WRITE_DELAY MEM_ARRAY[{ADDRESS,4'b1101}];
		READDATA[119:112]   = `READ_WRITE_DELAY MEM_ARRAY[{ADDRESS,4'b1110}];
		READDATA[127:120]   = `READ_WRITE_DELAY MEM_ARRAY[{ADDRESS,4'b1111}];
		BUSYWAIT = 0;
		READACCESS = 0;
	end
	if(WRITEACCESS)
	begin
        	MEM_ARRAY[{ADDRESS,4'b0000}] = `READ_WRITE_DELAY WRITEDATA[7:0];
		MEM_ARRAY[{ADDRESS,4'b0001}] = `READ_WRITE_DELAY WRITEDATA[15:8];
		MEM_ARRAY[{ADDRESS,4'b0010}] = `READ_WRITE_DELAY WRITEDATA[23:16];
		MEM_ARRAY[{ADDRESS,4'b0011}] = `READ_WRITE_DELAY WRITEDATA[31:24];
        	MEM_ARRAY[{ADDRESS,4'b0100}] = `READ_WRITE_DELAY WRITEDATA[39:32];
		MEM_ARRAY[{ADDRESS,4'b0101}] = `READ_WRITE_DELAY WRITEDATA[47:40];
		MEM_ARRAY[{ADDRESS,4'b0110}] = `READ_WRITE_DELAY WRITEDATA[55:48];
		MEM_ARRAY[{ADDRESS,4'b0111}] = `READ_WRITE_DELAY WRITEDATA[63:56];
        	MEM_ARRAY[{ADDRESS,4'b1000}] = `READ_WRITE_DELAY WRITEDATA[71:64];
		MEM_ARRAY[{ADDRESS,4'b1001}] = `READ_WRITE_DELAY WRITEDATA[79:72];
		MEM_ARRAY[{ADDRESS,4'b1010}] = `READ_WRITE_DELAY WRITEDATA[87:80];
		MEM_ARRAY[{ADDRESS,4'b1011}] = `READ_WRITE_DELAY WRITEDATA[95:88];
        	MEM_ARRAY[{ADDRESS,4'b1100}] = `READ_WRITE_DELAY WRITEDATA[103:96];
		MEM_ARRAY[{ADDRESS,4'b1101}] = `READ_WRITE_DELAY WRITEDATA[111:104];
		MEM_ARRAY[{ADDRESS,4'b1110}] = `READ_WRITE_DELAY WRITEDATA[119:112];
		MEM_ARRAY[{ADDRESS,4'b1111}] = `READ_WRITE_DELAY WRITEDATA[127:120];
		BUSYWAIT = 0;
		WRITEACCESS = 0;
	end
end

//Reset memory
always @(posedge RESET)
begin
    if (RESET)
    begin
        for (i=0;i<524288; i=i+1)
            MEM_ARRAY[i] = 8'b0;
        
        BUSYWAIT = 0;
		READACCESS = 0;
		WRITEACCESS = 0;
    end
end

endmodule