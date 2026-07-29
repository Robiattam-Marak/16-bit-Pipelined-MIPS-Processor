`timescale 1ns/1ps

module cpu16_pipeline_tb;

    reg clk;
    reg reset;

    cpu16_pipeline DUT (
        .clk(clk),
        .reset(reset)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;      // 10 ns clock period
    end

    initial begin
        reset = 1;
        #20;
        reset = 0;

        #1000;

        $display("Simulation Finished");
        $finish;
    end

    initial begin
        $dumpfile("cpu16_pipeline.vcd");
        $dumpvars(0,cpu16_pipeline_tb);
    end

    initial begin

        $display("---------------------------------------------------------------------------------------------------------------------------------------------------------------");
        $display("Time\tPC\tInstr\tIDEX_RD\tEXMEM_RD\tMEMWB_RD\tWB_RD\tALU_Result\tMEM_Data\tWB_Data");
        $display("---------------------------------------------------------------------------------------------------------------------------------------------------------------");

        $monitor("%0t\t%h\t%h\t%d\t%d\t%d\t%d\t%h\t%h\t%h",

            $time,

            DUT.PC,
            DUT.Instruction,

            DUT.IDEX_RD,
            DUT.EXMEM_RD,
            DUT.MEMWB_RD,
            DUT.WriteRegWB,

            DUT.ALU_Result,
            DUT.MemData,
            DUT.WriteDataWB

        );

    end

endmodule