`include "../utils/macros.v"
`include "../utils/encodings.v"
`include "bj_detect.v"

`define DECODE_DELAY #3

module bj_detect_tb;
    
    reg [2:0] BRANCH_JUMP;
    reg [31:0] DATA1, DATA2;

    wire PC_SEL;
    wire debugLt, debugEq;
    
    bj_detect my_bj_detect_module(BRANCH_JUMP, DATA1, DATA2, PC_SEL);

    initial begin

        // ------- BEQ Test 01 ----------
        // DATA1 = DATA2 (Branch Taken)
        begin
            BRANCH_JUMP = `BEQ;
            DATA1 = 32'd10;
            DATA2 = 32'd10;
            `DECODE_DELAY
            `assert(PC_SEL, 1)
            $display("BEQ Test 01   - Branch taken test passed!");
        end
        
        // ------- BEQ Test 02 ----------
        // DATA1 != DATA2 (Branch not Taken)
        begin
            BRANCH_JUMP = `BEQ;
            DATA1 = 32'd15;
            DATA2 = 32'd10;
            `DECODE_DELAY
            `assert(PC_SEL, 0)
            $display("BEQ Test 02   - Branch not taken test passed!");
        end
        
        // ------- BNE Test 01 ----------
        // DATA1 != DATA2 (Branch Taken)
        begin
            BRANCH_JUMP = `BNE;
            DATA1 = 32'd10;
            DATA2 = 32'd11;
            `DECODE_DELAY
            `assert(PC_SEL, 1)
            $display("BNE Test 01   - Branch taken test passed!");
        end
        
        // ------- BNE Test 02 ----------
        // DATA1 = DATA2 (Branch not Taken)
        begin
            BRANCH_JUMP = `BNE;
            DATA1 = 32'd10;
            DATA2 = 32'd10;
            `DECODE_DELAY
            `assert(PC_SEL, 0)
            $display("BNE Test 02   - Branch not taken test passed!");
        end

        // ------- NO BRANCH/JUMP Test  ----------
        begin
            BRANCH_JUMP = `NO;
            DATA1 = 32'dx;
            DATA2 = 32'dx;
            `DECODE_DELAY
            `assert(PC_SEL, 0)
            $display("NO branch/jump test passed!");
        end

        // ------- J Test  ----------
        begin
            BRANCH_JUMP = `J;
            DATA1 = 32'dx;
            DATA2 = 32'dx;
            `DECODE_DELAY
            `assert(PC_SEL, 1)
            $display("J test passed!");
        end

        // ------- BLT Test 01  ----------
        // DATA1 < DATA2 (Branch Taken)
        begin
            BRANCH_JUMP = `BLT;
            DATA1 = 32'd10;
            DATA2 = 32'd15;
            `DECODE_DELAY
            `assert(PC_SEL, 1)
            $display("BLT Test 01   - Branch taken passed!");
        end

        // ------- BLT Test 02  ----------
        // DATA1 > DATA2 (Branch not Taken)
        begin
            BRANCH_JUMP = `BLT;
            DATA1 = 32'd15;
            DATA2 = 32'd10;
            `DECODE_DELAY
            `assert(PC_SEL, 0)
            $display("BLT Test 02   - Branch not taken passed!");
        end

        // ------- BLT Test 03  ----------
        // DATA1 = DATA2 (Branch not Taken)
        begin
            BRANCH_JUMP = `BLT;
            DATA1 = 32'd10;
            DATA2 = 32'd10;
            `DECODE_DELAY
            `assert(PC_SEL, 0)
            $display("BLT Test 03   - Branch not taken passed!");
        end
        
        // ------- BGE Test 01  ----------
        // DATA1 > DATA2 (Branch Taken)
        begin
            BRANCH_JUMP = `BGE;
            DATA1 = 32'd15;
            DATA2 = 32'd10;
            `DECODE_DELAY
            `assert(PC_SEL, 1)
            $display("BGE Test 01   - Branch taken passed!");
        end
        
        // ------- BGE Test 02  ----------
        // DATA1 = DATA2 (Branch Taken)
        begin
            BRANCH_JUMP = `BGE;
            DATA1 = 32'd10;
            DATA2 = 32'd10;
            `DECODE_DELAY
            `assert(PC_SEL, 1)
            $display("BGE Test 02   - Branch taken passed!");
        end

        // ------- BGE Test 03  ----------
        // DATA1 < DATA2 (Branch not Taken)
        begin
            BRANCH_JUMP = `BGE;
            DATA1 = 32'd10;
            DATA2 = 32'd15;
            `DECODE_DELAY
            `assert(PC_SEL, 0)
            $display("BGE Test 03   - Branch not taken passed!");
        end

        // ------- BLTU Test 01  ----------
        // DATA1 < DATA2 (Branch Taken)
        begin
            BRANCH_JUMP = `BLTU;
            DATA1 = 32'h0003;
            DATA2 = 32'h8004;
            `DECODE_DELAY
            `assert(PC_SEL, 1)
            $display("BLTU Test 01   - Branch taken passed!");
        end

        // ------- BLTU Test 02  ----------
        // DATA1 > DATA2 (Branch not Taken)
        begin
            BRANCH_JUMP = `BLTU;
            DATA1 = 32'h8004;
            DATA2 = 32'h0003;
            `DECODE_DELAY
            `assert(PC_SEL, 0)
            $display("BLTU Test 02   - Branch not taken passed!");
        end

        // ------- BLTU Test 03  ----------
        // DATA1 = DATA2 (Branch not Taken)
        begin
            BRANCH_JUMP = `BLTU;
            DATA1 = 32'h8004;
            DATA2 = 32'h8004;
            `DECODE_DELAY
            `assert(PC_SEL, 0)
            $display("BLTU Test 03   - Branch not taken passed!");
        end

        // ------- BGEU Test 01  ----------
        // DATA1 > DATA2 (Branch Taken)
        begin
            BRANCH_JUMP = `BGEU;
            DATA1 = 32'h8005;
            DATA2 = 32'h8004;
            `DECODE_DELAY
            `assert(PC_SEL, 1)
            $display("BGEU Test 01   - Branch taken passed!");
        end
        
        // ------- BGEU Test 02  ----------
        // DATA1 = DATA2 (Branch Taken)
        begin
            BRANCH_JUMP = `BGEU;
            DATA1 = 32'h8005;
            DATA2 = 32'h8005;
            `DECODE_DELAY
            `assert(PC_SEL, 1)
            $display("BGEU Test 02   - Branch taken passed!");
        end

        // ------- BGEU Test 03  ----------
        // DATA1 < DATA2 (Branch not Taken)
        begin
            BRANCH_JUMP = `BGEU;
            DATA1 = 32'h8004;
            DATA2 = 32'h8005;
            `DECODE_DELAY
            `assert(PC_SEL, 0)
            $display("BGEU Test 03   - Branch not taken passed!");
        end

        $display("All Tests Passed !!!");
    end

endmodule