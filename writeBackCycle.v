module writeBackCycle(
    input clk,
    input rst,
    input ResW,
    input [31:0] Data,
    input [4:0] Rd3,
    output ResW_out,
    output [4:0] Rd4,
    output [31:0] WB_Data
);
    assign Rd4 = Rd3;
    assign WB_Data = Data;
    assign ResW_out = ResW;

endmodule