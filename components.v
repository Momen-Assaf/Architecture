// Define (ISA)
// module ISA (
//   input [31:0] instruction,     // Input instruction
//   input [4:0] rs1,              // first source register
//   input [4:0] rs2,              // second source register
//   input [4:0] rd,               // destination register
//   input [13:0] immediate,       // unsigned for logic instructions, and signed otherwise
//   output [31:0] controlSignals, // Output control signals
//   output [4:0] memAddress,      // Memory address
//   output [31:0] memData         // Memory data
// );
//   // Wire declarations for control signals
//   wire aluOp, aluSrc, regWrite, memRead, memWrite, branch, jump;
  
//   // Control signal assignments based on instruction type and function
//   assign aluOp = (instruction[30:29] == 2'b00) ? 1'b1 : 1'b0;      // R-type or I-type
//   assign aluSrc = (instruction[30:29] == 2'b11) ? 1'b1 : 1'b0;     // I-type or S-type
//   assign regWrite = (instruction[30:29] != 2'b11) ? 1'b1 : 1'b0;   // R-type or I-type
//   assign memRead = (instruction[30:29] == 2'b10) ? 1'b1 : 1'b0;    // I-type or S-type (load)
//   assign memWrite = (instruction[30:29] == 2'b11) ? 1'b1 : 1'b0;   // S-type (store)
//   assign branch = (instruction[30:29] == 2'b10) ? 1'b1 : 1'b0;     // I-type (branch)
//   assign jump = (instruction[30:29] == 2'b01) ? 1'b1 : 1'b0;       // J-type
  
//   // Register file structure
//   reg [31:0] regFile [0:31];   // 32 general-purpose registers
  
//   // Memory interfaces
//   reg [4:0] memAddress;        // Memory address
//   reg [31:0] memData;          // Memory data
  
//   // Implement the instruction decoding and control signal assignment
//   always @* begin
//     case (instruction[31:30])
//       2'b00: controlSignals = {aluOp, aluSrc, regWrite, 1'b0};   // R-Type
//       2'b10: controlSignals = {aluOp, aluSrc, regWrite, 1'b0};   // I-Type			
//       2'b11: controlSignals = {aluOp, aluSrc, regWrite, 1'b0};   // S-Type
//       default: controlSignals = {aluOp, aluSrc, regWrite, 4'b0010}  // I-type
//     endcase
//   end
  
//   // Implement the register file read and write operations
//   always @(posedge clk) begin
//     if (regWrite) begin
//       regFile[rd] <= memData;        // Write data to register file
//     end
//   end
// endmodule ISA

module Mux2to1 (
    input [31:0] in0,
    input [31:0] in1,
    input sel,
    output reg [31:0] out
  );
  always @* begin
    case(sel) 
        1'b0: out = in0;
        1'b1: out = in1;
    endcase
  end
endmodule

module Mux3to1 (
    input [31:0] in0,
    input [31:0] in1,
    input [31:0] in2,
    input [1:0] sel,
    output reg [31:0] out
  );
  always @* begin
    case(sel)
      2'b00: out = in0;
      2'b01: out = in1;
      2'b10: out = in2;
    endcase
  end
endmodule
  
module Mux4to1 (
    input [31:0] in0,
    input [31:0] in1,
    input [31:0] in2,
    input [31:0] in3,
    input [1:0] sel,
    output reg [31:0] out
  );
  always @* begin
    case(sel)
      2'b00: out = in0;
      2'b01: out = in1;
      2'b10: out = in2;
      2'b11: out = in3;
    endcase
  end
endmodule


  // Implement memory read and write operations


// module DataMemory (
//   input [31:0] address,
//   input [31:0] dataIn,
//   input writeEnable,
//   input readEnable,
//   output reg [31:0] dataOut
// );

//   reg [31:0] memory [0:1023]; // Example: 1024 entries, each storing a 32-bit data word

//   // Initialize the memory with data
//   initial begin
//     // Load initial data into the memory
//     memory[0] = 32'h01234567; // Example data at address 0
//     memory[1] = 32'h89ABCDEF; // Example data at address 1
//     // ...
//   end

//   always @(posedge clk) begin
//     if (readEnable)
//       dataOut <= memory[address];
//     if (writeEnable)
//       memory[address] <= dataIn;
//   end

// endmodule DataMemory

// module InstructionFetch (
//   input [31:0] pc,
//   input [31:0] instructionMemory [0:65535],
//   output reg [31:0] instruction
// );

//   always @(posedge clk) begin
//     instruction <= instructionMemory[pc];
//   end

// endmodule InstructionFetch



