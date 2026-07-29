module extender(

    input [15:0] PC,
    input [4:0] imm5,
    input [10:0] imm11,

    input ExtOp,

    output [15:0] Imm,
    output [15:0] Branch_Target,
    output [15:0] Jump_Target,
    output [15:0] LUI_Imm

);

wire [15:0] SignExt5;
wire [15:0] ZeroExt5;
wire [15:0] JumpExt;

assign SignExt5 =
        {{11{imm5[4]}},imm5};

assign ZeroExt5 =
        {11'b0,imm5};

assign JumpExt =
        {{5{imm11[10]}},imm11};

assign Imm =
        ExtOp ?
        SignExt5 :
        ZeroExt5;

assign Branch_Target =
        PC + 16'd1 + SignExt5;

assign Jump_Target =
        PC + 16'd1 + JumpExt;

assign LUI_Imm =
        {imm11,5'b0};

endmodule