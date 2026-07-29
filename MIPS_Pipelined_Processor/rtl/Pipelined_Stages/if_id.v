module if_id(

    input clk,
    input reset,

    input stall,
    input flush,

    input [15:0] pc_in,
    input [15:0] pc_plus1_in,
    input [15:0] instruction_in,

    output reg [15:0] pc_out,
    output reg [15:0] pc_plus1_out,
    output reg [15:0] instruction_out

);

always @(posedge clk or posedge reset)
begin

    if(reset)
    begin
        pc_out          <= 16'd0;
        pc_plus1_out    <= 16'd0;
        instruction_out <= 16'd0;
    end

    else if(flush)
    begin
        // Insert NOP
        pc_out          <= 16'd0;
        pc_plus1_out    <= 16'd0;
        instruction_out <= 16'd0;
    end

    else if(!stall)
    begin
        pc_out          <= pc_in;
        pc_plus1_out    <= pc_plus1_in;
        instruction_out <= instruction_in;
    end

    // if(stall)
    // Hold previous values automatically

end

endmodule