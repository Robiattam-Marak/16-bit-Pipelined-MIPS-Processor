module register_file(

    input clk,
    input reset,
    input RegWrite,

    input  [2:0] ReadRegister1,
    input  [2:0] ReadRegister2,
    input  [2:0] WriteRegister,

    input  [15:0] WriteData,

    output [15:0] ReadData1,
    output [15:0] ReadData2
);

//////////////////////////////////////////////////////
// Internal Signals
//////////////////////////////////////////////////////

wire [7:0] dec_out;

wire en1;
wire en2;
wire en3;
wire en4;
wire en5;
wire en6;
wire en7;

wire [15:0] R0;
wire [15:0] R1;
wire [15:0] R2;
wire [15:0] R3;
wire [15:0] R4;
wire [15:0] R5;
wire [15:0] R6;
wire [15:0] R7;

//////////////////////////////////////////////////////
// Decoder
//////////////////////////////////////////////////////

decoder3_8 DEC(
    .sel(WriteRegister),
    .out(dec_out)
);

//////////////////////////////////////////////////////
// Write Enables
//////////////////////////////////////////////////////

assign en1 = dec_out[1] & RegWrite;
assign en2 = dec_out[2] & RegWrite;
assign en3 = dec_out[3] & RegWrite;
assign en4 = dec_out[4] & RegWrite;
assign en5 = dec_out[5] & RegWrite;
assign en6 = dec_out[6] & RegWrite;
assign en7 = dec_out[7] & RegWrite;

//////////////////////////////////////////////////////
// R0 Hardwired to Zero
//////////////////////////////////////////////////////

assign R0 = 16'h0000;

//////////////////////////////////////////////////////
// Registers R1-R7
//////////////////////////////////////////////////////

register16 REG1(
    .clk(clk),
    .reset(reset),
    .en(en1),
    .d(WriteData),
    .q(R1)
);

register16 REG2(
    .clk(clk),
    .reset(reset),
    .en(en2),
    .d(WriteData),
    .q(R2)
);

register16 REG3(
    .clk(clk),
    .reset(reset),
    .en(en3),
    .d(WriteData),
    .q(R3)
);

register16 REG4(
    .clk(clk),
    .reset(reset),
    .en(en4),
    .d(WriteData),
    .q(R4)
);

register16 REG5(
    .clk(clk),
    .reset(reset),
    .en(en5),
    .d(WriteData),
    .q(R5)
);

register16 REG6(
    .clk(clk),
    .reset(reset),
    .en(en6),
    .d(WriteData),
    .q(R6)
);

register16 REG7(
    .clk(clk),
    .reset(reset),
    .en(en7),
    .d(WriteData),
    .q(R7)
);

//////////////////////////////////////////////////////
// Read Port 1
//////////////////////////////////////////////////////

mux8to1_16bit MUX1(

    .sel(ReadRegister1),

    .in0(R0),
    .in1(R1),
    .in2(R2),
    .in3(R3),
    .in4(R4),
    .in5(R5),
    .in6(R6),
    .in7(R7),

    .out(ReadData1)
);

//////////////////////////////////////////////////////
// Read Port 2
//////////////////////////////////////////////////////

mux8to1_16bit MUX2(

    .sel(ReadRegister2),

    .in0(R0),
    .in1(R1),
    .in2(R2),
    .in3(R3),
    .in4(R4),
    .in5(R5),
    .in6(R6),
    .in7(R7),

    .out(ReadData2)
);

endmodule