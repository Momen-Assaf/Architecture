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

    opcode = instruction[4:0];
    stop = instruction[31];
    if(type == 2'b00) begin // R-Type
      rs1 = instruction[9:5];
      rd = instruction[14:10];
      rs2 = instruction[19:15];
      //usused = instruction[28:20]

    end else if(type = 2'b01 )begin // J-Type
      signedimmediate = instruction[28:5]

    end else if (type = 2'b10)begin //I-Type
      rs1 = instruction[9:5];
      rd = instruction[14:10];
      immediate = instruction [28:15];

    end else if (type = 2'b11)begin //S-Type
      rs1 = instruction[9:5];
      rd = instruction[14:10];
      rs2 = instruction[19:15];
      SA = instruction[24:20];
      //usused = instruction[28:25]
    end
  end
endmodule


module jumpConcat(
  input [23:0] address,
  input [31:0] PC,
  output [31:0] jumpAddress
);
  assign jumpAddress = {PC[31:24],address};

endmodule

module mainController(
    input [4:0] op,
    input [1:0] type,
    output extOp,
    output [1:0] ALUSrc,
    output regWrite,
    output memRead,
    output memWrite,
    output [1:0] pcSrc
);
    assign pcSrc =  (type == 2'b01) ? 2'b10:
                    ((type == 2'b10) && (op == 5'b00100)) ? 2'b11:
                                      2'b01;
    assign ALUSrc = (type == 2'b01) ? 2'b00:
                    (type == 2'b10) ? 2'b01:
                    ((type == 2'11) && (op == 5'b00010 ||op == 5'b00011)) ? 2'b00:
                                    2'b10;

endmodule

module ALUController(
    input [4:0] op,
    input [1:0] type,
    output [3:0] ALUOp
);
    if(type == 2'b00) begin // R-Type
      assign ALUOp =(op == 5'b00000) ?  4'b0000:
                    (op == 5'b00001) ?  4'b0001:
                    (op == 5'b00010) ?  4'b0010:
                    (op == 5'b00011) ?  4'b0011:
                                        4'b1111;

    end else if (type = 2'b10)begin //I-Type
      assign ALUOp =(op == 5'b00000) ?  4'b0100:
                    (op == 5'b00001) ?  4'b0101:
                    (op == 5'b00010) ?  4'b0110:
                    (op == 5'b00011) ?  4'b0111:
                    (op == 5'b00100) ?  4'b1000:
                                        4'b1111;

    end else if(type = 2'b01 )begin // J-Type
      assign ALUOp =(op == 5'b00000) ?  4'b1001:
                    (op == 5'b00001) ?  4'b1010:
                                        4'b1111;

    end else if (type = 2'b11)begin //S-Type
      assign ALUOp =(op == 5'b00000) ?  4'b1011:
                    (op == 5'b00001) ?  4'b1100:
                    (op == 5'b00010) ?  4'b1101:
                    (op == 5'b00011) ?  4'b1110:
                                        4'b1111;
    end
endmodule
