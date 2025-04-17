module if_id_pipeline_reg(
    IN_INSTRUCTION, 
    IN_PC, 
    OUT_INSTRUCTION, 
    OUT_PC, 
    CLK, 
    RESET, 
    BUSYWAIT);

    //declare the ports
    input [31:0] IN_INSTRUCTION, IN_PC;
    input CLK, RESET, BUSYWAIT;
    output reg [31:0] OUT_INSTRUCTION, OUT_PC;

    always @(posedge CLK or posedge RESET) begin
        if (RESET) begin
            OUT_PC <= 32'd0;
            OUT_INSTRUCTION <= 32'd0;
        end
        else if (!BUSYWAIT) begin
            OUT_PC <= IN_PC;
            OUT_INSTRUCTION <= IN_INSTRUCTION;
        end
    end

endmodule