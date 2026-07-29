`timescale 1ns/1ps

module branch_control_unit_tb;

    reg  [4:0] opcode;
    reg        Zero_Flag;
    reg        Set;

    wire       Branch;

    branch_control_unit DUT(
        .opcode(opcode),
        .Zero_Flag(Zero_Flag),
        .Set(Set),
        .Branch(Branch)
    );

    task show;
    begin
        $display("--------------------------------");
        $display("TIME       = %0t", $time);
        $display("OPCODE     = %0d", opcode);
        $display("ZERO_FLAG  = %b", Zero_Flag);
        $display("SET        = %b", Set);
        $display("BRANCH     = %b", Branch);
        $display("--------------------------------\n");
    end
    endtask

    initial begin

        //--------------------------------
        // BEQ TAKEN
        //--------------------------------
        opcode = 14;
        Zero_Flag = 1;
        Set = 0;
        #10;
        $display("BEQ TAKEN");
        show();

        //--------------------------------
        // BEQ NOT TAKEN
        //--------------------------------
        opcode = 14;
        Zero_Flag = 0;
        #10;
        $display("BEQ NOT TAKEN");
        show();

        //--------------------------------
        // BNE TAKEN
        //--------------------------------
        opcode = 15;
        Zero_Flag = 0;
        #10;
        $display("BNE TAKEN");
        show();

        //--------------------------------
        // BNE NOT TAKEN
        //--------------------------------
        opcode = 15;
        Zero_Flag = 1;
        #10;
        $display("BNE NOT TAKEN");
        show();

        //--------------------------------
        // BLT TAKEN
        //--------------------------------
        opcode = 16;
        Set = 1;
        #10;
        $display("BLT TAKEN");
        show();

        //--------------------------------
        // BLT NOT TAKEN
        //--------------------------------
        opcode = 16;
        Set = 0;
        #10;
        $display("BLT NOT TAKEN");
        show();

        //--------------------------------
        // BGE TAKEN
        //--------------------------------
        opcode = 17;
        Set = 0;
        #10;
        $display("BGE TAKEN");
        show();

        //--------------------------------
        // BGE NOT TAKEN
        //--------------------------------
        opcode = 17;
        Set = 1;
        #10;
        $display("BGE NOT TAKEN");
        show();

        $display("===== TEST COMPLETE =====");

        #10;
        $finish;

    end

endmodule