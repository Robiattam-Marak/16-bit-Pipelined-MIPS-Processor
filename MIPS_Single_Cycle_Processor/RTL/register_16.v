module register16(
    input clk,
    input reset,
    input en,
    input [15:0] d,
    output reg [15:0] q
);

always @(posedge clk or posedge reset)
begin
    if(reset)
        q <= 16'd0;
    else if(en)
        q <= d;
end

endmodule