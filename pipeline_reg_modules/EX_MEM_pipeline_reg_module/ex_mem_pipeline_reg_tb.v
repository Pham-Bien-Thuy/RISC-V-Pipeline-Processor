`include "../../utils/macros.v"
`include "ex_mem_pipeline_reg.v"

module ex_mem_pipeline_reg_tb;

    reg [4:0] IN_INSTRUCTION;
    reg [1:0] IN_WB_SEL;
    reg [3:0] IN_READ_WRITE;
    
    reg [31:0] IN_PC,
               IN_ALU_RESULT,
               IN_DATA2,
               IN_IMMEDIATE;   

    reg IN_REG_WRITE_EN,
        IN_DATAMEMSEL,
        CLK, 
        RESET, 
        BUSYWAIT;

    wire [4:0] OUT_INSTRUCTION;
    wire [1:0] OUT_WB_SEL;
    wire [3:0] OUT_READ_WRITE;

    wire [31:0] OUT_PC,
               OUT_ALU_RESULT,
               OUT_DATA2,
               OUT_IMMEDIATE;
    
    wire OUT_REG_WRITE_EN, OUT_DATAMEMSEL;

    ex_mem_pipeline_reg my_ex_mem_pipeline_reg( IN_INSTRUCTION,
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
    
    initial begin
        
        CLK = 1'b0;
        RESET = 1'b0;
        BUSYWAIT = 1'b0;

        // Set arbitrary values to inputs
        IN_INSTRUCTION = 5'd15;
        IN_PC = 32'd23;
        IN_ALU_RESULT = 32'd45; 
        IN_DATA2 = 32'd33;  
        IN_IMMEDIATE = 32'd56; 
        IN_DATAMEMSEL = 1'b1;
        IN_READ_WRITE = 4'd1;
        IN_WB_SEL = 2'b11;
        IN_REG_WRITE_EN = 1'b1;

        $dumpfile("ex_mem_pipeline_reg.vcd");
        $dumpvars(0, ex_mem_pipeline_reg_tb);

        /*
            Test 01: RESET TEST
        */
        #1
        RESET = 1'b1;

        #5
        RESET = 1'b0;

        // Replace macro with explicit if statements
        if (OUT_INSTRUCTION !== 5'd0) begin
            $display("ASSERTION FAILED: Expected 5'd0, got %b", OUT_INSTRUCTION);
            $finish;
        end
        if (OUT_PC !== 32'd0) begin
            $display("ASSERTION FAILED: Expected 32'd0, got %b", OUT_PC);
            $finish;
        end
        if (OUT_ALU_RESULT !== 32'd0) begin
            $display("ASSERTION FAILED: Expected 32'd0, got %b", OUT_ALU_RESULT);
            $finish;
        end
        if (OUT_DATA2 !== 32'd0) begin
            $display("ASSERTION FAILED: Expected 32'd0, got %b", OUT_DATA2);
            $finish;
        end
        if (OUT_IMMEDIATE !== 32'd0) begin
            $display("ASSERTION FAILED: Expected 32'd0, got %b", OUT_IMMEDIATE);
            $finish;
        end
        if (OUT_DATAMEMSEL !== 1'b0) begin
            $display("ASSERTION FAILED: Expected 1'b0, got %b", OUT_DATAMEMSEL);
            $finish;
        end
        if (OUT_READ_WRITE !== 4'd0) begin
            $display("ASSERTION FAILED: Expected 4'd0, got %b", OUT_READ_WRITE);
            $finish;
        end
        if (OUT_WB_SEL !== 2'b00) begin
            $display("ASSERTION FAILED: Expected 2'b00, got %b", OUT_WB_SEL);
            $finish;
        end
        if (OUT_REG_WRITE_EN !== 1'b0) begin
            $display("ASSERTION FAILED: Expected 1'b0, got %b", OUT_REG_WRITE_EN);
            $finish;
        end

        $display("TEST 01 : RESET TEST Passed!");

        /*
            Test 02: BUSYWAIT TEST 0
            Module should write to pipeline register when BUSYWAIT is 0
        */
        #1
        BUSYWAIT = 1'b0;

        IN_INSTRUCTION = 5'd10;
        IN_PC = 32'd20;
        IN_ALU_RESULT = 32'd30; 
        IN_DATA2 = 32'd40;  
        IN_IMMEDIATE = 32'd50; 
        IN_DATAMEMSEL = 1'b1;
        IN_READ_WRITE = 4'd1;
        IN_WB_SEL = 2'b01;
        IN_REG_WRITE_EN = 1'b1;

        @(posedge CLK) begin
            // Wait for write to happen
            #3

            if (OUT_INSTRUCTION !== 5'd10) begin
                $display("ASSERTION FAILED: Expected 5'd10, got %b", OUT_INSTRUCTION);
                $finish;
            end
            if (OUT_PC !== 32'd20) begin
                $display("ASSERTION FAILED: Expected 32'd20, got %b", OUT_PC);
                $finish;
            end
            if (OUT_ALU_RESULT !== 32'd30) begin
                $display("ASSERTION FAILED: Expected 32'd30, got %b", OUT_ALU_RESULT);
                $finish;
            end
            if (OUT_DATA2 !== 32'd40) begin
                $display("ASSERTION FAILED: Expected 32'd40, got %b", OUT_DATA2);
                $finish;
            end
            if (OUT_IMMEDIATE !== 32'd50) begin
                $display("ASSERTION FAILED: Expected 32'd50, got %b", OUT_IMMEDIATE);
                $finish;
            end
            if (OUT_DATAMEMSEL !== 1'b1) begin
                $display("ASSERTION FAILED: Expected 1'b1, got %b", OUT_DATAMEMSEL);
                $finish;
            end
            if (OUT_READ_WRITE !== 4'd1) begin
                $display("ASSERTION FAILED: Expected 4'd1, got %b", OUT_READ_WRITE);
                $finish;
            end
            if (OUT_WB_SEL !== 2'b01) begin
                $display("ASSERTION FAILED: Expected 2'b01, got %b", OUT_WB_SEL);
                $finish;
            end
            if (OUT_REG_WRITE_EN !== 1'b1) begin
                $display("ASSERTION FAILED: Expected 1'b1, got %b", OUT_REG_WRITE_EN);
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

        IN_INSTRUCTION = 5'd30;
        IN_PC = 32'd70;
        IN_ALU_RESULT = 32'd80; 
        IN_DATA2 = 32'd50;  
        IN_IMMEDIATE = 32'd90; 
        IN_DATAMEMSEL = 1'b0;
        IN_READ_WRITE = 4'd3;
        IN_WB_SEL = 2'b11;
        IN_REG_WRITE_EN = 1'b0;

        @(posedge CLK) begin
            // Wait for write to happen
            #3

            if (OUT_INSTRUCTION !== 5'd10) begin
                $display("ASSERTION FAILED: Expected 5'd10, got %b", OUT_INSTRUCTION);
                $finish;
            end
            if (OUT_PC !== 32'd20) begin
                $display("ASSERTION FAILED: Expected 32'd20, got %b", OUT_PC);
                $finish;
            end
            if (OUT_ALU_RESULT !== 32'd30) begin
                $display("ASSERTION FAILED: Expected 32'd30, got %b", OUT_ALU_RESULT);
                $finish;
            end
            if (OUT_DATA2 !== 32'd40) begin
                $display("ASSERTION FAILED: Expected 32'd40, got %b", OUT_DATA2);
                $finish;
            end
            if (OUT_IMMEDIATE !== 32'd50) begin
                $display("ASSERTION FAILED: Expected 32'd50, got %b", OUT_IMMEDIATE);
                $finish;
            end
            if (OUT_DATAMEMSEL !== 1'b1) begin
                $display("ASSERTION FAILED: Expected 1'b1, got %b", OUT_DATAMEMSEL);
                $finish;
            end
            if (OUT_READ_WRITE !== 4'd1) begin
                $display("ASSERTION FAILED: Expected 4'd1, got %b", OUT_READ_WRITE);
                $finish;
            end
            if (OUT_WB_SEL !== 2'b01) begin
                $display("ASSERTION FAILED: Expected 2'b01, got %b", OUT_WB_SEL);
                $finish;
            end
            if (OUT_REG_WRITE_EN !== 1'b1) begin
                $display("ASSERTION FAILED: Expected 1'b1, got %b", OUT_REG_WRITE_EN);
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