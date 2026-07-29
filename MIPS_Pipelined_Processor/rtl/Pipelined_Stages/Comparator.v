module comparator(

input [15:0] A,
input [15:0] B,

output Zero_Flag,
output Set

);

assign Zero_Flag =
        (A==B);

assign Set =
        ($signed(A)<$signed(B));

endmodule