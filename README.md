## Description

This project is a Universal Verification Methodology (UVM) template designed to help with the verification of digital designs. The template includes various components such as agents, drivers, monitors, and transactions, which are essential for building a UVM testbench. 

## UVM version
UVM 1.1d

## File Descriptions

- **dut/**: Contains the design under test (DUT) files.
  - `dut_top.v`: Top-level module of the DUT.

- **env/**: Contains the environment configuration files.
  - `my_env.sv`: Defines the UVM environment.

- **my_port/**: Contains the UVM agent, driver, monitor, interface, and transaction files.
  - `my_agent.sv`: Defines the UVM agent.
  - `my_driver.sv`: Defines the UVM driver.
  - `my_if.sv`: Defines the virtual interface.
  - `my_monitor.sv`: Defines the UVM monitor.
  - `my_transaction.sv`: Defines the UVM transaction.

- **testcase/**: Contains the test case files.
  - `base_test`: Defines the base test class.
  - `case_example.sv`: Example test case extending base_test.

- **top/**: Contains the top-level testbench files.
  - `flist.f`: File list for compilation.
  - `top_tb.sv`: Top-level testbench module.

- **uvm-1.1d/**: Contains the UVM library files.

- **work/**: Contains the working directory and makefiles.
  - `template/`: Contains the makefile template.

## How to Run

1. Ensure you have a compatible simulator installed (e.g., Questa, VCS, IUS).
2. Copy the template directory to a new case directory (e.g., `cp -r template case1`).
3. Navigate to the new case directory and run the simulation:
   ```sh
   cd case1
   make all
   ```
4. To open the waveform, run:
   ```sh
   make wave
   ```