module ex_mem_pipeline_reg(
    IN_INSTRUCTION, // INSTRUCTION [11:7]
    IN_PC,
    IN_ALU_RESULT, 
    IN_DATA2, 
    IN_IMMEDIATE,
    IN_DATAMEMSEL,
    IN_READ_WRITE,
    IN_WB_SEL,
    IN_REG_WRITE_EN,
    OUT_INSTRUCTION,
    OUT_PC,
    OUT_ALU_RESULT,
    OUT_DATA2,
    OUT_IMMEDIATE, 
    OUT_DATAMEMSEL,
    OUT_READ_WRITE,
    OUT_WB_SEL,
    OUT_REG_WRITE_EN,
    CLK, 
    RESET,
    BUSYWAIT);

    //declare the ports
    input [4:0] IN_INSTRUCTION;
    input [1:0] IN_WB_SEL;
    input [3:0] IN_READ_WRITE;
    
    input [31:0] IN_PC,
            IN_ALU_RESULT,
            IN_DATA2,
            IN_IMMEDIATE;   
                
    input IN_DATAMEMSEL,
        IN_REG_WRITE_EN,
        CLK, 
        RESET, 
        BUSYWAIT;

    output reg [4:0] OUT_INSTRUCTION;
    output reg [1:0] OUT_WB_SEL;
    output reg [3:0] OUT_READ_WRITE;

    output reg [31:0] OUT_PC,
                    OUT_ALU_RESULT,
                    OUT_DATA2,
                    OUT_IMMEDIATE; 

    output reg OUT_DATAMEMSEL, OUT_REG_WRITE_EN;

    always @(posedge CLK or posedge RESET) begin
        if (RESET) begin
            OUT_INSTRUCTION <= 5'd0;
            OUT_PC <= 32'd0;
            OUT_ALU_RESULT <= 32'd0;
            OUT_DATA2 <= 32'd0;
            OUT_IMMEDIATE <= 32'd0;
            OUT_DATAMEMSEL <= 1'b0;
            OUT_READ_WRITE <= 4'd0;
            OUT_WB_SEL <= 2'b0;
            OUT_REG_WRITE_EN <= 1'b0;
        end
        else if (!RESET & !BUSYWAIT) begin
            OUT_INSTRUCTION <= #1 IN_INSTRUCTION;
            OUT_PC <= #1 IN_PC;
            OUT_ALU_RESULT <= #1 IN_ALU_RESULT;
            OUT_DATA2 <= #1 IN_DATA2;
            OUT_IMMEDIATE <= #1  IN_IMMEDIATE;
            OUT_DATAMEMSEL <= #1 IN_DATAMEMSEL;
            OUT_READ_WRITE <= #1 IN_READ_WRITE;
            OUT_WB_SEL <= #1 IN_WB_SEL;
            OUT_REG_WRITE_EN <= #1 IN_REG_WRITE_EN;
        end
    end

endmodule