# UART Communication System on FPGA (Verilog, Vivado)
This project implements a UART (Universal Asynchronous Receiver/Transmitter) communication system on an FPGA using Verilog HDL.
The goal is to understand asynchronous serial communication by designing, simulating, and deploying a UART TX/RX module on a Zybo Z7-20 board using Vivado.

## Project Overview
UART is a widely used asynchronous communication protocol between digital devices.
In this project, a UART transmitter and receiver were designed at the RTL level and verified through simulation before being implemented on FPGA hardware.

The project covers the full FPGA development flow:
- RTL design
- Synthesis & implementation
- Testbench simulation
- Bitstream generation
- FPGA download and hardware testing

## Development Environment
- Language: Verilog HDL
- Tool: Xilinx Vivado
- Board: Zybo Z7-20
- Protocol: UART (Asynchronous Serial Communication)
- Terminal Tool: PuTTY

## Implemented Features
- UART Transmitter (TX)
- UART Receiver (RX)
- Baud rate generator
- Start / Data / Stop bit handling
- RTL-level design and synthesis
- Testbench waveform verification
- FPGA bitstream generation and download

## Verification & Simulation
A testbench was created to verify UART transmission and reception.
Waveforms were analyzed to confirm correct timing of:
- Start bit detection
- Data bit sampling
- Stop bit generation
This step ensured correct UART behavior before hardware deployment.

## Hardware Implementation
After simulation, the design was synthesized and implemented in Vivado.
The generated bitstream was downloaded to the Zybo Z7-20 board.

Although full communication with PuTTY was not finalized, the project successfully went through the entire FPGA development flow and strengthened understanding of real hardware deployment.

## Future Improvements
- Complete PuTTY terminal communication
- Add loopback test
- Support variable baud rates
- Improve error handling (parity, framing error)
