//=========================================================
// ID / EX PIPELINE REGISTER
//=========================================================
module id_ex(

    input clk,
    input reset,
    input flush,

    //-----------------------------------------------------
    // DATA
    //-----------------------------------------------------
    input [15:0] PC_in,
    input [15:0] BUSA_in,
    input [15:0] BUSB_in,
    input [15:0] Imm_in,
    input [15:0] LUI_Imm_in,

    input [2:0] RD_in,

    //-----------------------------------------------------
    // ALU CONTROL
    //-----------------------------------------------------
    input Carry_In_in,
    input Ainvert_in,
    input Binvert_in,

    input [2:0] Operation_in,

    input [1:0] ResCtrl_in,
    input [1:0] ShfCtrl_in,

    //-----------------------------------------------------
    // MAIN CONTROL
    //-----------------------------------------------------
    input RegWrite_in,
    input ALUSrc_in,

    input MemRead_in,
    input MemWrite_in,
    input MemtoReg_in,

    input JAL_in,
    input LUI_in,

    //-----------------------------------------------------
    // DATA OUTPUTS
    //-----------------------------------------------------
    output reg [15:0] PC_out,
    output reg [15:0] BUSA_out,
    output reg [15:0] BUSB_out,
    output reg [15:0] Imm_out,
    output reg [15:0] LUI_Imm_out,

    output reg [2:0] RD_out,

    //-----------------------------------------------------
    // ALU CONTROL OUTPUTS
    //-----------------------------------------------------
    output reg Carry_In_out,
    output reg Ainvert_out,
    output reg Binvert_out,

    output reg [2:0] Operation_out,

    output reg [1:0] ResCtrl_out,
    output reg [1:0] ShfCtrl_out,

    //-----------------------------------------------------
    // MAIN CONTROL OUTPUTS
    //-----------------------------------------------------
    output reg RegWrite_out,
    output reg ALUSrc_out,

    output reg MemRead_out,
    output reg MemWrite_out,
    output reg MemtoReg_out,

    output reg JAL_out,
    output reg LUI_out

);

always @(posedge clk or posedge reset)
begin

    if(reset)
    begin

        PC_out <= 16'd0;
        BUSA_out <= 16'd0;
        BUSB_out <= 16'd0;
        Imm_out <= 16'd0;
        LUI_Imm_out <= 16'd0;

        RD_out <= 3'd0;

        Carry_In_out <= 1'b0;
        Ainvert_out <= 1'b0;
        Binvert_out <= 1'b0;

        Operation_out <= 3'd0;

        ResCtrl_out <= 2'd0;
        ShfCtrl_out <= 2'd0;

        RegWrite_out <= 1'b0;
        ALUSrc_out <= 1'b0;

        MemRead_out <= 1'b0;
        MemWrite_out <= 1'b0;
        MemtoReg_out <= 1'b0;

        JAL_out <= 1'b0;
        LUI_out <= 1'b0;

    end

    else if(flush)
    begin

        // Insert Bubble (NOP)

        PC_out <= 16'd0;
        BUSA_out <= 16'd0;
        BUSB_out <= 16'd0;
        Imm_out <= 16'd0;
        LUI_Imm_out <= 16'd0;

        RD_out <= 3'd0;

        Carry_In_out <= 1'b0;
        Ainvert_out <= 1'b0;
        Binvert_out <= 1'b0;

        Operation_out <= 3'd0;

        ResCtrl_out <= 2'd0;
        ShfCtrl_out <= 2'd0;

        RegWrite_out <= 1'b0;
        ALUSrc_out <= 1'b0;

        MemRead_out <= 1'b0;
        MemWrite_out <= 1'b0;
        MemtoReg_out <= 1'b0;

        JAL_out <= 1'b0;
        LUI_out <= 1'b0;

    end

    else
    begin

        PC_out <= PC_in;
        BUSA_out <= BUSA_in;
        BUSB_out <= BUSB_in;
        Imm_out <= Imm_in;
        LUI_Imm_out <= LUI_Imm_in;

        RD_out <= RD_in;

        Carry_In_out <= Carry_In_in;
        Ainvert_out <= Ainvert_in;
        Binvert_out <= Binvert_in;

        Operation_out <= Operation_in;

        ResCtrl_out <= ResCtrl_in;
        ShfCtrl_out <= ShfCtrl_in;

        RegWrite_out <= RegWrite_in;
        ALUSrc_out <= ALUSrc_in;

        MemRead_out <= MemRead_in;
        MemWrite_out <= MemWrite_in;
        MemtoReg_out <= MemtoReg_in;

        JAL_out <= JAL_in;
        LUI_out <= LUI_in;

    end

end

endmodule