// module RegisterFile (
//   input [4:0] rs1,
//   input [4:0] rs2,
//   input [4:0] rd,
//   input writeEnable,
//   input [31:0] BusWrite,
//   output reg [31:0] BusA,
//   output reg [31:0] BusB
// );

//   reg [31:0] registers [0:31]; // Example: 32 general-purpose registers, each storing a 32-bit value

//   always @(rs1 or rs2)
//     BusA = registers[rs1];
//     BusB = registers[rs2];

//   always @(posedge clk) begin
//     if (writeEnable)
//       registers[writeRegister] <= writeData;
//   end

// endmodule RegisterFile

// // Start Execute (

// module ALURtype (
//   input [31:0] operand1,
//   input [31:0] operand2,
//   input [4:0] function,
//   output reg [31:0] result,
//   output reg zeroSignal
// );

//   always @(*) begin
//     case (function)
//       5'b00000: result = operand1 & operand2; // AND operation
//       5'b00001: result = operand1 + operand2; // ADD operation
//       5'b00010: result = operand1 - operand2; // SUB operation
//       5'b00011: begin                          // CMP operation
//         if (operand1 < operand2)
//           zeroSignal = 1'b1;
//         else
//           zeroSignal = 1'b0;
//       end
//       default: result = 32'b0;                  // Default case
//     endcase
//   end

// endmodule ALURtype

// module ALUItype (
//   input [31:0] operand1,
//   input [31:0] operand2,
//   input [4:0] function,
//   output reg [31:0] result,
//   output reg zeroSignal,
//   output reg memWrite
// );

//   always @(*) begin
//     case (function)
//       5'b00000: result = operand1 & operand2; // ANDI operation
//       5'b00001: result = operand1 + operand2; // ADDI operation
//       5'b00010: begin                          // LW operation
//         result = operand1 + operand2;
//         memWrite = 1'b0;
//       end
//       5'b00011: begin                          // SW operation
//         result = operand1 + operand2;
//         memWrite = 1'b1;
//       end
//       5'b00100: begin                          // BEQ operation
//         if (operand1 == operand2)
//           zeroSignal = 1'b1;
//         else
//           zeroSignal = 1'b0;
//       end
//       default: result = 32'b0;                  // Default case
//     endcase
//   end

// endmodule ALUItype


// module ALUJtype (
//   input [31:0] operand1,
//   input [31:0] operand2,
//   input [4:0] function,
//   output reg [31:0] result,
//   output reg zeroSignal,
//   output reg pcWrite,
//   output reg stackPush
// );

//   always @(*) begin
//     case (function)
//       5'b00000: begin                          // J operation
//         result = operand1 + operand2;
//         pcWrite = 1'b1;
//         stackPush = 1'b0;
//       end
//       5'b00001: begin                          // JAL operation
//         result = operand1 + operand2;
//         pcWrite = 1'b1;
//         stackPush = 1'b1;
//       end
//       default: result = 32'b0;                  // Default case
//     endcase
//   end

// endmodule ALUJtype


// module ALUStype (
//   input [31:0] operand1,
//   input [31:0] operand2,
//   input [4:0] function,
//   output reg [31:0] result,
//   output reg zeroSignal,
//   output reg shiftAmount,
//   output reg shiftVariable
// );

//   always @(*) begin
//     case (function)
//       5'b00000: result = operand1 << operand2;       // SLL operation
//       5'b00001: result = operand1 >> operand2;       // SLR operation
//       5'b00010: result = operand1 << operand2[4:0];  // SLLV operation
//       5'b00011: result = operand1 >> operand2[4:0];  // SLRV operation
//       default: result = 32'b0;                        // Default case
//     endcase
    
//     zeroSignal = (result == 0) ? 1'b1 : 1'b0;
//     shiftAmount = operand2;
//     shiftVariable = (function[1] == 1'b1) ? 1'b1 : 1'b0;
//   end

// endmodule ALUStype

// // end Execute

// module MemoryAccess (
//   input [1:0] instructionType,
//   input [4:0] opcode,
//   input [4:0] rs1,
//   input [4:0] rd,
//   input [13:0] immediate,
//   input [31:0] registerFile [0:31],
//   input [31:0] dataMemory [0:1023],
//   output reg [31:0] result
// );

//   always @(instructionType, opcode, rs1, rd, immediate, registerFile, dataMemory) begin
//     case (instructionType)
//       2'b10: begin  // I-type (load)
//         case (opcode)
//           5'b00010: result = dataMemory[registerFile[rs1] + immediate];  // LW
//           default: result = 0;  // Invalid opcode
//         endcase
//       end
      
//       2'b11: begin  // S-type (store)
//         case (opcode)
//           5'b00011: dataMemory[registerFile[rs1] + immediate] = registerFile[rd];  // SW
//           default: result = 0;  // Invalid opcode
//         endcase
//       end
      
