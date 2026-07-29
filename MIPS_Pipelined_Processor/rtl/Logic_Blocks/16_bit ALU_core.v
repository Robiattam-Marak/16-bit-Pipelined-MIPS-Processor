module alu_16bit(

    input  [15:0] A,
    input  [15:0] B,

    input Carry_In,
    input Ainvert,
    input Binvert,

    input [2:0] operation,

    output [15:0] Result,
    output Zero_Flag,
    output Set,
    output CarryOut
);

wire [15:0] temp_result;

wire [15:0] carry;

wire msb_set;

alu_1bit A0(
    .A(A[0]),
    .B(B[0]),
    .less(msb_set),
    .Ainvert(Ainvert),
    .Binvert(Binvert),
    .CarryIn(Carry_In),
    .operation(operation),
    .result(temp_result[0]),
    .CarryOut(carry[0]),
    .set()
);

genvar i;

generate
for(i=1;i<15;i=i+1)
begin

    alu_1bit Ai(
        .A(A[i]),
        .B(B[i]),
        .less(1'b0),
        .Ainvert(Ainvert),
        .Binvert(Binvert),
        .CarryIn(carry[i-1]),
        .operation(operation),
        .result(temp_result[i]),
        .CarryOut(carry[i]),
        .set()
    );

end
endgenerate

alu_1bit A15(
    .A(A[15]),
    .B(B[15]),
    .less(1'b0),
    .Ainvert(Ainvert),
    .Binvert(Binvert),
    .CarryIn(carry[14]),
    .operation(operation),
    .result(temp_result[15]),
    .CarryOut(CarryOut),
    .set(msb_set)
);

assign Set = msb_set;

assign Result =
       (operation == 3'b011)
       ?
       {15'b0,msb_set}
       :
       temp_result;

assign Zero_Flag = ~|Result;

endmodule