module shift_rotate_unit(

    input [15:0] A,
    input [15:0] B,

    input [1:0] ShfCtrl,

    output reg [15:0] shift_result,
    output [15:0] sltu_result
);

always @(*) begin

    case(ShfCtrl)

        2'b00:
            shift_result = A << B[4:0];

        2'b01:
            shift_result = A >> B[4:0];

        2'b10:
            shift_result = $signed(A) >>> B[4:0];

        2'b11:
            shift_result =
                (A >> B[4:0]) |
                (A << (16-B[4:0]));

        default:
            shift_result = 16'b0;

    endcase

end

assign sltu_result =
        (A < B)
        ?
        16'h0001
        :
        16'h0000;

endmodule