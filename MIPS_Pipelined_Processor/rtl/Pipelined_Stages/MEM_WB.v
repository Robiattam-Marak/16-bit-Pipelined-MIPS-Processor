//=========================================================
// MEM/WB PIPELINE REGISTER
//=========================================================

module mem_wb(

    input clk,
    input reset,

    //-------------------------
    // INPUTS
    //-------------------------
    input [15:0] WriteData_in,
    input [2:0] RD_in,

    input RegWrite_in,

    //-------------------------
    // OUTPUTS
    //-------------------------
    output reg [15:0] WriteData_out,
    output reg [2:0] RD_out,

    output reg RegWrite_out

);

always @(posedge clk) begin

    if(reset) begin

        WriteData_out <= 16'd0;
        RD_out        <= 3'd0;
        RegWrite_out  <= 1'b0;

    end
    else begin

        WriteData_out <= WriteData_in;
        RD_out        <= RD_in;
        RegWrite_out  <= RegWrite_in;

    end

end

endmodule