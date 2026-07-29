module data_memory(

    input clk,

    input MemWr,
    input MemRd,

    input [15:0] address,
    input [15:0] write_data,

    output reg [15:0] read_data
);

    reg [15:0] RAM [0:255];

    integer i;

    initial begin

        for(i=0;i<256;i=i+1)
            RAM[i] = 16'b0;

        RAM[10] = 16'd55;
        RAM[11] = 16'd99;

    end

    //-----------------------------------------
    // WRITE
    //-----------------------------------------
    always @(posedge clk)
    begin
        if(MemWr)
            RAM[address[7:0]] <= write_data;
    end

    //-----------------------------------------
    // READ
    //-----------------------------------------
    always @(*)
    begin
        if(MemRd)
            read_data = RAM[address[7:0]];
        else
            read_data = 16'b0;
    end

endmodule