// Simple 4-bit datapath: ALU + Register File
// - ALU: performs ADD, SUB, AND, OR on 4-bit inputs
// - Register file: 4 registers (R0..R3), 4-bit each
// - Datapath: wires the register file to the ALU and exposes
//   `final_result` (ALU output) and `ZF` (zero flag).

`timescale 1ns/1ps

module datapath(
	input clk,
    input load,
  	input WE,
    input [3:0] input_value,
    input [1:0] SELA,
    input [1:0] SELB,
    input [1:0] SELD,
    input [1:0] opcode,
  	output [3:0] final_result,
  	output ZF
);
  
  wire [3:0] alu_out;
  wire [3:0] A;
  wire [3:0] B;
  
  register_file RF (
    .clk(clk),
    .load(load),
    .WE(WE),
    .input_value(input_value),
    .alu_out(alu_out),
    .SELA(SELA),
    .SELB(SELB),
    .SELD(SELD),
    .A(A), 
    .B(B)
  );
  
  alu ALU(
    .A(A),
    .B(B),
    .opcode(opcode),
    .result(alu_out),
    .ZF(ZF)
  );
  
  assign final_result = alu_out;

endmodule
