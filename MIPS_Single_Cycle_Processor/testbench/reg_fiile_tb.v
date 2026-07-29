`timescale 1ns / 1ps

module tb_register_file;

//////////////////////////////////////////////////////
// Inputs
//////////////////////////////////////////////////////

reg clk;
reg RegWrite;

reg [2:0] ReadRegister1;
reg [2:0] ReadRegister2;
reg [2:0] WriteRegister;

reg [15:0] WriteData;

//////////////////////////////////////////////////////
// Outputs
//////////////////////////////////////////////////////

wire [15:0] ReadData1;
wire [15:0] ReadData2;

//////////////////////////////////////////////////////
// Instantiate Register File
//////////////////////////////////////////////////////

register_file DUT (

    .clk(clk),
    .RegWrite(RegWrite),

    .ReadRegister1(ReadRegister1),
    .ReadRegister2(ReadRegister2),
    .WriteRegister(WriteRegister),

    .WriteData(WriteData),

    .ReadData1(ReadData1),
    .ReadData2(ReadData2)

);

//////////////////////////////////////////////////////
// Clock Generation
//////////////////////////////////////////////////////

always #5 clk = ~clk;

//////////////////////////////////////////////////////
// Test Procedure
//////////////////////////////////////////////////////

initial begin

    //////////////////////////////////////////////
    // Initialize
    //////////////////////////////////////////////

    clk = 0;

    RegWrite = 0;

    ReadRegister1 = 3'b000;
    ReadRegister2 = 3'b000;

    WriteRegister = 3'b000;
    WriteData = 16'b0;

    #10;

    //////////////////////////////////////////////
    // Write 25 into R1
    //////////////////////////////////////////////

    RegWrite = 1;

    WriteRegister = 3'b001;
    WriteData = 16'd25;

    #10;

    //////////////////////////////////////////////
    // Write 50 into R2
    //////////////////////////////////////////////

    WriteRegister = 3'b010;
    WriteData = 16'd50;

    #10;

    //////////////////////////////////////////////
    // Write 100 into R3
    //////////////////////////////////////////////

    WriteRegister = 3'b011;
    WriteData = 16'd100;

    #10;

    //////////////////////////////////////////////
    // Disable Write
    //////////////////////////////////////////////

    RegWrite = 0;

    #10;

    //////////////////////////////////////////////
    // Read R1 and R2
    //////////////////////////////////////////////

    ReadRegister1 = 3'b001;
    ReadRegister2 = 3'b010;

    #10;

    $display("--------------------------------");
    $display("R1 = %d", ReadData1);
    $display("R2 = %d", ReadData2);
    $display("--------------------------------");

    //////////////////////////////////////////////
    // Read R3
    //////////////////////////////////////////////

    ReadRegister1 = 3'b011;

    #10;

    $display("--------------------------------");
    $display("R3 = %d", ReadData1);
    $display("--------------------------------");

    //////////////////////////////////////////////
    // Read R0 (Should always be ZERO)
    //////////////////////////////////////////////

    ReadRegister1 = 3'b000;

    #10;

    $display("--------------------------------");
    $display("R0 = %d", ReadData1);
    $display("--------------------------------");

    //////////////////////////////////////////////
    // Try Writing into R0
    //////////////////////////////////////////////

    RegWrite = 1;

    WriteRegister = 3'b000;
    WriteData = 16'd999;

    #10;

    ReadRegister1 = 3'b000;

    #10;

    $display("--------------------------------");
    $display("After write attempt:");
    $display("R0 = %d", ReadData1);
    $display("--------------------------------");

    //////////////////////////////////////////////
    // Finish Simulation
    //////////////////////////////////////////////

    #20;

    $finish;

end

endmodule