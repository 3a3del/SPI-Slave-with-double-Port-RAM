# Project Title: SPI to Dual-Port RAM Interface
# Overview
This project implements a Verilog-based SPI (Serial Peripheral Interface) to Dual-Port RAM (Random Access Memory) interface. The design integrates an SPI communication module with a dual-port RAM, allowing data to be transmitted and received via SPI while being stored or retrieved from the RAM module. The project is encapsulated within a module named spi_ram_wrapper, which serves as the top-level entity coordinating the SPI communication and RAM access.

# Features
SPI Protocol Support: The SPI module is configurable for different clock polarity (cpol) and clock phase (cpha) settings, allowing it to interface with a variety of SPI-compatible devices.
Dual-Port RAM Access: The project includes a dual-port RAM module capable of simultaneous read and write operations on two separate ports, facilitating fast data access.
Configurable Parameters:
N: Number of SPI slave devices supported (default is 2).
MEM_DEPTH: Depth of the RAM, determining the number of addressable memory locations.
ADDR_SIZE: Size of the address bus, defining the memory addressing range.
Flexible Reset Control: Separate reset signals for both ports of the RAM allow independent control of memory initialization.
Clock Generation: The project includes clock generation suitable for driving the SPI interface and RAM operations.
# Project Structure
spi_ram_wrapper.v: The top-level Verilog module that integrates the SPI and RAM modules.
spi.v: The SPI communication module handling the SPI protocol's data transmission and reception.
RAM.v: The dual-port RAM module, capable of handling simultaneous data transactions on two separate ports.
tb_spi_ram_wrapper.v: The testbench module designed to validate the functionality of the spi_ram_wrapper. It includes various test cases to ensure reliable data communication and storage.
# How It Works
1. SPI Communication:

The SPI module receives data to be sent (spi_din) and transmits it over the SPI bus using the spi_mosi signal.
Incoming data is captured on the spi_miso line, and a chip select signal (spi_cs) is generated to control which SPI slave device is active.
2. Dual-Port RAM Access:

The RAM module allows simultaneous read and write operations on two ports (A and B), controlled by signals from the SPI module.
Data received via SPI can be written into the RAM, and data stored in RAM can be transmitted back via SPI.
3. Testbench:

The tb_spi_ram_wrapper module simulates various test scenarios, including transmitting and receiving data to and from different SPI slave devices and verifying the correct operation of the RAM module.
Getting Started
# Requirements:

A Verilog simulation environment (e.g., ModelSim, Vivado, or any compatible Verilog simulator).
A basic understanding of SPI protocol and Verilog HDL.
Running the Simulation:

Open the project in your Verilog simulation tool.
Load the tb_spi_ram_wrapper.v testbench.
Run the simulation to observe the behavior of the SPI to RAM interface.
# Customization:

Modify parameters such as N, cpol, cpha, MEM_DEPTH, and ADDR_SIZE in the spi_ram_wrapper module to fit your specific needs.
Customize the testbench to include additional test cases or modify existing ones to suit different SPI devices.
# Future Improvements
Expand SPI Slave Support: Increase the number of supported SPI slave devices by adjusting the parameter N.
Advanced Error Handling: Implement robust error detection and handling mechanisms within the SPI communication process.
Optimized Memory Management: Introduce memory management techniques to handle larger RAM sizes and more complex data transactions.
# Conclusion
This project serves as a foundational example of integrating SPI communication with memory storage in hardware design. It can be used as a starting point for more complex embedded systems requiring efficient data exchange between a processor and memory modules via SPI.
