`include "../utils/macros.v"
`include "../utils/encodings.v"
`include "immediate_generate.v"

module immediate_generate_tb;

    reg [24:0] IN;            // instruction[31:7] -> 25 bits (corrected from 24 bits in comment)
    reg [2:0] IMM_SEL;        // immediate select op
    wire [31:0] OUT;          // sign-extended 32-bit value

    immediate_generate my_immediate_generate(IN, OUT, IMM_SEL);

    initial begin
        
        $dumpfile("immediate_generate_wavedata.vcd");
        $dumpvars(0, immediate_generate_tb);

        #10
        // U-type test
        IN = 25'b1011000000111000100010100; 
        IMM_SEL = `U_TYPE;
        #1
        if (OUT !== 32'b10110000001110001000_000000000000) begin
            $display("ASSERTION FAILED: Expected 32'b10110000001110001000_000000000000, got %b", OUT);
            $finish;
        end
        $display("U Test Passed!");

        #5
        // J-type test
        IN = 25'b1_0001101110_1_01001110_01010;
        IMM_SEL = `J_TYPE;
        #1
        if (OUT !== 32'b11111111111_01001110_1_0001101110_00) begin
            $display("ASSERTION FAILED: Expected 32'b11111111111_01001110_1_0001101110_00, got %b", OUT);
            $finish;
        end
        $display("J Test Passed!");

        #5
        // S-type test
        IN = 25'b1010010_01001_10100_010_00101;
        IMM_SEL = `S_TYPE;
        #1
        if (OUT !== 32'b11111111111111111111_1010010_00101) begin
            $display("ASSERTION FAILED: Expected 32'b11111111111111111111_1010010_00101, got %b", OUT);
            $finish;
        end
        $display("S Test Passed!");

        #5
        // B-type test
        IN = 25'b1_010000_11011_10101_110_0101_0;
        IMM_SEL = `B_TYPE;
        #1
        if (OUT !== 32'b1111111111111111111_0_010000_0101_00) begin
            $display("ASSERTION FAILED: Expected 32'b1111111111111111111_0_010000_0101_00, got %b", OUT);
            $finish;
        end
        $display("B Test Passed!");

        #5
        // I_SIGNED-type test
        IN = 25'b101001001001_10100_010_00101;
        IMM_SEL = `I_SIGNED_TYPE;
        #1
        if (OUT !== 32'b11111111111111111111_101001001001) begin
            $display("ASSERTION FAILED: Expected 32'b11111111111111111111_101001001001, got %b", OUT);
            $finish;
        end
        $display("I_SIGNED Test Passed!");

        #5
        // I_SHIFT-type test
        IN = 25'b1010010_01001_10100_010_00101;
        IMM_SEL = `I_SHIFT_TYPE;
        #1
        if (OUT !== 32'b0000000000000000000000000_01001) begin
            $display("ASSERTION FAILED: Expected 32'b0000000000000000000000000_01001, got %b", OUT);
            $finish;
        end
        $display("I_SHIFT Test Passed!");

        #5
        // I_UNSIGNED-type test
        IN = 25'b101001001001_10100_010_00101;
        IMM_SEL = `I_UNSIGNED_TYPE;
        #1
        if (OUT !== 32'b00000000000000000000_101001001001) begin
            $display("ASSERTION FAILED: Expected 32'b00000000000000000000_101001001001, got %b", OUT);
            $finish;
        end
        $display("I_UNSIGNED Test Passed!");

        $display("All Tests Passed!");

        $finish;
    end

endmodule