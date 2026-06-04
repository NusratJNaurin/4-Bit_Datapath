`timescale 1ns/1ps

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
  
  reg [3:0] registers [3:0];
  
  // Synchronous write: on rising edge of `clk`, if `WE` is asserted,
  // write the selected `stored_value` into register selected by `SELD`.
  always @(posedge clk) begin
    if (WE) begin
        if (load) begin
            registers[SELD] <= input_value; 
        end else begin
            registers[SELD] <= alu_out;     
        end
    end  
  end
  
  // Read ports (combinational): present selected registers on A and B
  assign A = registers[SELA];
  assign B = registers[SELB];
  
endmodule
