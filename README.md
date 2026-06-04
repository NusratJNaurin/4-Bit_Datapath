# 4-Bit Datapath — Verilog

A simple 4-bit datapath implemented in Verilog, combining an ALU and a register file. Designed as a foundational digital design component suitable for simulation and synthesis.

---

## What It Does

The datapath consists of three modules:

| Module | Description |
|---|---|
| `alu` | Performs ADD, SUB, AND, OR on two 4-bit operands. Outputs a 4-bit result and a Zero Flag (ZF). |
| `register_file` | Holds 4 general-purpose 4-bit registers (R0–R3). Supports synchronous writes and combinational reads on two ports. |
| `datapath` | Top-level module. Wires the register file outputs into the ALU inputs and exposes `final_result` and `ZF`. |

### ALU Opcodes

| `opcode` | Operation |
|---|---|
| 00 | ADD |
| 01 | SUB |
| 10 | AND |
| 11 | OR |

---

## Top-Level Port Reference

| Port | Direction | Width | Description |
|---|---|---|---|
| `clk` | Input | 1-bit | Clock (rising-edge triggered writes) |
| `load` | Input | 1-bit | `1` = write external `input_value`; `0` = write ALU result |
| `WE` | Input | 1-bit | Write enable for register file |
| `input_value` | Input | 4-bit | External data to load into a register |
| `SELA` | Input | 2-bit | Selects register for ALU operand A |
| `SELB` | Input | 2-bit | Selects register for ALU operand B |
| `SELD` | Input | 2-bit | Selects destination register for write |
| `opcode` | Input | 2-bit | ALU operation selector |
| `final_result` | Output | 4-bit | ALU computation result |
| `ZF` | Output | 1-bit | Zero flag — high when `final_result == 0` |

---

## Getting Started

### Requirements

Any standard Verilog simulator works. Common options:

- **[Icarus Verilog](http://iverilog.icarus.com/)** (free, open-source)
- **[ModelSim / QuestaSim](https://www.intel.com/content/www/us/en/software/programmable/quartus-prime/model-sim.html)**
- **[Vivado Simulator](https://www.xilinx.com/products/design-tools/vivado.html)** (for Xilinx FPGA synthesis)
- **[EDA Playground](https://www.edaplayground.com/)** (browser-based, no install needed)

### Simulate with Icarus Verilog

```bash
# 1. Clone the repo
git clone https://github.com/your-username/your-repo.git
cd your-repo

# 2. Compile
iverilog -o datapath_sim datapath.v

# 3. Run
vvp datapath_sim
```

> To view waveforms, add `$dumpfile` / `$dumpvars` to your testbench and open the output `.vcd` in **GTKWave**.

### Synthesize (Vivado / Quartus)

1. Create a new RTL project and add `datapath.v` as a design source.
2. Set `datapath` as the top module.
3. Run Synthesis → Implementation → Bitstream generation as needed.

---

## Writing a Testbench

Create a `tb_datapath.v` file that instantiates the `datapath` module, drives inputs, and checks outputs. A minimal example:

```verilog
`timescale 1ns/1ps

module tb_datapath;
    reg clk, load, WE;
    reg [3:0] input_value;
    reg [1:0] SELA, SELB, SELD, opcode;
    wire [3:0] final_result;
    wire ZF;

    datapath uut (
        .clk(clk), .load(load), .WE(WE),
        .input_value(input_value),
        .SELA(SELA), .SELB(SELB), .SELD(SELD),
        .opcode(opcode),
        .final_result(final_result), .ZF(ZF)
    );

    always #5 clk = ~clk;   // 10 ns clock period

    initial begin
        clk = 0; WE = 0; load = 1;

        // Load 4 into R0
        input_value = 4'd4; SELD = 2'b00; WE = 1; @(posedge clk);
        // Load 3 into R1
        input_value = 4'd3; SELD = 2'b01; @(posedge clk);
        WE = 0;

        // ADD R0 + R1 → expect 7
        SELA = 2'b00; SELB = 2'b01; opcode = 2'b00; load = 0;
        #2; $display("ADD result: %0d (ZF=%b)", final_result, ZF);

        $finish;
    end
endmodule
```

Compile and run:

```bash
iverilog -o tb_sim datapath.v tb_datapath.v
vvp tb_sim
```

---

## Project Structure

```
.
├── datapath.v      # Top-level datapath + ALU + register file
└── README.md
```

---

## Contributing

1. Fork the repository.
2. Create a feature branch: `git checkout -b feature/your-feature`
3. Commit your changes: `git commit -m "Add your feature"`
4. Push and open a Pull Request.

Please include a testbench with any new module additions.

---

## License

This project is released under the [MIT License](LICENSE).
