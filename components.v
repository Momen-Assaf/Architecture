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