//       // Handle other instruction types (R, J) here
      
//       default: result = 0;  // Invalid instruction type
//     endcase
//   end

// endmodule MemoryAccess


// module WriteBack (
//   input [1:0] instructionType,
//   input [4:0] opcode,
//   input [4:0] rd,
//   input [31:0] result,
//   input reg regWrite,
//   output reg [31:0] registerFile [0:31]
// );

//   always @(instructionType, opcode, rd, result, regWrite) begin
//     case (instructionType)
//       2'b00: begin  // R-type
//         case (opcode)
//           5'b00000: registerFile[rd] = result;  // AND
//           5'b00001: registerFile[rd] = result;  // ADD
//           5'b00010: registerFile[rd] = result;  // SUB
//           5'b00011: ;  // CMP (no register update)
//           default: ;  // Invalid opcode
//         endcase
//       end
      
//       2'b10: begin  // I-type
//         case (opcode)
//           5'b00000: registerFile[rd] = result;  // ANDI
//           5'b00001: registerFile[rd] = result;  // ADDI
//           default: ;  // Invalid opcode
//         endcase
//       end
      
//       // Handle other instruction types (J, S) here
      
//       default: ;  // Invalid instruction type
//     endcase
//   end

// endmodule WriteBack

// module DataPath (
//   input wire [31:0] instruction,
//   input wire [31:0] dataMemoryInput,
//   input wire dataMemoryWriteEnable,
//   output reg [31:0] dataMemoryOutput,
//   input wire [31:0] registerFileInput,
//   input wire registerFileWriteEnable,
//   output reg [31:0] registerFileOutput,
//   output reg [31:0] aluInputA,
//   output reg [31:0] aluInputB,
//   output reg [2:0] aluControl
// );

//   // Register declarations
//   reg [31:0] instructionRegister;
//   reg [31:0] dataMemoryOutputRegister;
//   reg [31:0] registerFileOutputRegister;
  
//   // Instruction register
//   always @(posedge clk) begin
//     instructionRegister <= instruction;
//   end
  
//   // Data memory output register
//   always @(posedge clk) begin
//     if (dataMemoryWriteEnable) begin
//       dataMemoryOutputRegister <= dataMemoryInput;
//     end
//   end
  
//   // Register file output register
//   always @(posedge clk) begin
//     if (registerFileWriteEnable) begin
//       registerFileOutputRegister <= registerFileInput;
//     end
//   end
  
//   // Assign data path connections
//   assign dataMemoryOutput = dataMemoryOutputRegister;
//   assign registerFileOutput = registerFileOutputRegister;
//   assign aluInputA = instructionRegister[20:16];
//   assign aluInputB = {instructionRegister[15:11], instructionRegister[25:21]};
//   assign aluControl = instructionRegister[4:0];
  
// endmodule DataPath

// module ControlPath (
//   input wire [31:0] instruction,
//   output reg regWrite,
//   output reg memRead,
//   output reg memWrite,
//   output reg aluOp,
//   output reg branch,
//   output reg jump,
//   output reg [1:0] pcSrc
// );

//   // Control signal declarations
//   reg [1:0] instructionType;
//   reg [4:0] functionCode;
  
//   // Extract instruction type and function code
//   always @(*) begin
//     instructionType = instruction[31:30];
//     functionCode = instruction[4:0];
//   end
  
//   // Control signal assignments
//   always @(*) begin
//     case (instructionType)
//       2'b00: begin  // R-Type
//         regWrite = 1'b1;
//         memRead = 1'b0;
//         memWrite = 1'b0;
//         aluOp = functionCode == 5'b00000 ? 1'b0 : 1'b1;
//         branch = 1'b0;
//         jump = 1'b0;
//         pcSrc = 2'b00;
//       end
      
//       2'b01: begin  // J-Type
//         regWrite = 1'b0;
//         memRead = 1'b0;
//         memWrite = 1'b0;
//         aluOp = 1'b0;
//         branch = 1'b0;
//         jump = 1'b1;
//         pcSrc = 2'b01;
//       end
      
//       2'b10: begin  // I-Type (Branch)
//         regWrite = 1'b0;
//         memRead = 1'b0;
//         memWrite = 1'b0;
//         aluOp = 1'b0;
//         branch = 1'b1;
//         jump = 1'b0;
//         pcSrc = 2'b10;
//       end
      
//       2'b11: begin  // S-Type (Store)
//         regWrite = 1'b0;
//         memRead = 1'b0;
//         memWrite = 1'b1;
//         aluOp = 1'b0;
//         branch = 1'b0;
//         jump = 1'b0;
//         pcSrc = 2'b11;
//       end
      
