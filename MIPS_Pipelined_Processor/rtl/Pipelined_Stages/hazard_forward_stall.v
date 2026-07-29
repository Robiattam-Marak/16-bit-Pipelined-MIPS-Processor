//=========================================================
// Hazard Detection + Forwarding + Stall Unit
//=========================================================
module hazard_forward_stall(

    //-----------------------------------------------------
    // SOURCE REGISTERS (Current instruction in ID stage)
    //-----------------------------------------------------
    input [2:0] IF_ID_Rs,
    input [2:0] IF_ID_Rt,

    //-----------------------------------------------------
    // EX STAGE
    //-----------------------------------------------------
    input [2:0] ID_EX_Rd,
    input       ID_EX_RegWrite,
    input       ID_EX_MemRd,

    //-----------------------------------------------------
    // MEM STAGE
    //-----------------------------------------------------
    input [2:0] EX_MEM_Rd,
    input       EX_MEM_RegWrite,

    //-----------------------------------------------------
    // WB STAGE
    //-----------------------------------------------------
    input [2:0] MEM_WB_Rd,
    input       MEM_WB_RegWrite,

    //-----------------------------------------------------
    // OUTPUTS
    //-----------------------------------------------------
    output reg [1:0] ForwardA,
    output reg [1:0] ForwardB,

    output reg Stall
);

    //-----------------------------------------------------
    // Internal hazard signals
    //-----------------------------------------------------
    wire EX_Rs;
    wire MEM_Rs;
    wire WB_Rs;

    wire EX_Rt;
    wire MEM_Rt;
    wire WB_Rt;

    //-----------------------------------------------------
    // Hazard Detection
    //-----------------------------------------------------

    assign EX_Rs =
        ID_EX_RegWrite &&
        (ID_EX_Rd != 3'd0) &&
        (ID_EX_Rd == IF_ID_Rs);

    assign MEM_Rs =
        EX_MEM_RegWrite &&
        (EX_MEM_Rd != 3'd0) &&
        (EX_MEM_Rd == IF_ID_Rs);

    assign WB_Rs =
        MEM_WB_RegWrite &&
        (MEM_WB_Rd != 3'd0) &&
        (MEM_WB_Rd == IF_ID_Rs);

    assign EX_Rt =
        ID_EX_RegWrite &&
        (ID_EX_Rd != 3'd0) &&
        (ID_EX_Rd == IF_ID_Rt);

    assign MEM_Rt =
        EX_MEM_RegWrite &&
        (EX_MEM_Rd != 3'd0) &&
        (EX_MEM_Rd == IF_ID_Rt);

    assign WB_Rt =
        MEM_WB_RegWrite &&
        (MEM_WB_Rd != 3'd0) &&
        (MEM_WB_Rd == IF_ID_Rt);

    //-----------------------------------------------------
    // Forward A
    //-----------------------------------------------------
    always @(*) begin

        if(EX_Rs)
            ForwardA = 2'b01;

        else if(MEM_Rs)
            ForwardA = 2'b10;

        else if(WB_Rs)
            ForwardA = 2'b11;

        else
            ForwardA = 2'b00;

    end

    //-----------------------------------------------------
    // Forward B
    //-----------------------------------------------------
    always @(*) begin

        if(EX_Rt)
            ForwardB = 2'b01;

        else if(MEM_Rt)
            ForwardB = 2'b10;

        else if(WB_Rt)
            ForwardB = 2'b11;

        else
            ForwardB = 2'b00;

    end

    //-----------------------------------------------------
    // Load-Use Stall Detection
    //-----------------------------------------------------
    always @(*) begin

        if(ID_EX_MemRd &&
          ((ID_EX_Rd == IF_ID_Rs) ||
           (ID_EX_Rd == IF_ID_Rt)) &&
           (ID_EX_Rd != 3'd0))

            Stall = 1'b1;

        else
            Stall = 1'b0;

    end

endmodule