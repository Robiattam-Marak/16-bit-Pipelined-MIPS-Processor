//=========================================================
// EXECUTE STAGE
//=========================================================

module ex_stage(

    //-----------------------------------------------------
    // DATA FROM ID/EX
    //-----------------------------------------------------
    input [15:0] PC,

    input [15:0] BUS_A,
    input [15:0] BUS_B,

    input [15:0] Imm,
    input [15:0] LUI_Imm,

    input [2:0] RD,

    //-----------------------------------------------------
    // CONTROL
    //-----------------------------------------------------
    input ALUSrc,

    input JAL,
    input LUI,

    //-----------------------------------------------------
    // ALU CONTROL
    //-----------------------------------------------------
    input Carry_In,
    input Ainvert,
    input Binvert,

    input [2:0] Operation,
    input [1:0] ResCtrl,
    input [1:0] ShfCtrl,

    //-----------------------------------------------------
    // OUTPUTS
    //-----------------------------------------------------
    output [15:0] Result,
    output [15:0] Rt_Value,
    output [2:0] RD_Out

);

wire [15:0] ALU_B;
wire [15:0] ALU_Result;
wire [15:0] PC_plus1;

wire dummy_zero;
wire dummy_set;
wire dummy_carry;

///////////////////////////////////////////////////////////
// ALUSrc MUX
///////////////////////////////////////////////////////////

assign ALU_B =
        ALUSrc ?
        Imm :
        BUS_B;

///////////////////////////////////////////////////////////
// ALU
///////////////////////////////////////////////////////////

Top_ALU ALU(

    .A(BUS_A),
    .B(ALU_B),

    .Carry_In(Carry_In),
    .Ainvert(Ainvert),
    .Binvert(Binvert),

    .Operation(Operation),
    .ResCtrl(ResCtrl),
    .ShfCtrl(ShfCtrl),

    .Result(ALU_Result),

    .Zero_Flag(dummy_zero),
    .Set(dummy_set),
    .CarryOut(dummy_carry)

);

///////////////////////////////////////////////////////////
// PC + 1
///////////////////////////////////////////////////////////

assign PC_plus1 =
        PC + 16'd1;

///////////////////////////////////////////////////////////
// Result MUX
///////////////////////////////////////////////////////////

reg [15:0] Result;

always @(*) begin
    case ({JAL, LUI})
        2'b10: Result = PC_plus1;
        2'b01: Result = LUI_Imm;
        default: Result = ALU_Result;
    endcase
end

///////////////////////////////////////////////////////////

assign Rt_Value =
        BUS_B;

assign RD_Out =
        RD;

endmodule