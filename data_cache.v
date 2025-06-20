module data_cache (
    CLK, RESET, BUSYWAIT, READ_WRITE, WRITEDATA, READDATA, ADDRESS, 
    MEM_BUSYWAIT, MEM_READ, MEM_WRITE, MEM_READDATA, MEM_WRITEDATA, MEM_ADDRESS
);

    // Port declaration
    input CLK, RESET, MEM_BUSYWAIT;
    input [3:0] READ_WRITE;
    input [31:0] WRITEDATA, ADDRESS;
    input [127:0] MEM_READDATA;

    output reg [27:0] MEM_ADDRESS;
    output reg [127:0] MEM_WRITEDATA;
    output reg [31:0] READDATA;
    output reg BUSYWAIT, MEM_READ, MEM_WRITE;

    // Cache storage: 16 blocks, each 128 bits (16 bytes)
    reg [127:0] DATA [0:15];  // Single packed dimension for 128-bit data, unpacked for 16 blocks
    reg [23:0] TAG [0:15];
    reg DIRTY [0:15];
    reg VALID [0:15];

    // Set BUSYWAIT if READ_WRITE[3] signal is 1
    always @(READ_WRITE) begin
        if (READ_WRITE[3]) 
            BUSYWAIT = 1;
        else
            BUSYWAIT = 0;
    end

    // Wires for extracted values based on the index part of the address
    wire VALID_OUT, DIRTY_OUT;
    wire [127:0] DATA_OUT;  // Adjusted to 128-bit width
    wire [23:0] TAG_OUT;

    // Obtain stored values from the register array using the index
    assign #1 DATA_OUT = DATA[ADDRESS[7:4]];
    assign #1 VALID_OUT = VALID[ADDRESS[7:4]];
    assign #1 DIRTY_OUT = DIRTY[ADDRESS[7:4]];
    assign #1 TAG_OUT = TAG[ADDRESS[7:4]];

    // Tag comparison and hit determination
    wire TAG_STATUS, HIT;
    assign #1 TAG_STATUS = (TAG_OUT == ADDRESS[31:8]) ? 1 : 0;
    assign HIT = VALID_OUT && TAG_STATUS;

    // Clear BUSYWAIT on positive clock edge when there is a hit
    always @(posedge CLK) begin
        if (HIT) BUSYWAIT = 0;
    end

    // Select data from offsets
    reg [7:0] DATA_BYTE;
    reg [15:0] DATA_HALF;
    reg [31:0] DATA_WORD;

    always @(*) begin
        case (READ_WRITE)
            4'b1000: DATA_BYTE = DATA_OUT[8*ADDRESS[3:0] +: 8];  // Byte selection
            4'b1001: DATA_HALF = DATA_OUT[16*ADDRESS[3:1] +: 16];  // Half-word selection
            4'b1010: DATA_WORD = DATA_OUT[32*ADDRESS[3:2] +: 32];  // Word selection (fixed typo)
            default: begin
                DATA_BYTE = 8'bx;
                DATA_HALF = 16'bx;
                DATA_WORD = 32'bx;
            end
        endcase
    end

    // Sign extend or zero extend the data
    wire [31:0] LB, LH, LW, LBU, LHU;

    assign LB[7:0] = DATA_BYTE;
    assign LB[31:8] = {24{DATA_BYTE[7]}};

    assign LH[15:0] = DATA_HALF;  // Fixed: Complete assignment
    assign LH[31:16] = {16{DATA_HALF[15]}};

    assign LW = DATA_WORD;

    assign LBU = {24'd0, DATA_BYTE};
    assign LHU = {16'd0, DATA_HALF};

    // Output the data
    always @(*) begin
        #1;
        case (READ_WRITE[2:0])
            3'b000: READDATA = LB;
            3'b001: READDATA = LH;
            3'b010: READDATA = LW;
            3'b100: READDATA = LBU;
            3'b101: READDATA = LHU;
            default: READDATA = 32'bx;
        endcase
    end

    // Write data to cache
    always @(posedge CLK) begin
        if (HIT && READ_WRITE[3]) begin
            #1;
            DIRTY[ADDRESS[7:4]] = 1;
            case (READ_WRITE)
                4'b1011: DATA[ADDRESS[7:4]][8*ADDRESS[3:0] +: 8] = WRITEDATA[7:0];  // SB
                4'b1110: DATA[ADDRESS[7:4]][16*ADDRESS[3:1] +: 16] = WRITEDATA[15:0];  // SH
                4'b1111: DATA[ADDRESS[7:4]][32*ADDRESS[3:2] +: 32] = WRITEDATA;  // SW
            endcase
        end
    end

    /* Cache Controller FSM Start */
    parameter IDLE = 2'b00, READ_MEM = 2'b10, WRITE_MEM = 2'b01, UPDATE_CACHE = 2'b11;
    reg [1:0] STATE, NEXT_STATE;

    // Combinational next state logic
    always @(*) begin
        case (STATE)
            IDLE:
                if (READ_WRITE[3] && !DIRTY_OUT && !HIT)  
                    NEXT_STATE = READ_MEM;
                else if (READ_WRITE[3] && DIRTY_OUT && !HIT)
                    NEXT_STATE = WRITE_MEM;
                else
                    NEXT_STATE = IDLE;
            READ_MEM:
                if (!MEM_BUSYWAIT)
                    NEXT_STATE = UPDATE_CACHE;
                else    
                    NEXT_STATE = READ_MEM;
            WRITE_MEM:
                if (!MEM_BUSYWAIT)
                    NEXT_STATE = READ_MEM;
                else
                    NEXT_STATE = WRITE_MEM;
            UPDATE_CACHE:
                NEXT_STATE = IDLE;
            default: NEXT_STATE = IDLE;
        endcase
    end

    // Combinational output logic
    always @(STATE) begin
        case (STATE)
            IDLE: begin
                MEM_READ = 0;
                MEM_WRITE = 0;
                MEM_ADDRESS = 28'dx;
                MEM_WRITEDATA = 128'dx;
            end
            READ_MEM: begin
                MEM_READ = 1;
                MEM_WRITE = 0;
                MEM_ADDRESS = ADDRESS[31:4];
                MEM_WRITEDATA = 128'dx;
            end
            WRITE_MEM: begin
                MEM_READ = 0;
                MEM_WRITE = 1;
                MEM_ADDRESS = {TAG_OUT, ADDRESS[7:4]};
                MEM_WRITEDATA = DATA_OUT;
            end
            UPDATE_CACHE: begin
                #1;
                DATA[ADDRESS[7:4]] = MEM_READDATA;
                DIRTY[ADDRESS[7:4]] = 0;
                VALID[ADDRESS[7:4]] = 1;
                TAG[ADDRESS[7:4]] = ADDRESS[31:8];
            end
        endcase
    end

    // Sequential logic for state transitioning 
    always @(posedge CLK or posedge RESET) begin
        if (RESET)
            STATE <= IDLE;
        else
            STATE <= NEXT_STATE;
    end

    // Reset the cache memory when the reset signal is high
    integer i;
    always @(RESET) begin
        if (RESET) begin
            for (i = 0; i < 16; i = i + 1) begin
                VALID[i] = 0;
                DIRTY[i] = 0;
                TAG[i] = 24'bx;
                DATA[i] = 128'dx;
            end
            BUSYWAIT = 0;
        end
    end

endmodule