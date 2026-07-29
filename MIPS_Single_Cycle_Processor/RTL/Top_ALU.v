module Top_ALU(

    input  [15:0] A,
    input  [15:0] B,

    input         Carry_In,
    input         Ainvert,
    input         Binvert,

    input  [2:0]  Operation,
    input  [1:0]  ResCtrl,
    input  [1:0]  ShfCtrl,

    output [15:0] Result,
    output        Zero_Flag,
    output        Set,
    output        CarryOut
);

    //--------------------------------------------------
    // Arithmetic / Logic Result
    //--------------------------------------------------
    wire [15:0] logic_result;

    //--------------------------------------------------
    // Shift / Rotate Result
    //--------------------------------------------------
    wire [15:0] shift_result;

    //--------------------------------------------------
    // SLTU Result
    //--------------------------------------------------
    wire [15:0] sltu_result;

    wire logic_zero;
    wire logic_set;
    wire logic_carry;

    //--------------------------------------------------
    // Arithmetic + Logic ALU
    //--------------------------------------------------
    alu_16bit ALU_CORE (

        .A(A),
        .B(B),

        .Carry_In(Carry_In),
        .Ainvert(Ainvert),
        .Binvert(Binvert),

        .operation(Operation),

        .Result(logic_result),
        .Zero_Flag(logic_zero),
        .Set(logic_set),
        .CarryOut(logic_carry)
    );

    //--------------------------------------------------
    // Shift / Rotate Unit
    //--------------------------------------------------
    shift_rotate_unit SHIFT_UNIT (

        .A(A),
        .B(B),

        .ShfCtrl(ShfCtrl),

        .shift_result(shift_result),
        .sltu_result(sltu_result)
    );

    //--------------------------------------------------
    // Result Select MUX
    //--------------------------------------------------
    assign Result =
            (ResCtrl == 2'b00) ? logic_result :
            (ResCtrl == 2'b01) ? shift_result :
            (ResCtrl == 2'b10) ? sltu_result :
            16'h0000;

    //--------------------------------------------------
    // Flags
    //--------------------------------------------------
    assign Zero_Flag = ~|Result;

    assign Set =
            (ResCtrl == 2'b00) ? logic_set :
            (ResCtrl == 2'b10) ? sltu_result[0] :
            1'b0;

    assign CarryOut =
            (ResCtrl == 2'b00) ? logic_carry :
            1'b0;

endmodule