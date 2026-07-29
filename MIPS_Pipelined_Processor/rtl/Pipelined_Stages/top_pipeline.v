module cpu16_pipeline(
    input clk,
    input reset
);
    wire [15:0] EXMEM_Result;
    wire [15:0] EXMEM_RtValue;
    
    wire [2:0] EXMEM_RD;
    
    wire EXMEM_RegWr;
    wire EXMEM_MemRd;
    wire EXMEM_MemWr;
    wire EXMEM_MemtoReg;
    wire [15:0] PC;
    wire [15:0] PC_plus1;
    wire [15:0] NextPC;

    wire [15:0] Instruction;

    wire [1:0] PCControl;
    wire Kill1;
    wire Stall;

    wire [4:0] opcode;

    wire [2:0] rs;
    wire [2:0] rt;
    wire [2:0] rd;

    wire [4:0] imm5;
    wire [10:0] imm11;

    wire [1:0] func;

    wire [15:0] IFID_PC1;
    wire [15:0] IFID_Instruction;

    wire [4:0] ID_opcode;

    wire [2:0] ID_rs;
    wire [2:0] ID_rt;
    wire [2:0] ID_rd;

    wire [4:0] ID_imm5;
    wire [10:0] ID_imm11;

    wire [1:0] ID_func;
    
    wire [15:0] ReadData1;
    wire [15:0] ReadData2;
    
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

    wire Carry_In;
    wire Ainvert;
    wire Binvert;

    wire [2:0] Operation;
    wire [1:0] ResCtrl;
    wire [1:0] ShfCtrl;

    wire Jr;
    
    wire [15:0] Immediate;

    wire [15:0] BranchTarget;
    wire [15:0] JumpTarget;

    wire [15:0] LUI_Data;
    
    wire [15:0] BUS_A;
    wire [15:0] BUS_B;

    wire [15:0] ALU_Fwd;
    wire [15:0] MEM_Fwd;
    wire [15:0] WB_Fwd;

    wire [1:0] ForwardA;
    wire [1:0] ForwardB;
    
    wire Zero_Flag;
    wire Set;

    wire Branch;
    
    wire [15:0] IDEX_PC1;

    wire [15:0] IDEX_BUS_A;
    wire [15:0] IDEX_BUS_B;

    wire [15:0] IDEX_Immediate;
    wire [15:0] IDEX_LUI;

    wire [2:0] IDEX_RD;

    wire IDEX_RegWr;
    wire IDEX_MemRd;
    wire IDEX_MemWr;
    wire IDEX_MemtoReg;
    wire IDEX_ALUSrc;
    wire IDEX_JAL;

    wire IDEX_CarryIn;
    wire IDEX_Ainvert;
    wire IDEX_Binvert;

    wire [2:0] IDEX_Operation;
    wire [1:0] IDEX_ResCtrl;
    wire [1:0] IDEX_ShfCtrl;
    
    wire [15:0] ALU_InputB;
    wire [15:0] ALU_Result;
    wire [15:0] EX_Result;
    wire CarryOut;
    
program_counter PC_UNIT(
    .clk(clk),
    .reset(reset),
    .Branch(Branch),
    .J(J),
    .Jr(Jr),
    .imm_5(ID_imm5),
    .imm_11(ID_imm11),
    .Rs(BUS_A),
    .PC(PC),
    .PC_plus_1(PC_plus1)
);
instruction_memory IM(
    .address(PC),
    .instruction(Instruction),
    .opcode(opcode),
    .rs(rs),
    .rt(rt),
    .rd(rd),
    .imm_5(imm5),
    .imm_11(imm11),
    .func(func)
);

if_id IF_ID(
    .clk(clk),
    .reset(reset),
    .stall(Stall),
    .flush(Kill1),
    .pc_in(PC),
    .pc_plus1_in(PC_plus1),
    .instruction_in(Instruction),
    .pc_out(),
    .pc_plus1_out(IFID_PC1),
    .instruction_out(IFID_Instruction)
);

assign ID_opcode = IFID_Instruction[15:11];
assign ID_rs = IFID_Instruction[10:8];
assign ID_rt = IFID_Instruction[7:5];
assign ID_rd = IFID_Instruction[4:2];
assign ID_func = IFID_Instruction[1:0];
assign ID_imm5 = IFID_Instruction[4:0];
assign ID_imm11 = IFID_Instruction[10:0];

