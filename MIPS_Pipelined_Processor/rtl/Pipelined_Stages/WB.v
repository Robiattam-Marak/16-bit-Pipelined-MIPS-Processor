//=========================================================
// WRITE BACK STAGE
//=========================================================

module wb_stage(

    input [15:0] WriteData,
    input [2:0]  RD,
    input        RegWrite,

    output [15:0] WB_Data,
    output [2:0]  WB_RD,
    output        WB_RegWrite,

    output [15:0] WB_Fwd

);

assign WB_Data = WriteData;

assign WB_RD = RD;

assign WB_RegWrite = RegWrite;

assign WB_Fwd = WriteData;

endmodule