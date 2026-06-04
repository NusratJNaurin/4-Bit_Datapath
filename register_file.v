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
