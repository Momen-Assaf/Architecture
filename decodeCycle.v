module decodeCycle(
    input clk,
    input rst,
    input [31:0] Instruction,
    input [31:0] PC,
    input [31:0] DataW,
    output [31:0] PC_out,
    output [31:0] ExImm,
    output [31:0] Op1,
    output [31:0] Op2,
    output [31:0] ExSA,
    output [4:0] Rd,
    output [1:0] ALUSrc,
    output [3:0] ALUOp,
    output mem_R,
    output mem_W,
    output WB,
    output RegW,
    output [1:0] PC_Src,
    output [31:0] jumpAddress
);
  wire [13:0] immediate;
  wire [23:0] signedimmediate;
  wire [4:0] opcode, Rs1, Rs2, SA;
  wire [1:0] type;
  wire stop;

  wire extOp;

  reg [31:0] PC_Reg, ExImm_Reg, Op1_Reg, Op2_Reg, ExSA_Reg;
  reg [4:0] Rd1;
  reg [3:0] ALUOp_Reg;
  reg [1:0] Pc_Src_Reg,ALUSrc_Reg;
  reg mem_R_Reg, mem_W_Reg, WB_Reg, RegW_Reg;

  assign PC_out = PC;

  instructionDecoder id(.instruction(Instruction),.opcode(opcode),.rs1(Rs1),.rs2(Rs2),.rd(Rd),.immediate(immediate),.type(type),.stop(stop),.signedimmediate(signedimmediate),.SA(SA));
  controlUnit CU(.op(opcode),.type(type),.extOp(extOp),.ALUSrc(ALUSrc),.regW(RegW),.mem_R(mem_R),.mem_W(mem_W),.WB(WB),.pcSrc(PC_Src),.ALUOp(ALUOp));
  RegisterFile rf(.clk(clk),.rst(rst),.Rs1(Rs1),.Rs2(Rs2),.Rd(Rd),.RegW(RegW),.DataW(DataW),.Op1(Op1),.Op2(Op2));
  jumpConcat jC(.address(signedimmediate),.PC(PC),.jumpAddress(jumpAddress));
  ExtendImmediate eI(.imm(immediate),.ExtOp(extOp),.extended_imm(ExImm));
  ExtendSA eS(.SA(SA),.SA_EX(ExSA));

  always @(posedge clk or negedge rst) begin
      if(rst == 1'b0) begin
        PC_Reg <= 32'h00000000;
        ExImm_Reg <= 32'h00000000;
        Op1_Reg <= 32'h00000000;
        Op2_Reg <= 32'h00000000;
        ExSA_Reg <= 32'h00000000;
        Rd1 <= 5'b00000;
        ALUSrc_Reg <= 2'b00;
        ALUOp_Reg <= 4'b0000;
        mem_R_Reg <= 1'b0;
        mem_W_Reg <= 1'b0;
        WB_Reg <= 1'b0;
        RegW_Reg <= 1'b0;
        Pc_Src_Reg <= 2'b00;
      end
      else begin
        PC_Reg <= PC_out;
        ExImm_Reg <= ExImm;
        Op1_Reg <= Op1;
        Op2_Reg <= Op2;
        ExSA_Reg <= ExSA;
        Rd1 <= Rd;
        ALUSrc_Reg <= ALUSrc;
        ALUOp_Reg <= ALUOp;
        mem_R_Reg <= mem_R;
        mem_W_Reg <= mem_W;
        WB_Reg <= WB;
        RegW_Reg <= RegW;
        Pc_Src_Reg <= PC_Src;
      end
  end 

endmodule

module instructionDecoder(
  input [31:0] instruction,
  output reg [4:0] opcode,
  output reg [4:0] rs1,
  output reg [4:0] rs2,
  output reg [4:0] rd,
  output reg [13:0] immediate,
  output reg [1:0] type,
  output reg stop,
  output reg [23:0] signedimmediate,
  output reg [4:0] SA
);
  always @* begin
    opcode = instruction[4:0];
    stop = instruction[31];
    
    case (instruction[30:29])
      2'b00: begin // R-Type
        type = 2'b00;
        rs1 = instruction[19:15];
        rs2 = instruction[24:20];
        rd = instruction[11:7];
        // unused = instruction[6:0]
      end
      2'b01: begin // J-Type
        type = 2'b01;
        signedimmediate = {instruction[28], instruction[25:0], 2'b00};
      end
      2'b10: begin // I-Type
        type = 2'b10;
        rs1 = instruction[19:15];
        rd = instruction[24:20];
        immediate = instruction[24:9];
      end
      2'b11: begin // S-Type
        type = 2'b11;
        rs1 = instruction[19:15];
        rs2 = instruction[24:20];
        SA = instruction[11:7];
        // unused = instruction[6:0]
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
      Register[0] = 32'h00000011;
  end
endmodule

module jumpConcat(
  input [23:0] address,
  input [31:0] PC,
  output [31:0] jumpAddress
);
  assign jumpAddress = {PC[31:24],address};

endmodule

module ExtendSA(
    input [4:0] SA,
    output [31:0] SA_EX
);
    assign SA_EX = {{27{1'b0}}, SA};
endmodule

module ExtendImmediate(
    input [13:0] imm,
    input ExtOp,
    output [31:0] extended_imm
);
    assign extended_imm = (ExtOp == 1'b1) ? {{18{imm[13]}}, imm} : {18'b0, imm};
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
    assign ALUSrc = (type == 2'b00) ? 2'b00:
                    (type == 2'b10) ? 2'b01:
                    ((type == 2'b11) && ((op == 5'b00010) || (op == 5'b00011))) ? 2'b10:
                                    2'b11;
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

