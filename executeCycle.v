`include "components.v"

module executeCycle(
  input clk,
  input rst,
  input [31:0] PC,
  input [31:0] ExImm,
  input [31:0] Op1,
  input [31:0] Op2,
  input [31:0] SA,
  input [4:0] Rd1,
  input [1:0] ALUSrc,
  input [3:0] ALUOp,
  input mem_R,
  input mem_W,
  input WB,
  input RegW,
  input [1:0] PC_Src,
  output [31:0] branchAddress,
  output [31:0] Alu_Res,
  output [4:0] Rd2,
  output mem_R_out,
  output mem_W_out,
  output WB_out,
  output RegW_out,
  output [1:0] PC_Src_out
);
  wire zero, carry, overflow; 
  wire [31:0] mux_out;

  reg [31:0] Alu_Res_Reg, D_Reg;
  reg [4:0] Rd2_Reg;
  reg mem_R_Reg, mem_W_Reg, WB_Reg, RegW_Reg;

  assign Rd2 = Rd1;
  assign mem_R_out = mem_R;
  assign mem_W_out = mem_W;
  assign WB_out = WB;
  assign RegW_out = RegW;
  assign Pc_Src_out = ((zero == 1'b1) && (ALUOp == 4'b1000)) ? 2'b10: PC_Src;

  branchAdder bA(.PC(PC),.ExImm(ExImm),.branchAddress(branchAddress));
  Mux3to1 alusrcmux(.in0(Op2),.in1(ExImm),.in2(SA),.sel(ALUSrc),.out(mux_out));
  ALU alu(.ALUOp(ALUOp),.operandA(Op1),.operandB(mux_out),.result(ALU_Res),.zeroFlag(zero),.carryFlag(carry),.overflowFlag(overflow));

  always @(posedge clk or negedge rst) begin
      if(rst == 1'b0) begin
        Alu_Res_Reg <= 32'h00000000;
        D_Reg <= 32'h00000000;
        Rd2_Reg <= 5'b00000;
        mem_R_Reg <= 1'b0;
        mem_W_Reg <= 1'b0;
        WB_Reg <= 1'b0;
        RegW_Reg <= 1'b0;
      end
      else begin
        Alu_Res_Reg <= ALU_Res;
        D_Reg <= Op2;
        Rd2_Reg <= Rd2;
        mem_R_Reg <= mem_R_out;
        mem_W_Reg <= mem_W_out;
        WB_Reg <= WB_out;
        RegW_Reg <= RegW_out;        
      end
  end 

endmodule
module ALU (
  input [3:0] ALUOp,
  input [31:0] operandA,
  input [31:0] operandB,
  output reg [31:0] result,
  output reg zeroFlag,
  output reg carryFlag,
  output reg overflowFlag
);

  always @*
    case (ALUOp)
      4'b0000: result = operandA & operandB;          // AND
      4'b0001: result = operandA + operandB;          // ADD
      4'b0010: result = operandA - operandB;          // SUB
      4'b0011: begin                                   // CMP with flags set
                 result = operandA - operandB;
                 zeroFlag = (result == 0);
                 carryFlag = (operandA < operandB);
                 overflowFlag = (operandA[31] != operandB[31]) && (result[31] == operandB[31]);
               end
      4'b0100: result = operandA & operandB;          // ANDI
      4'b0101: result = operandA + operandB;          // ADDI
      4'b0110: result = operandA + operandB;          // LW
      4'b0111: result = operandA + operandB;          // SW
      4'b1000: result = operandA - operandB;          // BEQ
      4'b1001: result = operandA;                     // J
      4'b1010: result = operandA;                     // JAL
      4'b1011: result = operandA << operandB[4:0];    // SLL
      4'b1100: result = operandA >> operandB[4:0];    // SLR
      4'b1101: result = operandA << operandB[4:0];    // SLLV
      4'b1110: result = operandA >> operandB[4:0];    // SLRV
      default: result = 32'b0;                        // Default case
    endcase

endmodule

module branchAdder (
    input [31:0] PC,
    input [31:0] ExImm,
    output [31:0] branchAddress
    );
    assign branchAddress =  PC + ExImm;
endmodule

// module PCControl(

// );
// endmodule