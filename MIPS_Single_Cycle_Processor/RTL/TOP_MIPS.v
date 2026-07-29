module cpu16(

    input clk,
    input reset

);

    //--------------------------------------------------
    // PC Signals
    //--------------------------------------------------
    wire [15:0] PC;
    wire [15:0] PC_plus_1;

    //--------------------------------------------------
    // Instruction Memory
    //--------------------------------------------------
    wire [15:0] instruction;

    wire [4:0] opcode;
    wire [2:0] rs;
    wire [2:0] rt;
    wire [2:0] rd;

    wire [4:0] imm_5;
    wire [10:0] imm_11;

    wire [1:0] func;

    //--------------------------------------------------
    // Main Control
    //--------------------------------------------------
    wire RegWr;
    wire RegDst;
    wire J;
    wire JAL;
    wire LUI;
    wire ExtOp;
    wire ALUSrc;
    wire MemRd;
    wire MemWr;
    wire MemtoReg;

    //--------------------------------------------------
    // ALU Control
    //--------------------------------------------------
    wire Carry_In;
    wire Ainvert;
    wire Binvert;

    wire [2:0] Operation;
    wire [1:0] ResCtrl;
    wire [1:0] ShfCtrl;

    wire Jr;

    //--------------------------------------------------
    // Register File
    //--------------------------------------------------
    wire [15:0] ReadData1;
    wire [15:0] ReadData2;

    wire [2:0] WriteReg;
    wire [15:0] WriteData;

    //--------------------------------------------------
    // Immediate Logic
    //--------------------------------------------------
    wire [15:0] ZeroExtended;
    wire [15:0] SignExtended;
    wire [15:0] ExtendedImm;

    //--------------------------------------------------
    // ALU
    //--------------------------------------------------
    wire [15:0] ALU_B;

    wire [15:0] ALU_Result;

    wire Zero_Flag;
    wire Set;
    wire CarryOut;

    //--------------------------------------------------
    // Branch
    //--------------------------------------------------
    wire Branch;

    //--------------------------------------------------
    // Data Memory
    //--------------------------------------------------
    wire [15:0] MemData;

    //--------------------------------------------------
    // WRITE REGISTER MUXES
    //--------------------------------------------------

    wire [2:0] RegDstOut;
    wire [2:0] JalRegOut;

    assign RegDstOut =
            RegDst ? rd : rt;

    assign JalRegOut =
            JAL ? 3'd7 : RegDstOut;

    assign WriteReg =
            LUI ? 3'd1 : JalRegOut;

    //--------------------------------------------------
    // IMMEDIATE EXTENSION
    //--------------------------------------------------

    assign ZeroExtended =
            {11'b0,imm_5};

    assign SignExtended =
            {{11{imm_5[4]}},imm_5};

    assign ExtendedImm =
            ExtOp ? SignExtended :
                    ZeroExtended;

    //--------------------------------------------------
    // ALUSRC
    //--------------------------------------------------

    assign ALU_B =
            ALUSrc ? ExtendedImm :
                     ReadData2;

    //--------------------------------------------------
    // WRITEBACK
    //--------------------------------------------------

    wire [15:0] WB0;
    wire [15:0] WB1;
    wire [15:0] LUI_Data;

    assign WB0 =
            MemtoReg ? MemData :
                       ALU_Result;

    assign WB1 =
            JAL ? PC_plus_1 :
                  WB0;

    assign LUI_Data =
            {imm_11,5'b0};

    assign WriteData =
            LUI ? LUI_Data :
                  WB1;

    //--------------------------------------------------
    // PROGRAM COUNTER
    //--------------------------------------------------

    program_counter PC_UNIT(

        .clk(clk),
        .reset(reset),

        .Branch(Branch),
        .J(J),
        .Jr(Jr),

        .imm_5(imm_5),
        .imm_11(imm_11),

        .Rs(ReadData1),

        .PC(PC),
        .PC_plus_1(PC_plus_1)

    );

    //--------------------------------------------------
    // INSTRUCTION MEMORY
    //--------------------------------------------------

    instruction_memory IM(

        .address(PC),

        .instruction(instruction),

        .opcode(opcode),

        .rs(rs),
        .rt(rt),
        .rd(rd),

        .imm_5(imm_5),
        .imm_11(imm_11),

        .func(func)

    );

    //--------------------------------------------------
    // MAIN CONTROL
    //--------------------------------------------------

    main_control_unit MCU(

        .opcode(opcode),

        .RegWr(RegWr),
        .RegDst(RegDst),

        .J(J),
        .JAL(JAL),
        .LUI(LUI),

        .ExtOp(ExtOp),
        .ALUSrc(ALUSrc),

        .MemRd(MemRd),
        .MemWr(MemWr),

        .MemtoReg(MemtoReg)

    );

    //--------------------------------------------------
    // ALU CONTROL
    //--------------------------------------------------

    alu_control_unit ACU(

        .opcode(opcode),
        .func(func),

        .Carry_In(Carry_In),
        .Ainvert(Ainvert),
        .Binvert(Binvert),

        .Operation(Operation),

        .ResCtrl(ResCtrl),
        .ShfCtrl(ShfCtrl),

        .Jr(Jr)

    );

    //--------------------------------------------------
    // REGISTER FILE
    //--------------------------------------------------

    register_file RF(
    .clk(clk),
    .reset(reset),
    .RegWrite(RegWr),

    .ReadRegister1(rs),
    .ReadRegister2(rt),
    .WriteRegister(WriteReg),

    .WriteData(WriteData),

    .ReadData1(ReadData1),
    .ReadData2(ReadData2)
);


    //--------------------------------------------------
    // ALU
    //--------------------------------------------------

    Top_ALU ALU(
    .A(ReadData1),
    .B(ALU_B),

    .Carry_In(Carry_In),
    .Ainvert(Ainvert),
    .Binvert(Binvert),

    .Operation(Operation),
    .ResCtrl(ResCtrl),
    .ShfCtrl(ShfCtrl),

    .Result(ALU_Result),
    .Zero_Flag(Zero_Flag),
    .Set(Set),
    .CarryOut(CarryOut)
);

    //--------------------------------------------------
    // BRANCH CONTROL
    //--------------------------------------------------

    branch_control_unit BCU(

        .opcode(opcode),

        .Zero_Flag(Zero_Flag),
        .Set(Set),

        .Branch(Branch)

    );

    //--------------------------------------------------
    // DATA MEMORY
    //--------------------------------------------------

    data_memory DM(

        .clk(clk),

        .MemWr(MemWr),
        .MemRd(MemRd),

        .address(ALU_Result),

        .write_data(ReadData2),

        .read_data(MemData)

    );

endmodule
