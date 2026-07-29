module forward_mux(

input [15:0] BUS,
input [15:0] ALU_Fwd,
input [15:0] MEM_Fwd,
input [15:0] WB_Fwd,

input [1:0] Forward,

output reg [15:0] Out

);

always @(*)
begin

case(Forward)

2'b00:
    Out = BUS;

2'b01:
    Out = ALU_Fwd;

2'b10:
    Out = MEM_Fwd;

2'b11:
    Out = WB_Fwd;

endcase

end

endmodule