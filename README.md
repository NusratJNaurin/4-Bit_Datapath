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

### ALU Operation Codes (OPR)

| `OPR` | Operation |
|---|---|
| `2'b00` | ADD |
| `2'b01` | SUB |
| `2'b10` | AND |
| `2'b11` | OR |

## Circuit Design (Logisim)

> Logisim circuit originally designed by Ayat Selim, Nusrat Naurin, and Yasmeen Radwan as part of CMPE263-L51 project.
> The Verilog in this repository is an independent HDL implementation of the same datapath.

<img width="6056" height="4008" alt="project1" src="https://github.com/user-attachments/assets/2664ffa0-2c16-4670-8544-ee95feeb37d5" />


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
| `OPR` | Input | 2-bit | ALU operation selector |
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

### Simulate with Icarus Verilog (Local)

```bash
# 1. Clone the repo
git clone https://github.com/your-username/your-repo.git
cd your-repo

# 2. Compile
iverilog -o datapath_sim alu.v register_file.v datapath.v

# 3. Run
vvp datapath_sim
```

> To view waveforms, add `$dumpfile` / `$dumpvars` to your testbench and open the output `.vcd` in **GTKWave**.

### Synthesize (Vivado / Quartus)

1. Create a new RTL project and add `datapath.v` as a design source.
2. Set `datapath` as the top module.
3. Run Synthesis → Implementation → Bitstream generation as needed.

### Simulate on EDA Playground (No Install)

1. Go to [edaplayground.com](https://www.edaplayground.com) and create a free account.
2. Under **Tools & Simulators**, select `Icarus Verilog 0.9.7`.
3. Paste the contents of `alu.v`, `register_file.v`, and `datapath.v` into the **Design** panel.
4. Paste the contents of `datapath_tb.v` into the **Testbench** panel.
5. Check **Open EPWave after run** to view waveforms.
6. Click **Run**.

---

## Running the Testbench

A testbench is included in `datapath_tb.v`. It instantiates the `datapath` module, drives inputs, and verifies outputs.

```bash
# Compile all source files together with the testbench
iverilog -o tb_sim alu.v register_file.v datapath.v datapath_tb.v

# Run
vvp tb_sim
```

> To view waveforms, ensure `$dumpfile` / `$dumpvars` are present in `datapath_tb.v` and open the generated `.vcd` file in **GTKWave**.


The waveform below shows all four ALU operations — ADD (`c`), SUB (`8`), AND (`a`), OR (`f`).

<img width="2426" height="858" alt="Screenshot 2026-06-05 041450" src="https://github.com/user-attachments/assets/634d3665-1a81-47ae-b9ac-987ecc9e85ec" />

---

## Project Structure

```
.
├── alu.v             # ALU module (ADD, SUB, AND, OR + zero flag)
├── register_file.v   # 4-register file with synchronous write and dual read ports
├── datapath.v        # Top-level module wiring register file and ALU
├── datapath_tb.v     # Testbench for the datapath module
└── README.md
```

---

## Contributing

1. Fork the repository.
2. Create a feature branch: `git checkout -b feature/your-feature`
3. Commit your changes: `git commit -m "Add your feature"`
4. Push and open a Pull Request.

Please include a testbench with any new module additions.
