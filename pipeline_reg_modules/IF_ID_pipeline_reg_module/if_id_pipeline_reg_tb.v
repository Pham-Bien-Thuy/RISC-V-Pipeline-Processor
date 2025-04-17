`include "../../utils/macros.v"
`include "if_id_pipeline_reg.v"

module if_id_pipeline_reg_tb;
    
    reg [31:0] IN_INSTRUCTION, IN_PC;
    reg CLK, RESET, BUSYWAIT;
    wire [31:0] OUT_INSTRUCTION, OUT_PC;

    if_id_pipeline_reg my_if_id_pipeline_reg(IN_INSTRUCTION, IN_PC, OUT_INSTRUCTION, OUT_PC, CLK, RESET, BUSYWAIT);

    initial begin
        CLK = 1'b0;
        RESET = 1'b0;
        BUSYWAIT = 1'b0;

        // Set arbitrary values to inputs
        IN_INSTRUCTION = 32'd10;
        IN_PC = 32'd20;

        $dumpfile("if_id_pipeline_reg.vcd");
        $dumpvars(0, if_id_pipeline_reg_tb);

        /*
            Test 01: RESET TEST
        */
        #1
        RESET = 1'b1;

        #5
        RESET = 1'b0;

        // Replace macro with explicit if statements
        if (OUT_INSTRUCTION !== 32'd0) begin
            $display("ASSERTION FAILED: Expected 0, got %b", OUT_INSTRUCTION);
            $finish;
        end
        if (OUT_PC !== 32'd0) begin
            $display("ASSERTION FAILED: Expected 0, got %b", OUT_PC);
            $finish;
        end
        $display("TEST 01 : RESET TEST Passed!");

        /*
            Test 02: BUSYWAIT TEST 0
            Module should write to pipeline register when BUSYWAIT is 0
        */
        #1
        BUSYWAIT = 1'b0;

        IN_INSTRUCTION = 32'd10;
        IN_PC = 32'd20;
 
        @(posedge CLK) begin
            #3
            if (OUT_INSTRUCTION !== 32'd10) begin
                $display("ASSERTION FAILED: Expected 10, got %b", OUT_INSTRUCTION);
                $finish;
            end
            if (OUT_PC !== 32'd20) begin
                $display("ASSERTION FAILED: Expected 20, got %b", OUT_PC);
                $finish;
            end
            $display("TEST 02 : BUSYWAIT_0 TEST Passed!");
        end

        /*
            Test 03: BUSYWAIT TEST 1
            Module should not write to pipeline register when BUSYWAIT is 1
        */
        #1
        BUSYWAIT = 1'b1;

        IN_INSTRUCTION = 32'd60;
        IN_PC = 32'd70;

        @(posedge CLK) begin
            #3
            if (OUT_INSTRUCTION !== 32'd10) begin
                $display("ASSERTION FAILED: Expected 10, got %b", OUT_INSTRUCTION);
                $finish;
            end
            if (OUT_PC !== 32'd20) begin
                $display("ASSERTION FAILED: Expected 20, got %b", OUT_PC);
                $finish;
            end
            $display("Test 03 : BUSYWAIT_1 TEST Passed!");
        end

        #100
        $finish;
    end

    // Clock generation
    always begin
        #4 CLK = ~CLK;
    end

endmodule