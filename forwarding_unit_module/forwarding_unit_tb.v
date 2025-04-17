`include "forwarding_unit.v"
`include "../utils/macros.v"
`include "../utils/encodings.v"

module forwarding_unit_tb;

    reg [4:0] ADDR1, ADDR2, WB_ADDR, MEM_ADDR, EXE_ADDR;
    reg OP1SEL, OP2SEL;
    reg [6:0] OPCODE;
    wire DATA1IDSEL, DATA2IDSEL, DATAMEMSEL;
    wire [1:0] DATA1ALUSEL, DATA2ALUSEL, DATA1BJSEL, DATA2BJSEL;

    integer j;
    forwarding_unit my_forwarding_unit(ADDR1, ADDR2, WB_ADDR, MEM_ADDR, EXE_ADDR, OP1SEL, OP2SEL, OPCODE, 
                                       DATA1IDSEL, DATA2IDSEL, DATA1ALUSEL, DATA2ALUSEL, DATA1BJSEL, DATA2BJSEL, DATAMEMSEL);

    initial begin
        $dumpfile("forwarding_unit_wavedata.vcd");
        $dumpvars(0, forwarding_unit_tb);

        /* ------- Forwarding unit Test 01 ----------
            Able to detect RW -> MEM data dependency
            lw r1 8(r2)
            sw r1 8(r3)
        */
        begin
            WB_ADDR = 5'd0;
            MEM_ADDR = 5'd0;
            EXE_ADDR = 5'd1;
            ADDR1 = 5'd3;
            ADDR2 = 5'd1;

            OP1SEL = 1'b0;
            OP2SEL = 1'b1;
            OPCODE = `STORE_OPCODE;

            #1;
            `assert(DATA1IDSEL, 1'b0)
            `assert(DATA2IDSEL, 1'b0)
            `assert(DATA1ALUSEL, 2'b00)
            `assert(DATA2ALUSEL, 2'b01)
            `assert(DATAMEMSEL, 1'b1)
            `assert(DATA1BJSEL, 2'b00)
            `assert(DATA2BJSEL, 2'b11)
            $display("Forwarding unit Test 01 - Able to detect RW -> MEM data dependency test passed!");
        end

        /* ------- Forwarding unit Test 02 ----------
            Able to detect RW -> EXE data dependency
            lw r1 8(r2)
            sub r5,r6,r7
            add r3,r2,r1
        */
        begin
            WB_ADDR = 5'd0;
            MEM_ADDR = 5'd1;
            EXE_ADDR = 5'd5;
            ADDR1 = 5'd2;
            ADDR2 = 5'd1;

            OP1SEL = 1'b0;
            OP2SEL = 1'b0;
            OPCODE = `R_TYPE_OPCODE;

            #1;
            `assert(DATA1IDSEL, 1'b0)
            `assert(DATA2IDSEL, 1'b0)
            `assert(DATA1ALUSEL, 2'b00)
            `assert(DATA2ALUSEL, 2'b10)
            `assert(DATAMEMSEL, 1'b0)
            `assert(DATA1BJSEL, 2'b00)
            `assert(DATA2BJSEL, 2'b10)
            $display("Forwarding unit Test 02 - Able to detect RW -> EXE data dependency test passed!");
        end

        /* ------- Forwarding unit Test 03 ----------
            Able to detect RW -> ID data dependency
            lw r1 8(r2)
            sub r5,r6,r7
            sub r8,r9,r10
            add r3,r2,r1
        */
        begin
            WB_ADDR = 5'd1;
            MEM_ADDR = 5'd5;
            EXE_ADDR = 5'd8;
            ADDR1 = 5'd2;
            ADDR2 = 5'd1;

            OP1SEL = 1'b0;
            OP2SEL = 1'b0;
            OPCODE = `R_TYPE_OPCODE;

            #1;
            `assert(DATA1IDSEL, 1'b0)
            `assert(DATA2IDSEL, 1'b1)
            `assert(DATA1ALUSEL, 2'b00)
            `assert(DATA2ALUSEL, 2'b00)
            `assert(DATAMEMSEL, 1'b0)
            `assert(DATA1BJSEL, 2'b00)
            `assert(DATA2BJSEL, 2'b00)
            $display("Forwarding unit Test 03 - Able to detect RW -> ID data dependency test passed!");
        end

        /* ------- Forwarding unit Test 04 ----------
            Able to detect MEM -> EXE data dependency
            add r1 r2 r3
            sub r5 r1 r4
        */
        begin
            WB_ADDR = 5'd0;
            MEM_ADDR = 5'd0;
            EXE_ADDR = 5'd1;
            ADDR1 = 5'd1;
            ADDR2 = 5'd4;

            OP1SEL = 1'b0;
            OP2SEL = 1'b0;
            OPCODE = `R_TYPE_OPCODE;

            #1;
            `assert(DATA1IDSEL, 1'b0)
            `assert(DATA2IDSEL, 1'b0)
            `assert(DATA1ALUSEL, 2'b11)
            `assert(DATA2ALUSEL, 2'b00)
            `assert(DATAMEMSEL, 1'b0)
            `assert(DATA1BJSEL, 2'b11)
            `assert(DATA2BJSEL, 2'b00)
            $display("Forwarding unit Test 04 - Able to detect MEM -> EXE data dependency test passed!");
        end

        /* ------- Forwarding unit Test 05 ----------
            No data dependency
            add r1 r2 r3
            sub r5 r6 r4
        */
        begin
            WB_ADDR = 5'd0;
            MEM_ADDR = 5'd0;
            EXE_ADDR = 5'd1;
            ADDR1 = 5'd6;
            ADDR2 = 5'd4;

            OP1SEL = 1'b0;
            OP2SEL = 1'b0;
            OPCODE = `R_TYPE_OPCODE;

            #1;
            `assert(DATA1IDSEL, 1'b0)
            `assert(DATA2IDSEL, 1'b0)
            `assert(DATA1ALUSEL, 2'b00)
            `assert(DATA2ALUSEL, 2'b00)
            `assert(DATAMEMSEL, 1'b0)
            `assert(DATA1BJSEL, 2'b00)
            `assert(DATA2BJSEL, 2'b00)
            $display("Forwarding unit Test 05 - No data dependency test passed!");
        end

        /* ------- Forwarding unit Test 06 ----------
            All dependencies
            add r1 r2 r3
            add r4 r1 r2
            add r5 r1 r2
            add r6 r1 r2
        */
        begin
            WB_ADDR = 5'd1;
            MEM_ADDR = 5'd4;
            EXE_ADDR = 5'd5;
            ADDR1 = 5'd1;
            ADDR2 = 5'd2;

            OP1SEL = 1'b0;
            OP2SEL = 1'b0;
            OPCODE = `R_TYPE_OPCODE;

            #1;
            `assert(DATA1IDSEL, 1'b1)
            `assert(DATA2IDSEL, 1'b0)
            `assert(DATA1ALUSEL, 2'b00)
            `assert(DATA2ALUSEL, 2'b00)
            `assert(DATAMEMSEL, 1'b0)
            `assert(DATA1BJSEL, 2'b00)
            `assert(DATA2BJSEL, 2'b00)
            $display("Forwarding unit Test 06 - All dependencies test passed!");
        end

        #500;
        $finish;
    end

endmodule