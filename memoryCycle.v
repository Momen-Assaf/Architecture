`include "components.v"

module memoryCycle(
    input clk,
    input rst,
    input Mem_R,
    input Mem_W,
    input WB,
    input RegW,
    input [31:0] Alu_Res,
    input [31:0] Data_in,
    input [4:0] Rd2,
    output RegW_out,
    output [31:0] WB_Data,
    output [4:0] Rd3
);
    wire [31:0] Data_out;
    reg [31:0] WB_Data_Reg;
    reg [4:0] Rd3_reg;
    reg RegW_Reg;

    assign Rd3 = Rd2;
    assign RegW_out = RegW;

    DataMemomry DM(.clk(clk),.rst(rst),.Mem_R(Mem_R),.Mem_W(Mem_W),.address(Alu_Res),.Data_in(Data_in),.Data_out(WB_Data));
    Mux2to1 muxWb(.in0(ALU_Res),.in1(WB_Data),.sel(WB),.out(Data_out));

    always @(posedge clk or negedge rst) begin
        if(rst == 1'b0) begin
            WB_Data_Reg <= 32'h00000000;
            Rd3_reg <= 5'b00000;
            RegW_Reg <= 1'b0;
        end
        else begin
            WB_Data_Reg <= Data_out;
            Rd3_reg <= Rd3;
            RegW_Reg <= RegW;
        end
    end
    
endmodule
module DataMemomry(
    input clk,
    input rst,
    input Mem_R,
    input Mem_W,
    input [31:0] address,
    input [31:0] Data_in,
    output reg [31:0] Data_out
);
    reg [31:0] mem [1023:0];

    always @(posedge clk)
    begin
        if(Mem_W)begin
            mem[address] <= Data_in;
        end else if(Mem_R && ~rst)begin
            Data_out <= mem[address];
        end
    end

    initial begin
        mem[0] = 32'h00000000;
    end

endmodule