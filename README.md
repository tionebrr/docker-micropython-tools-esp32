# ESP32 Micropython build and tool container
This container will build, deploy and monitor your esp32 micropython firmware. Usage is pretty straightforward and doesn't change compared to the usual micropython way, but it greatly simplifies the installation and setting of the build environement.
The image comes with ESP-IDF v4.0.1, python3 and rshell.

# Getting the container image:
## Pull from docker:
TODO
## Build the container image from github:
Clone this repository in the folder of your choice, then cd into it and issue.
```zsh
docker build -t micropython-tools-esp32 .
```
This will take some time. You can use this as an excuse to make yourself a good coffee, or even better: a green tea. Enjoy.

## Pull the micropython source:
The micropython source is not present in this image. It is your micropython folder that will be used for the build. If you don't already have the micropython sources present locally, you'll need to clone the micropython github repo in the folder of your choice.
```zsh
git clone https://github.com/micropython/micropython
```
You'll also need to add a makefile in the ports/esp32 folder of micropython.
To do this:
```zsh
cd your/path/to/micropython/ports/esp32
nano makefile
```
This makefile works with my board, but you may change those values according to your hardware. Please refer to the micropython documentation for more details:
```make
BOARD ?= GENERIC
FLASH_MODE ?= dio
FLASH_SIZE ?= 4MB

include Makefile
```
Note that CROSS_COMPILE, ESPIDF and PORT are already set in the Dockerfile.

## Run the container:
This command will start the container in interactive mode. You'll end up in the container bash shell, ready to build.
```zsh
docker run -it --rm \ 
	-v your/path/to/micropython:/root/micropython \
	--device=/dev/YOUR/ESP32/TTYUSB:/dev/ttyUSB0 \
	micropython-tools-esp32
```
Don't forget to replace the paths with your micropython folder and your ESP32 serial devive.

## Build, deploy:
Once in the container, you can build and deploy the same way it is done with a normal micropython build environement:
If it was not already done, you need to build the mpy cross compiler first:
```zsh
cd micropython/mpy-cross
make mpy-cross
```

Then you can build and deploy micropython.
```zsh
cd ../ports/esp32
make submodules
make
make erase
make deploy
```

## Start rshell: 
You can then interact with the micropython REPL using rshell.
```zsh
rshell -p /dev/ttyUSB0 -b 115200
```


