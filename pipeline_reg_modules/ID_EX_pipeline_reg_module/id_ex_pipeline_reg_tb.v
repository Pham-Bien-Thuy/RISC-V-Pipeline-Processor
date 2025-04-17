`include "../../utils/macros.v"
`include "id_ex_pipeline_reg.v"

module id_ex_pipeline_reg_tb;

    reg [4:0] IN_INSTRUCTION, IN_ALU_OP;
    reg [2:0] IN_BRANCH_JUMP;
    reg [1:0] IN_WB_SEL, IN_DATA1ALUSEL, IN_DATA2ALUSEL, IN_DATA1BJSEL, IN_DATA2BJSEL;
    reg [3:0] IN_READ_WRITE;
    
    reg [31:0] IN_PC,
               IN_DATA1,
               IN_DATA2,
               IN_IMMEDIATE;   

    reg IN_DATAMEMSEL,
        IN_REG_WRITE_EN,
        CLK, 
        RESET, 
        BUSYWAIT;

    wire [4:0] OUT_ALU_OP, OUT_INSTRUCTION;
    wire [2:0] OUT_BRANCH_JUMP;
    wire [1:0] OUT_WB_SEL, OUT_DATA1ALUSEL, OUT_DATA2ALUSEL, OUT_DATA1BJSEL, OUT_DATA2BJSEL;
    wire [3:0] OUT_READ_WRITE;

    wire [31:0] OUT_PC,
                OUT_DATA1,
                OUT_DATA2,
                OUT_IMMEDIATE; 

    wire OUT_DATAMEMSEL,
         OUT_REG_WRITE_EN;

    id_ex_pipeline_reg my_id_ex_pipeline_reg(   IN_INSTRUCTION,
                                                IN_PC,
                                                IN_DATA1, 
                                                IN_DATA2, 
                                                IN_IMMEDIATE,
                                                IN_DATA1ALUSEL,
                                                IN_DATA2ALUSEL,
                                                IN_DATA1BJSEL, 
                                                IN_DATA2BJSEL,
                                                IN_ALU_OP,
                                                IN_BRANCH_JUMP,
                                                IN_DATAMEMSEL,
                                                IN_READ_WRITE,
                                                IN_WB_SEL,
                                                IN_REG_WRITE_EN,
                                                OUT_INSTRUCTION,
                                                OUT_PC,
                                                OUT_DATA1,
                                                OUT_DATA2,
                                                OUT_IMMEDIATE, 
                                                OUT_DATA1ALUSEL,
                                                OUT_DATA2ALUSEL,
                                                OUT_DATA1BJSEL, 
                                                OUT_DATA2BJSEL,
                                                OUT_ALU_OP,
                                                OUT_BRANCH_JUMP,
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
        IN_DATA1 = 32'd45;  
        IN_DATA2 = 32'd33;   
        IN_IMMEDIATE = 32'd56; 
        IN_DATA1ALUSEL = 2'd1;
        IN_DATA2ALUSEL = 2'd1;
        IN_DATA1BJSEL = 2'd1; 
        IN_DATA2BJSEL = 2'd1;
        IN_ALU_OP = 5'd15;
        IN_BRANCH_JUMP = 3'd2;
        IN_DATAMEMSEL = 1'd1;
        IN_READ_WRITE = 4'd1;
        IN_WB_SEL = 2'b01;
        IN_REG_WRITE_EN = 1'b0;

        $dumpfile("id_ex_pipeline_reg.vcd");
        $dumpvars(0, id_ex_pipeline_reg_tb);

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
        if (OUT_DATA1 !== 32'd0) begin
            $display("ASSERTION FAILED: Expected 32'd0, got %b", OUT_DATA1);
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
        if (OUT_DATA1ALUSEL !== 2'd0) begin
            $display("ASSERTION FAILED: Expected 2'd0, got %b", OUT_DATA1ALUSEL);
            $finish;
        end
        if (OUT_DATA2ALUSEL !== 2'd0) begin
            $display("ASSERTION FAILED: Expected 2'd0, got %b", OUT_DATA2ALUSEL);
            $finish;
        end
        if (OUT_DATA1BJSEL !== 2'd0) begin
            $display("ASSERTION FAILED: Expected 2'd0, got %b", OUT_DATA1BJSEL);
            $finish;
        end
        if (OUT_DATA2BJSEL !== 2'd0) begin
            $display("ASSERTION FAILED: Expected 2'd0, got %b", OUT_DATA2BJSEL);
            $finish;
        end
        if (OUT_ALU_OP !== 5'd0) begin
            $display("ASSERTION FAILED: Expected 5'd0, got %b", OUT_ALU_OP);
            $finish;
        end
        if (OUT_BRANCH_JUMP !== 3'd0) begin
            $display("ASSERTION FAILED: Expected 3'd0, got %b", OUT_BRANCH_JUMP);
            $finish;
        end
        if (OUT_DATAMEMSEL !== 1'd0) begin
            $display("ASSERTION FAILED: Expected 1'd0, got %b", OUT_DATAMEMSEL);
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

        // Set arbitrary values to inputs
        IN_INSTRUCTION = 5'd15;
        IN_PC = 32'd23;
        IN_DATA1 = 32'd45;  
        IN_DATA2 = 32'd33;   
        IN_IMMEDIATE = 32'd56; 
        IN_DATA1ALUSEL = 2'd1;
        IN_DATA2ALUSEL = 2'd1;
        IN_DATA1BJSEL = 2'd1; 
        IN_DATA2BJSEL = 2'd1;
        IN_ALU_OP = 5'd15;
        IN_BRANCH_JUMP = 3'd2;
        IN_DATAMEMSEL = 1'd1;
        IN_READ_WRITE = 4'd1;
        IN_WB_SEL = 2'b01;
        IN_REG_WRITE_EN = 1'b0;

        @(posedge CLK) begin
            // Wait for write to happen
            #3

            if (OUT_INSTRUCTION !== 5'd15) begin
                $display("ASSERTION FAILED: Expected 5'd15, got %b", OUT_INSTRUCTION);
                $finish;
            end
            if (OUT_PC !== 32'd23) begin
                $display("ASSERTION FAILED: Expected 32'd23, got %b", OUT_PC);
                $finish;
            end
            if (OUT_DATA1 !== 32'd45) begin
                $display("ASSERTION FAILED: Expected 32'd45, got %b", OUT_DATA1);
                $finish;
            end
            if (OUT_DATA2 !== 32'd33) begin
                $display("ASSERTION FAILED: Expected 32'd33, got %b", OUT_DATA2);
                $finish;
            end
            if (OUT_IMMEDIATE !== 32'd56) begin
                $display("ASSERTION FAILED: Expected 32'd56, got %b", OUT_IMMEDIATE);
                $finish;
            end
            if (OUT_DATA1ALUSEL !== 2'd1) begin
                $display("ASSERTION FAILED: Expected 2'd1, got %b", OUT_DATA1ALUSEL);
                $finish;
            end
            if (OUT_DATA2ALUSEL !== 2'd1) begin
                $display("ASSERTION FAILED: Expected 2'd1, got %b", OUT_DATA2ALUSEL);
                $finish;
            end
            if (OUT_DATA1BJSEL !== 2'd1) begin
                $display("ASSERTION FAILED: Expected 2'd1, got %b", OUT_DATA1BJSEL);
                $finish;
            end
            if (OUT_DATA2BJSEL !== 2'd1) begin
                $display("ASSERTION FAILED: Expected 2'd1, got %b", OUT_DATA2BJSEL);
                $finish;
            end
            if (OUT_ALU_OP !== 5'd15) begin
                $display("ASSERTION FAILED: Expected 5'd15, got %b", OUT_ALU_OP);
                $finish;
            end
            if (OUT_BRANCH_JUMP !== 3'd2) begin
                $display("ASSERTION FAILED: Expected 3'd2, got %b", OUT_BRANCH_JUMP);
                $finish;
            end
            if (OUT_DATAMEMSEL !== 1'd1) begin
                $display("ASSERTION FAILED: Expected 1'd1, got %b", OUT_DATAMEMSEL);
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
            if (OUT_REG_WRITE_EN !== 1'b0) begin
                $display("ASSERTION FAILED: Expected 1'b0, got %b", OUT_REG_WRITE_EN);
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

        // Set arbitrary values to inputs
        IN_INSTRUCTION = 5'd25;
        IN_PC = 32'd43;
        IN_DATA1 = 32'd55;  
        IN_DATA2 = 32'd63;   
        IN_IMMEDIATE = 32'd56; 
        IN_DATA1ALUSEL = 2'd0;
        IN_DATA2ALUSEL = 2'd0;
        IN_DATA1BJSEL = 2'd0; 
        IN_DATA2BJSEL = 2'd0;
        IN_ALU_OP = 5'd30;
        IN_BRANCH_JUMP = 3'd3;
        IN_DATAMEMSEL = 1'd0;
        IN_READ_WRITE = 4'd2;
        IN_WB_SEL = 2'b00;
        IN_REG_WRITE_EN = 1'b0;

        @(posedge CLK) begin
            // Wait for write to happen
            #3

            if (OUT_INSTRUCTION !== 5'd15) begin
                $display("ASSERTION FAILED: Expected 5'd15, got %b", OUT_INSTRUCTION);
                $finish;
            end
            if (OUT_PC !== 32'd23) begin
                $display("ASSERTION FAILED: Expected 32'd23, got %b", OUT_PC);
                $finish;
            end
            if (OUT_DATA1 !== 32'd45) begin
                $display("ASSERTION FAILED: Expected 32'd45, got %b", OUT_DATA1);
                $finish;
            end
            if (OUT_DATA2 !== 32'd33) begin
                $display("ASSERTION FAILED: Expected 32'd33, got %b", OUT_DATA2);
                $finish;
            end
            if (OUT_IMMEDIATE !== 32'd56) begin
                $display("ASSERTION FAILED: Expected 32'd56, got %b", OUT_IMMEDIATE);
                $finish;
            end
            if (OUT_DATA1ALUSEL !== 2'd1) begin
                $display("ASSERTION FAILED: Expected 2'd1, got %b", OUT_DATA1ALUSEL);
                $finish;
            end
            if (OUT_DATA2ALUSEL !== 2'd1) begin
                $display("ASSERTION FAILED: Expected 2'd1, got %b", OUT_DATA2ALUSEL);
                $finish;
            end
            if (OUT_DATA1BJSEL !== 2'd1) begin
                $display("ASSERTION FAILED: Expected 2'd1, got %b", OUT_DATA1BJSEL);
                $finish;
            end
            if (OUT_DATA2BJSEL !== 2'd1) begin
                $display("ASSERTION FAILED: Expected 2'd1, got %b", OUT_DATA2BJSEL);
                $finish;
            end
            if (OUT_ALU_OP !== 5'd15) begin
                $display("ASSERTION FAILED: Expected 5'd15, got %b", OUT_ALU_OP);
                $finish;
            end
            if (OUT_BRANCH_JUMP !== 3'd2) begin
                $display("ASSERTION FAILED: Expected 3'd2, got %b", OUT_BRANCH_JUMP);
                $finish;
            end
            if (OUT_DATAMEMSEL !== 1'd1) begin
                $display("ASSERTION FAILED: Expected 1'd1, got %b", OUT_DATAMEMSEL);
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
            if (OUT_REG_WRITE_EN !== 1'b0) begin
                $display("ASSERTION FAILED: Expected 1'b0, got %b", OUT_REG_WRITE_EN);
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