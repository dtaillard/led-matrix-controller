# LED Matrix Controller
 
LED matrix controller implementation for the Digilent Basys 3 FPGA board. This project uses the Adafruit LED Matrix Bonnet for Raspberry Pi. Using this controller, an arbitrary image may be displayed on an LED matrix.

For more information on how the LED matrix controller works, please refer to [HOWITWORKS.md](HOWITWORKS.md).

#### Project Structure 

 * `ip/`: Contains Xilinx IP configuration files
 * `rtl/`: Design implementation
 * `tb/`: Testbench implementation
 * `inc/`: Additional files needed to synthesize the design
 * `tools/`: Useful tools for working with the project
 
## Setting up the project

To try this project on a Basys 3 board, you will need Vivado 2021.1 or greater and Python 3. The following instructions have been tested on Ubuntu 20.04.4 LTS.

### Create the Vivado Project

Execute the following script to set up a Vivado project for this repository:

```shell
mkdir led-matrix-vivado
./project_setup.sh led-matrix-vivado
```

This script will create a Vivado project in the `led-matrix-demo` directory and then open it in Vivado.

> You may include the `--nogui` option to prevent the script from starting Vivado.

### Hardware Set Up

To try this project, you will need the Digilent Basys 3 board, Adafruit LED Matrix Bonnet and an Adafruit LED matrix.

Connect jumper wires between the GPIO header on the LED Matrix Bonnet and the Basys 3 Pmod headers as follows.

*Pmod Header JB*
 * JB1 -> GPIO 16
 * JB2 -> GPIO 6
 * JB3 -> GPIO 5
 * JB4 -> GPIO 21
 * JB7 -> GPIO 23
 * JB8 -> GPIO 12
 * JB9 -> GPIO 21
 * JB10 -> GPIO 13

*Pmod Header JC*
 * JC1 -> GPIO 4
 * JC3 -> GPIO 27
 * JC4 -> GPIO 22
 * JB9 -> GPIO 20
 * JB10 -> GPIO 26

## Display your Own Image

Follow these steps if you would like to display an image on your LED matrix other than the provided example image. The script `image2mem.py` has been provided for this purpose. It converts an image to a memory file for the FPGA. 

If not already installed, install [imageio](https://github.com/imageio/imageio):

```bash
pip3 install imageio
```

> If `pip` is not installed, follow the official installation instructions [here](https://pip.pypa.io/en/stable/installation/).

The top Verilog file is configured to initialize block RAM with the file `inc/matrix_data.mem`. Execute the following command to replace this file with a memory file corresponding to your image:

```bash
./tools/image2mem.py /path/to/your/image inc/matrix_data.mem
```

> `image2mem.py` works with any image format supported by imageio.

## Feature roadmap

 - [ ] Double-buffering
 - [ ] Microblaze support
   - [ ] Example program

##  Contact

* Daniel Taillard `<daniel.p.taillard@gmail.com>`
