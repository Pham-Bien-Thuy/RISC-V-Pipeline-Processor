module mem_wb_pipeline_reg(
    IN_INSTRUCTION, // INSTRUCTION [11:7]
    IN_PC_4,
    IN_ALU_RESULT, 
    IN_IMMEDIATE,
    IN_DMEM_OUT,
    IN_WB_SEL,
    IN_REG_WRITE_EN,
    OUT_INSTRUCTION,
    OUT_PC_4,
    OUT_ALU_RESULT,
    OUT_IMMEDIATE, 
    OUT_DMEM_OUT,
    OUT_WB_SEL,
    OUT_REG_WRITE_EN,
    CLK, 
    RESET,
    BUSYWAIT);

    //declare the ports
    input [4:0] IN_INSTRUCTION;
    input [1:0] IN_WB_SEL;
    
    input [31:0] IN_PC_4,
            IN_ALU_RESULT,
            IN_IMMEDIATE,
            IN_DMEM_OUT;   
                
    input IN_REG_WRITE_EN,
        CLK, 
        RESET, 
        BUSYWAIT;

    output reg [4:0] OUT_INSTRUCTION;
    output reg [1:0] OUT_WB_SEL;

    output reg [31:0] OUT_PC_4,
                    OUT_ALU_RESULT,
                    OUT_IMMEDIATE,
                    OUT_DMEM_OUT; 

    output reg OUT_REG_WRITE_EN;

    always @(posedge CLK or posedge RESET) begin
        if (RESET) begin
            OUT_INSTRUCTION <= 5'd0;
            OUT_PC_4 <= 32'd0;
            OUT_ALU_RESULT <= 32'd0;
            OUT_IMMEDIATE <= 32'd0;
            OUT_DMEM_OUT <= 32'd0;
            OUT_WB_SEL <= 2'd0;
            OUT_REG_WRITE_EN <= 1'b0;
        end
        else if (!RESET & !BUSYWAIT) begin
            OUT_INSTRUCTION <= #1 IN_INSTRUCTION;
            OUT_PC_4 <= #1 IN_PC_4;
            OUT_ALU_RESULT <= #1 IN_ALU_RESULT;
            OUT_IMMEDIATE <= #1  IN_IMMEDIATE;
            OUT_DMEM_OUT <= #1 IN_DMEM_OUT;
            OUT_WB_SEL <= #1 IN_WB_SEL;
            OUT_REG_WRITE_EN <= #1 IN_REG_WRITE_EN;
        end
    end

endmodule