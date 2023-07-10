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
  reg [1:0] type;
  
  always @(instruction) begin
    opcode = instruction[4:0];
    stop = instruction[31];
    
    case (instruction[30:29])
      2'b00: begin // R-Type
        type = 2'b00;
        rs1 = instruction[9:5];
        rd = instruction[14:10];
        rs2 = instruction[19:15];
        // unused = instruction[28:20]
      end
      2'b01: begin // J-Type
        type = 2'b01;
        signedimmediate = instruction[28:5];
      end
      2'b10: begin // I-Type
        type = 2'b10;
        rs1 = instruction[9:5];
        rd = instruction[14:10];
        immediate = instruction[28:15];
      end
      2'b11: begin // S-Type
        type = 2'b11;
        rs1 = instruction[9:5];
        rd = instruction[14:10];
        rs2 = instruction[19:15];
        SA = instruction[24:20];
        // unused = instruction[28:25]
      end
    endcase
  end
endmodule

module RegisterFile(
  input clk,
  input rst,
  input [4:0] Rs1,
  input [4:0] Rs2,
  input [4:0] Rd,
  input RegW,
  input [31:0] DataW,
  output [31:0] Op1,
  output [31:0] Op2
);

  reg [31:0] Register[31:0];

  always @(posedge clk)
  begin
      if(RegW && ( Rd != 5'h00))
        Register[Rd] <= DataW;
  end

  assign Op1 = (rst == 1'b0) ? 32'b0 : Register[Rs1];
  assign Op2 = (rst == 1'b0) ? 32'b0 : Register[Rs2];

  initial begin 
      Register[0] = 32'h00000000;
  end
endmodule

module jumpConcat(
  input [23:0] address,
  input [31:0] PC,
  output [31:0] jumpAddress
);
  assign jumpAddress = {PC[31:24],address};

endmodule

module controlUnit(
    input [4:0] op,
    input [1:0] type,
    output extOp,
    output [1:0] ALUSrc,
    output regW,
    output mem_R,
    output mem_W,
    output WB,
    output [1:0] pcSrc,
    output [3:0] ALUOp
);

  mainController mc(.op(op),.type(type),.extOp(extOp),.ALUSrc(ALUSrc),.regW(regW),.mem_R(mem_R),.mem_W(mem_W),.WB(WB),.pcSrc(pcSrc));
  ALUController ALUc(.op(op),.type(type), .ALUOp(ALUOp));

endmodule

module mainController(
    input [4:0] op,
    input [1:0] type,
    output extOp,
    output [1:0] ALUSrc,
    output regW,
    output mem_R,
    output mem_W,
    output WB,
    output [1:0] pcSrc
);
    assign pcSrc =  (type == 2'b01) ? 2'b10:
                    ((type == 2'b10) && (op == 5'b00100)) ? 2'b11:
                                      2'b01;
    
    assign extOp = ((type == 2'b10) && ((op == 5'b00001) ||(op == 5'b00010) || (op == 5'b00011))) ? 1'b1:
                                      1'b0;
    assign ALUSrc = (type == 2'b01) ? 2'b00:
                    (type == 2'b10) ? 2'b01:
                    ((type == 2'b11) && ((op == 5'b00010) || (op == 5'b00011))) ? 2'b00:
                                    2'b10;
    assign mem_W = ((type == 2'b10) && (op == 5'b00011)) ? 1'b1:
                                    1'b0;
    assign mem_R = ((type == 2'b10) && (op == 5'b00010)) ? 1'b1:
                                    1'b0;
    assign WB = ((type == 2'b10) && (op == 5'b00010)) ? 1'b1:
                                    1'b0;
    assign regW = ((type == 2'b10) && ((op == 5'b00011) || (op == 5'b00100))) ? 1'b0:
                  ((type == 2'b01) && ((op == 5'b00000) || (op == 5'b00001))) ? 1'b0:
                  1'b1;                

endmodule


module ALUController(
    input [4:0] op,
    input [1:0] type,
    output [3:0] ALUOp
);
    assign ALUOp = (type == 2'b00) ? (
        (op == 5'b00000) ? 4'b0000 :
        (op == 5'b00001) ? 4'b0001 :
        (op == 5'b00010) ? 4'b0010 :
        (op == 5'b00011) ? 4'b0011 :
        4'b1111
    ) : (type == 2'b10) ? (
        (op == 5'b00000) ? 4'b0100 :
        (op == 5'b00001) ? 4'b0101 :
        (op == 5'b00010) ? 4'b0110 :
        (op == 5'b00011) ? 4'b0111 :
        (op == 5'b00100) ? 4'b1000 :
        4'b1111
    ) : (type == 2'b01) ? (
        (op == 5'b00000) ? 4'b1001 :
        (op == 5'b00001) ? 4'b1010 :
        4'b1111
    ) : (type == 2'b11) ? (
        (op == 5'b00000) ? 4'b1011 :
        (op == 5'b00001) ? 4'b1100 :
        (op == 5'b00010) ? 4'b1101 :
        (op == 5'b00011) ? 4'b1110 :
        4'b1111
    ) : 4'b1111;
endmodule