register_file RF(
    .clk(clk),
    .reset(reset),
    .RegWrite(RegWriteWB),
    .ReadRegister1(ID_rs),
    .ReadRegister2(ID_rt),
    .WriteRegister(WriteRegWB),
    .WriteData(WriteDataWB),
    .ReadData1(ReadData1),
    .ReadData2(ReadData2)
);

main_control_unit MCU(
    .opcode(ID_opcode),
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

alu_control_unit ACU(
    .opcode(ID_opcode),
    .func(ID_func),
    .Carry_In(Carry_In),
    .Ainvert(Ainvert),
    .Binvert(Binvert),
    .Operation(Operation),
    .ResCtrl(ResCtrl),
    .ShfCtrl(ShfCtrl),
    .Jr(Jr)
);

forward_mux FMUX_A(
    .BUS(ReadData1),
    .ALU_Fwd(ALU_Fwd),
    .MEM_Fwd(MEM_Fwd),
    .WB_Fwd(WB_Fwd),
    .Forward(ForwardA),
    .Out(BUS_A)
);

forward_mux FMUX_B(
    .BUS(ReadData1),
    .ALU_Fwd(ALU_Fwd),
    .MEM_Fwd(MEM_Fwd),
    .WB_Fwd(WB_Fwd),
    .Forward(ForwardB),
    .Out(BUS_B)
);

comparator CMP(
    .A(BUS_A),
    .B(BUS_B),
    .Zero_Flag(Zero_Flag),
    .Set(Set)
);

branch_control_unit BCU(
    .opcode(ID_opcode),
    .Zero_Flag(Zero_Flag),
    .Set(Set),
    .Branch(Branch)
);

pc_control_unit PCC(
    .JR(Jr),
    .J(J),
    .JAL(JAL),
    .BR(Branch),
    .PCControl(PCControl),
    .Kill1(Kill1)
);

hazard_forward_stall HAZ(
    .IF_ID_Rs(ID_rs),
    .IF_ID_Rt(ID_rt),
    .ID_EX_Rd(IDEX_RD),
    .ID_EX_RegWrite(IDEX_RegWr),
    .ID_EX_MemRd(IDEX_MemRd),
    .EX_MEM_Rd(EXMEM_RD),
    .EX_MEM_RegWrite(EXMEM_RegWr),
    .MEM_WB_Rd(MEMWB_RD),
    .MEM_WB_RegWrite(MEMWB_RegWr),
    .ForwardA(ForwardA),
    .ForwardB(ForwardB),
    .Stall(Stall)
);

id_ex ID_EX(
    .clk(clk),
    .reset(reset),
    .flush(Kill1),
    .PC_in(IFID_PC1),
    .BUSA_in(BUS_A),
    .BUSB_in(BUS_B),
    .Imm_in(Immediate),
    .LUI_Imm_in(LUI_Data),
    .RD_in(RegDst ? ID_rd : ID_rt),
    .RegWrite_in(RegWr),
    .MemRead_in(MemRd),
    .MemWrite_in(MemWr),
    .MemtoReg_in(MemtoReg),
    .ALUSrc_in(ALUSrc),
    .JAL_in(JAL),
    .Carry_In_in(Carry_In),
    .Ainvert_in(Ainvert),
    .Binvert_in(Binvert),
    .Operation_in(Operation),
    .ResCtrl_in(ResCtrl),
    .ShfCtrl_in(ShfCtrl),
    .PC_out(IDEX_PC1),
    .BUSA_out(IDEX_BUS_A),
    .BUSB_out(IDEX_BUS_B),
    .Imm_out(IDEX_Immediate),
    .LUI_Imm_out(IDEX_LUI),
    .RD_out(IDEX_RD),
    .RegWrite_out(IDEX_RegWr),
    .MemRead_out(IDEX_MemRd),
    .MemWrite_out(IDEX_MemWr),
    .MemtoReg_out(IDEX_MemtoReg),
    .ALUSrc_out(IDEX_ALUSrc),
    .JAL_out(IDEX_JAL),
    .Carry_In_out(IDEX_CarryIn),
    .Ainvert_out(IDEX_Ainvert),
    .Binvert_out(IDEX_Binvert),
    .Operation_out(IDEX_Operation),
    .ResCtrl_out(IDEX_ResCtrl),
    .ShfCtrl_out(IDEX_ShfCtrl)
);

wire [15:0] EXMEM_Result;
wire [15:0] EXMEM_RtValue;

wire [2:0] EXMEM_RD;

wire EXMEM_RegWr;
wire EXMEM_MemRd;
wire EXMEM_MemWr;
wire EXMEM_MemtoReg;

assign ALU_InputB =
        IDEX_ALUSrc ?
        IDEX_Immediate :
        IDEX_BUS_B;
        
Top_ALU ALU(
    .A(IDEX_BUS_A),
    .B(ALU_InputB),
    .Carry_In(IDEX_CarryIn),
    .Ainvert(IDEX_Ainvert),
    .Binvert(IDEX_Binvert),
    .Operation(IDEX_Operation),
    .ResCtrl(IDEX_ResCtrl),
    .ShfCtrl(IDEX_ShfCtrl),
    .Result(ALU_Result),
    .Zero_Flag(),
    .Set(),
    .CarryOut(CarryOut)
);

assign ALU_Fwd = EX_Result;

assign EX_Result =
        IDEX_JAL ?
            IDEX_PC1 :
        (IDEX_LUI != 16'd0) ?
            IDEX_LUI :
            ALU_Result;

ex_mem EX_MEM(

    .clk(clk),
    .reset(reset),

    .Result_in(EX_Result),
    .Rt_Value_in(IDEX_BUS_B),
    .RD_in(IDEX_RD),

    .RegWrite_in(IDEX_RegWr),
    .MemRead_in(IDEX_MemRd),
    .MemWrite_in(IDEX_MemWr),
    .MemtoReg_in(IDEX_MemtoReg),

    .Result_out(EXMEM_Result),
    .Rt_Value_out(EXMEM_RtValue),
    .RD_out(EXMEM_RD),

    .RegWrite_out(EXMEM_RegWr),
    .MemRead_out(EXMEM_MemRd),
    .MemWrite_out(EXMEM_MemWr),
    .MemtoReg_out(EXMEM_MemtoReg)

);
wire [15:0] MemData;
wire [15:0] WriteBackData;

wire [15:0] MEMWB_WriteData;

wire [2:0] MEMWB_RD;

wire MEMWB_RegWr;

data_memory DM(
    .clk(clk),
    .MemWr(EXMEM_MemWr),
    .MemRd(EXMEM_MemRd),
    .address(EXMEM_Result),
    .write_data(EXMEM_RtValue),
    .read_data(MemData)
);

assign WriteBackData =
        EXMEM_MemtoReg ?
        MemData :
        EXMEM_Result;
        
assign MEM_Fwd = WriteBackData;

mem_wb MEM_WB(
    .clk(clk),
    .reset(reset),
    .WriteData_in(WriteBackData),
    .RD_in(EXMEM_RD),
    .RegWrite_in(EXMEM_RegWr),
    .WriteData_out(MEMWB_WriteData),
    .RD_out(MEMWB_RD),
    .RegWrite_out(MEMWB_RegWr)
);

wire [15:0] WriteDataWB;
wire [2:0]  WriteRegWB;
wire        RegWriteWB;

wb_stage WB(
    .WriteData(MEMWB_WriteData),
    .RD(MEMWB_RD),
    .RegWrite(MEMWB_RegWr),
    .WB_Data(WriteDataWB),
    .WB_RD(WriteRegWB),
    .WB_RegWrite(RegWriteWB),
    .WB_Fwd(WB_Fwd)
);

reg [15:0] NextPC_reg;

always @(*) begin
    case(PCControl)
        2'b00:
            NextPC_reg = PC_plus1;
        2'b01:
            NextPC_reg = BranchTarget;
        2'b10:
            NextPC_reg = JumpTarget;
        2'b11:
            NextPC_reg = BUS_A;
        default:
            NextPC_reg = PC_plus1;
    endcase
end

assign NextPC = NextPC_reg;

endmodule