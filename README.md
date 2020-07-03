# ESP32 Micropython build and tool container
This docker container will build, deploy and monitor your esp32 micropython firmware. Using this is pretty straightforward and doesn't change a lot compared to using a simple build environement on your host on a VM. The main advantage is that you don't need a python virtual environement and you can have the latest ESP-IDF installed on your machine but still build and use micropython without having to change anything on your main session. It also simplifies the installation and setting of the build environement.
The image comes with ESP-IDF v4.0.1, python3 and rshell.

# Getting the container image:
### Recommended: Pull from docker:
You can simply pull this container image from docker hub by issuing:
```zsh
git@github.com:tionebrr/docker-micropython-tools-esp32.git
```
### OR Build the container image from github:
You can also clone this repository in the folder of your choice, then cd into it and build the conatiner image yourself.
```zsh
docker build -t micropython-tools-esp32 .
```
This will take some time. (Enjoy a coffee or a green tea =P)

# Pull the micropython source:
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
Note that CROSS_COMPILE, ESPIDF and PORT are set in the Dockerfile.

## Run the container:
This command will start the container in interactive mode. You'll end up in the container bash shell, ready to build.
```zsh
docker run -it --rm \ 
	-v your/path/to/micropython:/root/micropython \
	--device=/dev/ttyUSBx:/dev/ttyUSB0 \
	micropython-tools-esp32
```
Don't forget to replace the paths with your micropython folder and your ESP32 serial device.

## Build, deploy:
Once in the container, you can build and deploy the same way it is done with a normal micropython build environement:
If it was not already done, you need to build the mpy cross compiler first (and it may not hurt to actually rebuild it):
```zsh
cd micropython/mpy-cross
make mpy-cross
```

You can now build and deploy micropython to your ESP32.
```zsh
cd ../ports/esp32
make submodules
make
make erase
make deploy
```

## Start rshell: 
After building and deploying, you can interact with the micropython REPL using rshell.
```zsh
rshell -p /dev/ttyUSB0 -b 115200
```


