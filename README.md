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

## How to Run
Follow the steps below to build and run the UART design on FPGA using Vivado.

1. Clone the repository
```bash
git clone https://github.com/yemin917/uart.git
cd uart

2. Open Vivado project
- Launch Xilinx Vivado
- Click Open Project
- Select the .xpr file (or create a new project and add source files manually)

If creating a new project:
- Add files from src/
- Add constraint file from constraints/
- Add testbench files from tb/

3. Run Simulation
- Go to Flow Navigator → Run Simulation → Run Behavioral Simulation
- Check UART TX/RX waveform behavior
- Verify start bit, data bits, and stop bit timing

4.Synthesis & Implementation
- Click Run Synthesis
- Click Run Implementation
- Fix timing or constraint issues if any appear

5. Generate Bitstream
Click Generate Bitstream

6. Program FPGA
- Connect Zybo Z7-20 via USB
- Open Hardware Manager
- Click Open Target → Auto Connect
- Program the device with generated bitstream

7️. (Optional) Terminal Test
- Open PuTTY
- Select Serial
- Set baud rate (e.g., 9600)
- Connect and test UART communication

⚠️ Notes
- Make sure clock frequency matches baud rate calculation.
- Check pin assignments in .xdc.
- Verify RX/TX pin mapping on Zybo board.
- Baud rate mismatch may cause garbled data.

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
