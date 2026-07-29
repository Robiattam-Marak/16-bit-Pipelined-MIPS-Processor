//=========================================================
// TESTBENCH : INSTRUCTION MEMORY
//=========================================================
`timescale 1ns/1ps

module tb_instruction_memory;

    reg [15:0] address;

    wire [15:0] instruction;

    wire [4:0] opcode;

    wire [2:0] rs;
    wire [2:0] rt;
    wire [2:0] rd;

    wire [4:0] imm_5;

    wire [10:0] imm_11;

    wire [1:0] func;

    //-----------------------------------------------------
    // DUT
    //-----------------------------------------------------
    instruction_memory DUT (

        .address(address),

        .instruction(instruction),

        .opcode(opcode),

        .rs(rs),
        .rt(rt),
        .rd(rd),

        .imm_5(imm_5),
        .imm_11(imm_11),

        .func(func)
    );

    //-----------------------------------------------------
    // TEST
    //-----------------------------------------------------
    initial
    begin

        $display("===== INSTRUCTION MEMORY TEST =====");

        //-------------------------------------------------
        // READ ROM[0]
        //-------------------------------------------------
        address = 0;

        #10;

        $display("ADDRESS = %d", address);
        $display("INSTRUCTION = %b", instruction);

        //-------------------------------------------------
        // READ ROM[1]
        //-------------------------------------------------
        address = 1;

        #10;

        $display("ADDRESS = %d", address);
        $display("INSTRUCTION = %b", instruction);

        //-------------------------------------------------
        // READ ROM[2]
        //-------------------------------------------------
        address = 2;

        #10;

        $display("ADDRESS = %d", address);
        $display("INSTRUCTION = %b", instruction);

        //-------------------------------------------------
        // READ ROM[3]
        //-------------------------------------------------
        address = 3;

        #10;

        $display("ADDRESS = %d", address);
        $display("INSTRUCTION = %b", instruction);

        //-------------------------------------------------
        // FINISH
        //-------------------------------------------------
        #20;

        $finish;

    end

endmodule