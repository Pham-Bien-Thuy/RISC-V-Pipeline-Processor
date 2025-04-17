`include "../utils/macros.v" 
`include "reg_file.v"

module reg_file_tb;

    reg CLK, RESET, WRITE_ENABLE;
    reg [31:0] WRITE_DATA;
    wire [31:0] DATA1, DATA2;
    reg [4:0] DATA1_ADDRESS, DATA2_ADDRESS, WRITE_ADDRESS;

    integer j;

    reg_file my_reg_file(WRITE_DATA, DATA1, DATA2, WRITE_ADDRESS, DATA1_ADDRESS, DATA2_ADDRESS, WRITE_ENABLE, CLK, RESET);

    initial begin
        CLK = 1'b0;
        RESET = 1'b0;
        WRITE_DATA = 32'd0;
        DATA1_ADDRESS = 5'd0;
        DATA2_ADDRESS = 5'd0;
        WRITE_ADDRESS = 5'd0;
        WRITE_ENABLE = 1'b0;

        $dumpfile("reg_file_wavedata.vcd");
        $dumpvars(0, reg_file_tb);
	$dumpvars(0, my_reg_file.REGISTER);
        /*
            Test 0: RESET TEST
            Verify all registers reset to 0
        */
        begin
            #1
            RESET = 1'b1;

            #5
            RESET = 1'b0;

            @(posedge CLK) begin
                #3
                DATA1_ADDRESS = 5'd0;  // Check R0
                DATA2_ADDRESS = 5'd1;  // Check R1
                #3
                `assert(DATA1, 32'd0)
                `assert(DATA2, 32'd0)
                $display("TEST 0: RESET TEST Passed!");
            end
        end

        /*
            Test 1: WRITE TO REGISTER
            Regfile should write 10 to reg 1
        */
        begin
            WRITE_ADDRESS = 5'd1;
            WRITE_DATA = 32'd10;
            WRITE_ENABLE = 1'b1;

            @(posedge CLK) begin
                #3
                DATA1_ADDRESS = 5'd1;
                #3
                `assert(DATA1, 32'd10)
                $display("TEST 1: WRITE TO REGISTER Passed!");
            end
        end

        /*
            Test 2: NO WRITE TO R0
            Regfile should not write to R0
        */
        begin
            WRITE_ADDRESS = 5'd0;
            WRITE_DATA = 32'd10;
            WRITE_ENABLE = 1'b1;

            @(posedge CLK) begin
                #3
                DATA1_ADDRESS = 5'd0;
                #3
                `assert(DATA1, 32'd0)
                $display("TEST 2: NO WRITE TO R0 Passed!");
            end
        end

        #500
        $finish;
    end

    // Clock generation
    always begin
        #4 CLK = ~CLK;
    end

endmodule