//       default: begin  // Invalid instruction type
//         regWrite = 1'b0;
//         memRead = 1'b0;
//         memWrite = 1'b0;
//         aluOp = 1'b0;
//         branch = 1'b0;
//         jump = 1'b0;
//         pcSrc = 2'b00;
//       end
//     endcase
//   end
  
// endmodule ControlPath

// module Processor (
//   input wire clk,
//   input wire reset,
//   // Other inputs/outputs
// );

//   // Instantiate components
//   InstructionMemory instructionMemory (.address(PC), .instruction(IFInstruction));
//   RegisterFile registerFile (.clk(clk), .reset(reset), .readRegister1(IDRs1), .readRegister2(IDRs2), .writeRegister(WBWriteReg), .writeData(WBWriteData), .writeEnable(WBRegWrite));
//   ALURtype alur (.input1(EXInput1), .input2(EXInput2), .aluOp(EXALUOp), .output(EXALUResult), .zero(EXZero));
//   ALUItype alui (.input1(EXInput1), .input2(EXImmediate), .aluOp(EXALUOp), .output(EXALUResult), .zero(EXZero));
//   ALUJtype aluj (.input1(EXPC), .input2(EXImmediate), .aluOp(EXALUOp), .output(EXALUResult), .zero(EXZero));
//   ALUStype alus (.input1(EXInput1), .input2(EXShiftAmount), .aluOp(EXALUOp), .output(EXALUResult), .zero(EXZero));
//   DataMemory dataMemory (.address(EXMemALUResult), .writeData(WBMemData), .writeEnable(WBMemWrite));
//   ControlPath controlPath (.instruction(IDInstruction), .regWrite(WBRegWrite), .memRead(MEMRead), .memWrite(MEMWrite), .aluOp(EXALUOp), .branch(EXBranch), .jump(EXJump), .pcSrc(EXPCSrc));
  
//   // Pipeline registers
//   reg [31:0] IFInstruction, IDInstruction, EXInstruction, MEMInstruction, WBInstruction;
//   reg [4:0] IDRs1, IDRs2, WBWriteReg;
//   reg [31:0] WBWriteData, WBMemData;
//   reg WBRegWrite, MEMRead, MEMWrite, EXALUOp, EXBranch, EXJump;
//   reg [1:0] EXPCSrc;
//   reg [31:0] PC, IFNextPC, EXNextPC, MEMNextPC, WBNextPC;
//   reg [31:0] EXInput1, EXInput2, EXALUResult, EXMemALUResult;
//   reg EXZero;
  
//   // Control signals
//   wire WBMemWrite = 1'b1;
  
//   // Fetch stage
//   always @(posedge clk or posedge reset) begin
//     if (reset)
//       PC <= 32'd0;
//     else if (IFNextPC)
//       PC <= PC + 32'd4;
//   end
  
//   assign IFInstruction = instructionMemory.instruction;
  
//   // Decode stage
//   always @(posedge clk or posedge reset) begin
//     if (reset)
//       IDInstruction <= 32'd0;
//     else if (IFNextPC)
//       IDInstruction <= IFInstruction;
//   end
  
//   assign IDRs1 = IDInstruction[25:21];
//   assign IDRs2 = IDInstruction[20:16];
  
//   // Execute stage
//   always @(posedge clk or posedge reset) begin
//     if (reset)
//       EXInstruction <= 32'd0;
//     else if (EXNextPC)
//       EXInstruction <= IDInstruction;
//   end
  
//   assign EXInput1 = registerFile.readData1;
//   assign EXInput2 = registerFile.readData2;
//   assign EXALUOp = controlPath.aluOp;
  
//   // Memory Access stage
//   always @(posedge clk or posedge reset) begin
//     if (reset)
//       MEMInstruction <= 32'd0;
//     else if (MEMNextPC)
//       MEMInstruction <= EXInstruction;
//   end
  
//   assign MEMRead = controlPath.memRead;
//   assign MEMWrite = controlPath.memWrite;
//   assign WBMemData = dataMemory.readData;
  
//   // Write Back stage
//   always @(posedge clk or posedge reset) begin
//     if (reset)
//       WBInstruction <= 32'd0;
//     else if (WBNextPC)
//       WBInstruction <= MEMInstruction;
//   end
  
//   assign WBWriteReg = WBInstruction[11:7];
//   assign WBWriteData = alu.output;
//   assign WBRegWrite = controlPath.regWrite;
  
//   // Control signals
//   assign EXBranch = controlPath.branch;
//   assign EXJump = controlPath.jump;
//   assign EXPCSrc = controlPath.pcSrc;
  
//   // Other control signals and pipeline registers
  
//   // Connect other components and control signals
  
// endmodule Processor


