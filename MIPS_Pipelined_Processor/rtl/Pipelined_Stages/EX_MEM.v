//=========================================================
// EX/MEM PIPELINE REGISTER
//=========================================================
module ex_mem(

    input clk,
    input reset,

    //-------------------------
    // DATA
    //-------------------------
    input  [15:0] Result_in,
    input  [15:0] Rt_Value_in,
    input  [2:0]  RD_in,

    //-------------------------
    // CONTROL
    //-------------------------
    input RegWrite_in,
    input MemRead_in,
    input MemWrite_in,
    input MemtoReg_in,

    //-------------------------
    // OUTPUTS
    //-------------------------
    output reg [15:0] Result_out,
    output reg [15:0] Rt_Value_out,
    output reg [2:0]  RD_out,

    output reg RegWrite_out,
    output reg MemRead_out,
    output reg MemWrite_out,
    output reg MemtoReg_out

);

always @(posedge clk) begin

    if(reset) begin

        Result_out   <= 16'd0;
        Rt_Value_out <= 16'd0;
        RD_out       <= 3'd0;

        RegWrite_out <= 0;
        MemRead_out  <= 0;
        MemWrite_out <= 0;
        MemtoReg_out <= 0;

    end
    else begin

        Result_out   <= Result_in;
        Rt_Value_out <= Rt_Value_in;
        RD_out       <= RD_in;

        RegWrite_out <= RegWrite_in;
        MemRead_out  <= MemRead_in;
        MemWrite_out <= MemWrite_in;
        MemtoReg_out <= MemtoReg_in;

    end

end

endmodule