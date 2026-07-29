module alu_1bit(

    input A,
    input B,
    input less,

    input Ainvert,
    input Binvert,
    input CarryIn,

    input [2:0] operation,

    output result,
    output CarryOut,
    output set
);

wire a_in;
wire b_in;

wire and_out;
wire or_out;
wire xor_out;

wire sum;

assign a_in = Ainvert ? ~A : A;
assign b_in = Binvert ? ~B : B;

assign and_out = a_in & b_in;
assign or_out  = a_in | b_in;
assign xor_out = a_in ^ b_in;

assign sum =
        a_in ^
        b_in ^
        CarryIn;

assign CarryOut =
        (a_in & b_in) |
        (a_in & CarryIn) |
        (b_in & CarryIn);

assign set = sum;

assign result =
       (operation == 3'b000) ? and_out :
       (operation == 3'b001) ? or_out  :
       (operation == 3'b010) ? sum     :
       (operation == 3'b011) ? less    :
       (operation == 3'b100) ? xor_out :
       1'b0;

endmodule