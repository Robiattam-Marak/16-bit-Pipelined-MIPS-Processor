//=========================================================
// MAIN CONTROL UNIT
// 16-bit MIPS Processor
//=========================================================
module main_control_unit(

    input  [4:0] opcode,

    output reg RegWr,
    output reg RegDst,

    output reg J,
    output reg JAL,
    output reg LUI,

    output reg ExtOp,
    output reg ALUSrc,

    output reg MemRd,
    output reg MemWr,

    output reg MemtoReg
);

    //-----------------------------------------------------
    // OPCODE DEFINITIONS
    //-----------------------------------------------------
    localparam RTYPE0 = 5'd0;
    localparam RTYPE1 = 5'd1;
    localparam JR_OP  = 5'd2;

    localparam ANDI   = 5'd4;
    localparam ORI    = 5'd5;
    localparam XORI   = 5'd6;
    localparam ADDI   = 5'd7;

    localparam SLL    = 5'd8;
    localparam SRL    = 5'd9;
    localparam SRA    = 5'd10;
    localparam ROR    = 5'd11;

    localparam LW     = 5'd12;
    localparam SW     = 5'd13;

    localparam BEQ    = 5'd14;
    localparam BNE    = 5'd15;
    localparam BLT    = 5'd16;
    localparam BGE    = 5'd17;

    localparam LUI_OP = 5'd18;

    localparam J_OP   = 5'd30;
    localparam JAL_OP = 5'd31;

    //-----------------------------------------------------
    // CONTROL LOGIC
    //-----------------------------------------------------
    always @(*) begin

        //-------------------------------------------------
        // DEFAULTS
        //-------------------------------------------------
        RegWr    = 1'b0;
        RegDst   = 1'b0;

        J        = 1'b0;
        JAL      = 1'b0;
        LUI      = 1'b0;

        ExtOp    = 1'b0;
        ALUSrc   = 1'b0;

        MemRd    = 1'b0;
        MemWr    = 1'b0;

        MemtoReg = 1'b0;

        //-------------------------------------------------
        // OPCODE DECODE
        //-------------------------------------------------
        case(opcode)

            //-----------------------------
            // R-TYPE
            //-----------------------------
            RTYPE0,
            RTYPE1:
            begin
                RegWr  = 1'b1;
                RegDst = 1'b1;
            end

            //-----------------------------
            // JR
            //-----------------------------
            JR_OP:
            begin
                // No signals generated
            end

            //-----------------------------
            // ANDI ORI XORI
            //-----------------------------
            ANDI,
            ORI,
            XORI:
            begin
                RegWr  = 1'b1;
                ALUSrc = 1'b1;
            end

            //-----------------------------
            // ADDI
            //-----------------------------
            ADDI:
            begin
                RegWr  = 1'b1;
                ALUSrc = 1'b1;
                ExtOp  = 1'b1;
            end

            //-----------------------------
            // SHIFTS
            //-----------------------------
            SLL,
            SRL,
            SRA,
            ROR:
            begin
                RegWr  = 1'b1;
                ALUSrc = 1'b1;
            end

            //-----------------------------
            // LW
            //-----------------------------
            LW:
            begin
                RegWr    = 1'b1;
                ALUSrc   = 1'b1;
                ExtOp    = 1'b1;

                MemRd    = 1'b1;
                MemtoReg = 1'b1;
            end

            //-----------------------------
            // SW
            //-----------------------------
            SW:
            begin
                ALUSrc = 1'b1;
                ExtOp  = 1'b1;
                MemWr  = 1'b1;
            end

            //-----------------------------
            // BRANCHES
            //-----------------------------
            BEQ,
            BNE,
            BLT,
            BGE:
            begin
                ExtOp = 1'b1;
            end

            //-----------------------------
            // LUI
            //-----------------------------
            LUI_OP:
            begin
                RegWr = 1'b1;
                LUI   = 1'b1;
            end

            //-----------------------------
            // J
            //-----------------------------
            J_OP:
            begin
                J = 1'b1;
            end

            //-----------------------------
            // JAL
            //-----------------------------
            JAL_OP:
            begin
                RegWr = 1'b1;
                J     = 1'b1;
                JAL   = 1'b1;
            end

            default:
            begin
                // Keep defaults
            end

        endcase

    end

endmodule