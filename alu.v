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
