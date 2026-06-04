// Simple 4-bit datapath: ALU + Register File
// - ALU: performs ADD, SUB, AND, OR on 4-bit inputs
// - Register file: 4 registers (R0..R3), 4-bit each
// - Datapath: wires the register file to the ALU and exposes
//   `final_result` (ALU output) and `ZF` (zero flag).

`timescale 1ns/1ps

// --- ALU MODULE ---
// Inputs:
//  - `A`, `B`: 4-bit operands
//  - `opcode`: operation selector (2'b00=ADD, 2'b01=SUB, 2'b10=AND, 2'b11=OR)
// Outputs:
//  - `result`: 4-bit operation result
//  - `ZF`: zero flag, high when `result` == 0
module alu (
    input [3:0] A, 
    input [3:0] B,
    input [1:0] opcode, //00=ADD, 01=SUB, 10=AND, 11=OR
    output reg [3:0] result, 
    output ZF
);

always @(*) begin
    case (opcode)
        2'b00: result = A + B;
        2'b01: result = A - B;
        2'b10: result = A & B;
        2'b11: result = A | B;
        default: result = 4'b0000;
    endcase
end

assign ZF = (result == 4'b0000) ? 1'b1 : 1'b0;

endmodule



// --- REGISTER FILE MODULE ---
// A small register file with 4 registers (R0..R3).
// Ports:
//  - `clk`: clock for synchronous writes
//  - `load`: selects between external `input_value` (when load==1)
//            and `alu_out` (when load==0) as the write data
//  - `WE`: write enable; when high on rising `clk`, writes occur
//  - `input_value`: 4-bit external data (used when `load`==1)
//  - `alu_out`: data produced by the ALU (used when `load`==0)
//  - `SELA`, `SELB`: 2-bit selectors to choose which register
//                   is presented on outputs `A` and `B` (read ports)
//  - `SELD`: 2-bit selector choosing destination register for writes
// Outputs:
//  - `A`, `B`: 4-bit read ports feeding the ALU inputs
module register_file(
  input clk, input load, input WE,
  input [3:0] input_value, alu_out,
  input [1:0] SELA, SELB, SELD,
  output [3:0] A, B
);
  
  reg [3:0] stored_value;
  reg [3:0] registers [3:0];
  
  // Data selection MUX: choose between external input and ALU result
  always @(*) begin
    stored_value = (load == 1'b0) ? alu_out : input_value;
  end
  
  // Synchronous write: on rising edge of `clk`, if `WE` is asserted,
  // write the selected `stored_value` into register selected by `SELD`.
  always @(posedge clk) begin
    if (WE) begin
      case(SELD)
        2'b00: registers[0] <= stored_value;
        2'b01: registers[1] <= stored_value;
        2'b10: registers[2] <= stored_value;
        2'b11: registers[3] <= stored_value;
        default: registers[0] <= stored_value;
      endcase
    end
  end
  
  // Read ports (combinational): present selected registers on A and B
  assign A = registers[SELA];
  assign B = registers[SELB];
  
endmodule



// --- DATAPATH MODULE ---
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
