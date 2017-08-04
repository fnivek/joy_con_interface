# Joy Con Interface
This repository will implement a bluetooth interface for the Nintendo Switch Joy Con controllers.
A python script will be devoloped first to understand the protocol.
Then a C interface will be designed for use on an embeded system.

## Dependencies
Below are all dependencies of this project.
Primary dependencies are thoes that are required for the code to function.
Secondary dependencies are thoes that are not necisary such as thoes used in the install script.

### Primary:
* pyBluez
  * libbluetooth-dev
  
### Secondary:
* wget
* pip

## Install
An install script is provided in the root directory.
It installs all components needed to compile the code but does not install the binaries or scripts onto your machine.

## Resources
This is a list of resources I used to devolop this project:
* [Nintendo Switch Reverse Engineering](https://github.com/dekuNukem/Nintendo_Switch_Reverse_Engineering)
