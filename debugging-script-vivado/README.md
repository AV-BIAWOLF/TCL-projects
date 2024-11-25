# Vivado TCL Script for Debugging

This repository contains a TCL script for use in Vivado that automates the process of creating an ILA debug core and connecting signals for analysis. The script helps engineers and developers simplify the debugging process of FPGA projects.

I wrote this code while watching a [FPGA Systems channel](https://www.youtube.com/@FPGASystems) streams ([stream #1](https://www.youtube.com/watch?v=EyPCXczw2OY), [stream #2](https://www.youtube.com/watch?v=gyCjjfiSfrQ)). So it is not entirely my intellectual property. But I have added a little bit to the code to make it work correctly. 

## Script Description

The script performs the following actions:
1. **find_clock**: Finds all clock signals for the specified cell and returns the first one found, or reports if there are more than one.
2. **ldelete**: Deletes the specified element from a list.
3. **debug**: 
   - Saves the current project constraints.
   - Retrieves all pins for the specified object.
   - Creates an ILA debug core and connects clock signals to it.
   - Removes pins from the list that are associated with global clock signals.
   - Outputs the number of pins before and after the removal of clock signals.
   - Initializes variables for width and probe number.
   - Iterates over the remaining pins, checks their connections, and connects them to the ILA debug ports.

## Usage

This script is useful for debugging projects in Vivado, easing the process of connecting signals and excluding global clock signals. It automates the creation of ILA debug cores and pin connections, allowing developers to focus on analyzing and debugging signals without the need to manually perform routine tasks.

1. To choose block for debugging. ![alt text](https://github.com/AV-BIAWOLF/TCL-projects/blob/main/debugging-script-vivado/img/pic1.png)
2. To write command for procedure execution.
3. To get resulat: ILA debug core and marked signals. ![alt text](https://github.com/AV-BIAWOLF/TCL-projects/blob/main/debugging-script-vivado/img/pic2.png) ![alt text] (https://github.com/AV-BIAWOLF/TCL-projects/blob/main/debugging-script-vivado/img/pic3.png)

## Acknowledgements

This script was written thanks to a stream and a channel on YouTube. I made some additional modifications at the end to ensure it works without errors.
