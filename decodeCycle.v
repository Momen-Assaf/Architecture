`include "components.v"

module decodeCylce(
    input clk,
    input rst,
    input [31:0] Instruction,
    input [31:0] PC_Next,
    input [31:0] PC_Reg,
    
);
endmodule

module instructionDecoder(
  input [31:0] instruction,
  output [4:0] opcode,
  output [4:0] rs1,
  output [4:0] rs2,
  output [4:0] rd,
  output [13:0] immediate,
  output [1:0] type,
  output stop,
  output [23:0] signedimmediate,
  output [4:0] SA
);
  type = instruction[30:29];

  always @(instruction) begin

    if(type == 2'b00) begin // R-Type

      opcode = instruction[4:0];
      rs1 = instruction[9:5];
      rd = instruction[14:10];
      rs2 = instruction[19:15];
      //usused = instruction[28:20]

    end else if(type = 2'b01 )begin // J-Type

      opcode = instruction[4:0];
      signedimmediate = instruction[28:5]

    end else if (type = 2'b10)begin //I-Type

      opcode = instruction[4:0];
      rs1 = instruction[9:5];
      rd = instruction[14:10];
      immediate = instruction [28:15];

    end else if (type = 2'b11)begin //S-Type

      opcode = instruction[4:0];
      rs1 = instruction[9:5];
      rd = instruction[14:10];
      rs2 = instruction[19:15];
      SA = instruction[24:20];
      //usused = instruction[28:25]
    end
    stop = instruction[31];
  end
endmodule

