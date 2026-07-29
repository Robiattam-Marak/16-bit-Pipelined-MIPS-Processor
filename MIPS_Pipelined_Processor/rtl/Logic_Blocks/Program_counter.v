module program_counter (
    input clk,
    input reset,
    input Branch,
    input J,
    input Jr,
    input [4:0] imm_5,
    input [10:0] imm_11,
    input [15:0] Rs,
    output reg [15:0] PC,
    output [15:0] PC_plus_1
);
    wire [15:0] branch_offset;
    wire [15:0] jump_offset;
    wire [15:0] branch_target;
    wire [15:0] jump_target;
    reg [15:0] next_pc;
    assign branch_offset = {{11{imm_5[4]}}, imm_5};
    assign jump_offset = {{5{imm_11[10]}}, imm_11};
    assign PC_plus_1 = PC + 16'd1;
    assign branch_target = PC_plus_1 + branch_offset;
    assign jump_target = PC_plus_1 + jump_offset;
    always @(*) begin
        next_pc = PC_plus_1;
        if(Branch)
            next_pc = branch_target;
        if(J)
            next_pc = jump_target;
        if(Jr)
            next_pc = Rs;
    end
    always @(posedge clk or posedge reset) begin
        if(reset)
            PC <= 16'd0;
        else
            PC <= next_pc;
    end
endmodule