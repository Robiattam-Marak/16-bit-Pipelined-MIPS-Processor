`timescale 1ns/1ps

module cpu16_tb;

/////////////////////////////////////////////////
// TEST SIGNALS
/////////////////////////////////////////////////

reg clk;
reg reset;

/////////////////////////////////////////////////
// DUT
/////////////////////////////////////////////////

cpu16 DUT(
    .clk(clk),
    .reset(reset)
);

/////////////////////////////////////////////////
// CLOCK
/////////////////////////////////////////////////

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

/////////////////////////////////////////////////
// RESET
/////////////////////////////////////////////////

initial begin
    reset = 1;
    #20;
    reset = 0;
end

/////////////////////////////////////////////////
// HEADER
/////////////////////////////////////////////////

initial begin

    $display("");
    $display("==============================================================================================================");
    $display("TIME    PC    INST   OP RS RT RD IMM   WRREG WDATA  RD1   RD2   ALUB  ALUOUT");
    $display("==============================================================================================================");

end

/////////////////////////////////////////////////
// MAIN TRACE
/////////////////////////////////////////////////

always @(posedge clk)
begin

    if(!reset)
    begin

        $display("%0t  %h  %h  %h  %d %d %d %h  %d  %h  %h  %h  %h  %h",

            $time,

            DUT.PC,
            DUT.instruction,
            DUT.opcode,

            DUT.rs,
            DUT.rt,
            DUT.rd,

            DUT.ExtendedImm,

            DUT.WriteReg,
            DUT.WriteData,

            DUT.ReadData1,
            DUT.ReadData2,

            DUT.ALU_B,
            DUT.ALU_Result
        );

        $display("CTRL : RegWr=%b RegDst=%b ALUSrc=%b MemRd=%b MemWr=%b MemToReg=%b",
            DUT.RegWr,
            DUT.RegDst,
            DUT.ALUSrc,
            DUT.MemRd,
            DUT.MemWr,
            DUT.MemtoReg
        );

        $display("EN   : %b %b %b %b %b %b %b",
            DUT.RF.en1,
            DUT.RF.en2,
            DUT.RF.en3,
            DUT.RF.en4,
            DUT.RF.en5,
            DUT.RF.en6,
            DUT.RF.en7
        );

        $display("REGS : R1=%h R2=%h R3=%h R4=%h R5=%h R6=%h R7=%h",
            DUT.RF.R1,
            DUT.RF.R2,
            DUT.RF.R3,
            DUT.RF.R4,
            DUT.RF.R5,
            DUT.RF.R6,
            DUT.RF.R7
        );

        $display("----------------------------------------------------");

    end

end

/////////////////////////////////////////////////
// FINAL REPORT
/////////////////////////////////////////////////

initial begin

    #300;

    $display("");
    $display("========================================================");
    $display("FINAL REGISTER FILE");
    $display("========================================================");

    $display("R0 = %h", DUT.RF.R0);
    $display("R1 = %h", DUT.RF.R1);
    $display("R2 = %h", DUT.RF.R2);
    $display("R3 = %h", DUT.RF.R3);
    $display("R4 = %h", DUT.RF.R4);
    $display("R5 = %h", DUT.RF.R5);
    $display("R6 = %h", DUT.RF.R6);
    $display("R7 = %h", DUT.RF.R7);

    $display("");
    $display("========================================================");
    $display("REGISTER OUTPUTS");
    $display("========================================================");

    $display("REG1.q = %h", DUT.RF.REG1.q);
    $display("REG2.q = %h", DUT.RF.REG2.q);
    $display("REG3.q = %h", DUT.RF.REG3.q);
    $display("REG4.q = %h", DUT.RF.REG4.q);
    $display("REG5.q = %h", DUT.RF.REG5.q);
    $display("REG6.q = %h", DUT.RF.REG6.q);
    $display("REG7.q = %h", DUT.RF.REG7.q);

    $display("");
    $display("========================================================");
    $display("DATA MEMORY");
    $display("========================================================");

    $display("MEM[10] = %h", DUT.DM.RAM[10]);
    $display("MEM[11] = %h", DUT.DM.RAM[11]);

    $display("");
    $display("========================================================");
    $display("CPU TEST COMPLETE");
    $display("========================================================");

    $finish;

end

endmodule