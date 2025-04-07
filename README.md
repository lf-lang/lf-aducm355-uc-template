# reactor-uc ADuCM355 template

* [ADuCM355 Product Page](https://www.analog.com/en/products/aducm355.html)
* [ADuCM355 Datasheet](https://www.analog.com/media/en/technical-documentation/data-sheets/ADuCM355.pdf)
* [ADuCM355 FAQ](https://ez.analog.com/analog-microcontrollers/precision-microcontrollers/w/documents/14004/aducm355-faq)
* [ADuCM355 Hardware Reference Manual](https://www.analog.com/media/en/technical-documentation/user-guides/ADuCM355-Hardware-Reference-Manual-UG-1262.pdf)
* [EVAL-ADuCM355](https://www.analog.com/en/design-center/evaluation-hardware-and-software/evaluation-boards-kits/EVAL-ADuCM355.html)

---

This is a project template for developing LF applications targeting the Analog Devices ADuCM355 Precision Analog Microcontroller. It shows how to integrate the LF toolchain into the Keil uVision IDE. Keil is used to first run the Lingua Franca Compiler, before compiling the generated sources and downloading the binary onto the microcontroller.

## Prerequisites
* Windows host system, e.g Windows 11
* EVAL-ADuCM355 evaluation board with Segger mIDAS-Link debug probe
* Putty (or other serial terminal)

## Getting Started

Clone this repository:

```sh
git clone --recursive https://github.com/lf-lang/lf-aducm355-uc-template/
```

### Keil uVision
This template is based on integrating the LF toolchain into Keil uVision. Please download and install Keil uVision 5. At the time of writing, the ADuCM355 libraries from Analog Devices depends on ARM CMSIS Packs v5.9.0 and Arm C Compiler v5.06. **These dependencies are not available in Keil uVision 5**. You must manually downgrade ARM CMSIS Packs via the CMSIS Pack Manager found in Keil uVision 5. To install Arm Compiler v5.06 with Keil uVision 5, please follow the documentation here: https://developer.arm.com/documentation/ka005073/latest

For more information on this issue, see: https://github.com/analogdevicesinc/aducm355-examples/issues/11

To verify that you have correctly installed Keil uVision, open the example Keil uVision project found in [M355_GPIO.uvprojx](HelloWorld/M355_GPIO/ARM/M355_GPIO.uvprojx), Rebuild and Download the program onto a connected ADuCM355 eval board using the provided JLink. See [README](HelloWorld/README.md) for more info

### Lingua Franca
The Lingua Franca Compiler requires Java 17. Install a JDK of choice, e.g. OpenJDK from [here](https://learn.microsoft.com/en-us/java/openjdk/download#openjdk-17).

Make sure that the `JAVA_HOME` environment variable is pointing to the installation and that the `bin` directory of the installation is on the system PATH. Verify with `java --version`. 

The fetch `reactor-uc` the Lingua Franca runtime for embedded systems. 

```sh
git clone --recursive https://github.com/lf-lang/reactor-uc/
```

Define a system environmental variable `REACTOR_UC_PATH` that points to the location of `reactor-uc`. 

Verify that the Lingua Franca toolchain and its dependencies are correctly installed with:

```sh
reactor-uc/lfc/bin/lfc-dev.ps1 --version
```

This will (re)build the Lingua Franca compiler and execute it.

### Blinky
Now that we have correctly installed an IDE, Compiler, and the Lingua Franca toolchain, we are ready to compile and flash our first LF application.

Open the Blinky project in Keil uVision. Inspect [Blinky.lf](Blinky/src/Blinky.lf) to see what the program does. Press the `Rebuild` button in Keil, this will take a little longer than usual because it first invokes the build script in [build.ps1](Blinky/build.ps1) 

This will generate source files for Blinky.lf into a a folder called `src-gen`, the generated sources are already added to the Keil project. After running the build script, Keil will build all the sources and produce an binary. Download it onto a connected board and watch LED DS2 blink.


## Further topics

### Adding more LF sources or reactors
Currently, we must add the generated sources to the Keil project manually. This means that if you add more reactors to your program, you must manually configure the Keil project to include the generated sources in the build. Each reactor declaration which is used, will result in a source file generated to `src-gen/$PROGRAM_NAME/$LF_FILE_NAME/ReactorName`. If you add more LF sources you have to also add the generated sources accordingly.

### Logging
To change the log level, change the compile definition `LF_LOG_LEVEL_ALL` which is defined by selection `Options for target`->`C/C++`.

### Low-power deep sleep
A special compile definition `LF_BUSY_WAIT` is provided to make the runtime do busy-waiting, instead of low-power hibernation between events. For deploying a system, the default low-power hibernation should be used and the `LF_BUSY_WAIT` compile definition should be removed from the Keil project setting.

### Creating a new project
Create a new project by copying the Blinky project. 

### Decouple Keil uVision and LFC
Another alternative is to decouple the Keil uVision IDE and the Lingua Franca Compiler. Go to `Options for target`->`User` and remove the invokation of the `build.ps1` script. Now you must manually call `lfc` either from the terminal, or through `build.ps1` every time you modify the LF sources and then press Build or Rebuild in Keil to compile the project.

## Troubleshooting

### JLink - Cortex-M error: No Cortex-M SW Device Found
This happens when the MCU is in deep-sleep when we try to Download a new binary to it. For the ADuCM355, put it into BOOT mode by holding down Button S3 while pressing Button S1.