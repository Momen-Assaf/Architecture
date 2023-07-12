`include "fetchCycle.v"
`include "decodeCycle.v"
`include "executeCycle.v"
`include "memoryCycle.v"
`include "writeBackCycle.v"

module pipeLine(
    input clk,
    input rst,
    output [31:0]WB_Data
);

    wire [31:0]PC, address, jumpAddress,branchAddress, instruction, PC_next, DataW , ExImm, Op1, Op2, ExSA, ALU_Res;
    wire [4:0] Rd;
    wire [3:0] ALUOp;
    wire mem_R, mem_W, WB, RegW;
    wire [1:0] PC_Src, ALUSrc;


    fetchCycle ft(.clk(clk),.rst(rst),.PC_Src(PC_Src),.PC(PC),.Address(address),.jumpAddress(jumpAddress),.branchAddress(branchAddress),.Instruction(instruction),.PC_Next(PC_next));
    decodeCycle dc(.clk(clk),.rst(rst),.Instruction(instruction),.PC(PC),.DataW(DataW),.PC_out(PC),.ExImm(ExImm),.Op1(Op1),.Op2(Op2),.ExSA(ExSA),.Rd(Rd),.ALUSrc(ALUSrc),.ALUOp(ALUOp),.mem_R(mem_R),.mem_W(mem_W),.WB(WB),.RegW(RegW),.PC_Src(PC_Src),.jumpAddress(jumpAddress));
    executeCycle ec(.clk(clk),.rst(rst),.PC(PC),.ExImm(ExImm),.Op1(Op1),.Op2(Op2),.SA(ExSA),.Rd1(Rd),.ALUSrc(ALUSrc),.ALUOp(ALUOp),.mem_R(mem_R),.mem_W(mem_W),.WB(WB),.RegW(RegW),.PC_Src(PC_Src),.branchAddress(branchAddress),.Alu_Res(ALU_Res),.Rd2(Rd),.mem_R_out(mem_R),.mem_W_out(mem_W),.WB_out(WB),.RegW_out(RegW),.PC_Src_out(PC_Src));
    memoryCycle mc(.clk(clk),.rst(rst),.Mem_R(mem_R),.Mem_W(mem_W),.WB(WB),.RegW(RegW),.ALU_Res(ALU_Res),.Data_in(Op2),.Rd2(Rd),.RegW_out(RegW),.WB_Data(WB_Data),.Rd3(Rd));
    writeBackCycle wbc(.clk(clk),.rst(rst),.ResW(RegW),.Data(WB_Data),.Rd3(Rd),.ResW_out(RegW),.Rd4(Rd),.WB_Data(WB_Data));
endmodule