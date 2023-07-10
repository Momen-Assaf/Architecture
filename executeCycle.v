`include "components.v"

module ALU (
  input [3:0] ALUOp,
  input [31:0] operandA,
  input [31:0] operandB,
  output [31:0] result,
  output zeroFlag,
  output carryFlag,
  output overflowFlag
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
