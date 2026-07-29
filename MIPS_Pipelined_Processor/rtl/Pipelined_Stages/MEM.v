//=========================================================
// MEMORY STAGE
//=========================================================

module mem_stage(

    input clk,

    //-------------------------
    // FROM EX/MEM
    //-------------------------
    input [15:0] ALU_Result,
    input [15:0] Rt_Value,

    input MemRead,
    input MemWrite,
    input MemtoReg,

    //-------------------------
    // TO WB
    //-------------------------
    output [15:0] WriteData,

    //-------------------------
    // Forwarding
    //-------------------------
    output [15:0] MEM_Fwd

);

wire [15:0] MemData;

//////////////////////////////////////////////////////
// Data Memory
//////////////////////////////////////////////////////

data_memory DM(

    .clk(clk),

    .MemWr(MemWrite),
    .MemRd(MemRead),

    .address(ALU_Result),

    .write_data(Rt_Value),

    .read_data(MemData)

);

//////////////////////////////////////////////////////
// MemtoReg MUX
//////////////////////////////////////////////////////

assign WriteData =
        MemtoReg ?
        MemData :
        ALU_Result;

//////////////////////////////////////////////////////
// MEM Forward
//////////////////////////////////////////////////////

assign MEM_Fwd = WriteData;

endmodule