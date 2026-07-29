# 16-bit Five-Stage Pipelined MIPS Processor

A custom **16-bit MIPS processor** implemented in **Verilog HDL** featuring a complete **five-stage pipeline** with hazard detection, data forwarding, and branch handling. The processor was developed as a computer architecture project and is fully synthesizable in **AMD Xilinx Vivado**.

---

## Features

- ✅ 16-bit MIPS ISA
- ✅ Five-stage pipelined architecture
  - Instruction Fetch (IF)
  - Instruction Decode (ID)
  - Execute (EX)
  - Memory Access (MEM)
  - Write Back (WB)
- ✅ Modular RTL implementation
- ✅ Hazard Detection Unit
- ✅ Data Forwarding Unit
- ✅ Pipeline Registers
- ✅ Register File
- ✅ Instruction Memory
- ✅ Data Memory
- ✅ ALU & ALU Control Unit
- ✅ Branch Comparator
- ✅ PC Control Logic
- ✅ Vivado Simulation Support

---

## Pipeline Overview

```
          +-----+    +-----+    +-----+    +------+    +------+
PC -----> | IF  | -> | ID  | -> | EX  | -> | MEM  | -> |  WB  |
          +-----+    +-----+    +-----+    +------+    +------+
               |          |          |           |
            IF/ID      ID/EX      EX/MEM      MEM/WB
```

---

## Processor Components

```
rtl/
│
├── ALU
│
├── Register File
│
├── Instruction Memory
│
├── Data Memory
│
├── Main Control Unit
│
├── ALU Control Unit
│
├── Hazard Detection Unit
│
├── Forwarding Unit
│
├── Branch Comparator
│
├── Pipeline Registers
│
└── Top Pipeline Module
```

---

## Supported Hardware Features

### Data Hazards

- EX → EX Forwarding
- MEM → EX Forwarding
- WB → EX Forwarding
- Load-use Hazard Detection
- Pipeline Stall Generation

### Control Hazards

- Branch Decision Logic
- Jump Support
- Pipeline Flush

---

## Project Structure

```
16-bit-Pipelined-MIPS-Processor
│
├── rtl/
│   ├── cpu16_pipeline.v
│   ├── Program_counter.v
│   ├── Instruction_memory.v
│   ├── Register_file.v
│   ├── Top_ALU.v
│   ├── ...
│
├── testbench/
│   └── cpu16_pipeline_tb.v
│
├── docs/
│   ├── architecture.png
│   ├── pipeline.png
│   └── report.pdf
│
├── simulation/
│   ├── program.mem
│   └── waveform.png
│
├── Makefile
├── README.md
└── .gitignore
```

---

## Running Simulation

### Vivado

1. Open Vivado
2. Open the project
3. Set `cpu16_pipeline_tb` as the simulation top
4. Run Behavioral Simulation

---

## Example Test Program

```assembly
ADDI R1, R0, #5
ADDI R2, R0, #3
ADD  R3, R1, R2
SW   R3, 0(R0)
LW   R4, 0(R0)
ADD  R5, R3, R4
```

---

## Future Improvements

- Branch Prediction
- Cache Memory
- Interrupt Handling
- UART Interface
- Performance Counters
- Out-of-Order Execution

---

## Tools Used

- Verilog HDL
- AMD Xilinx Vivado 2025.x
- XSim Simulator

---

## Author

**Robiattam N. Marak**

Electronics and Electrical Communication Engineering

Indian Institute of Technology Kharagpur

---

## License

This project is released under the MIT License.