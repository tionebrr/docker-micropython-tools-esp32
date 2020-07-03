# ESP32 Micropython build and tool container
This docker container will build, deploy, and monitor your esp32 micropython firmware. Using this is pretty straightforward and doesn't change a lot compared to using a simple build environment on your host or on a VM. 
The main advantage is that you don't need a python virtual environment and you can have the latest ESP-IDF installed on your machine and still build and use micropython without having to change anything on your main session. It also simplifies the installation and setting of the build environment.
The image comes with ESP-IDF v4.0.1, python3, and rshell.

# Getting the container image:
### Recommended: Pull from docker:
You can simply pull this container image from docker hub by issuing:
```zsh
docker pull tionebrr/micropython-tools-esp32
```
### OR Build the container image from github:
You can also clone this repository in the folder of your choice, then cd into it and build the container image yourself.
```zsh
docker build -t micropython-tools-esp32 .
```
Time to get a coffee or a good green tea, this is going to take a little while.

# Prepare the micropython source:
The micropython source is not present in this image. Your micropython folder will be used "in place" for the build. If you don't already have the micropython sources present locally, you'll need to clone the micropython github repo in a folder of your choice.
```zsh
git clone https://github.com/micropython/micropython
```
You'll also need to add a makefile in the ports/esp32 folder of micropython.
To do this:
```zsh
cd your/path/to/micropython/ports/esp32
nano makefile
```
This makefile works with my board, but you may need to change those values according to your hardware. Please refer to the micropython documentation for more details.
```make
BOARD ?= GENERIC
FLASH_MODE ?= dio
FLASH_SIZE ?= 4MB

include Makefile
```
If you have read the micropython esp32 readme, you may be wondering where are the CROSS_COMPILE, ESPIDF and PORT environment variables. In our case, they are automatically set in the container (by the Dockerfile) during the image building process. This makefile now only contains informations about the target board.

# Run the container:
This command will start the container in interactive mode. You'll end up in the container bash shell, ready to build.
```zsh
docker run -it --rm -v $HOME/micropython/:/root/micropython --device=/dev/ttyUSB0:/dev/ttyUSB0 tionebrr/micropython-tools-esp32 
```
Don't forget to replace the paths with your micropython folder and your ESP32 serial device.
If you want to use this image and rshell to upload custom scripts to your device, you will need to specify a volume in the docker run command. Simply add `-v /path/to/your/µpy/scripts:/root/scripts` before the container image name (`tionebrr/micro...`) like this:
```zsh
docker run -it --rm -v $HOME/micropython/:/root/micropython -v $HOME/micropython-scripts:/root/scripts --device=/dev/ttyUSB0:/dev/ttyUSB0 tionebrr/micropython-tools-esp32 
```
# Build, deploy:
Once in the container shell, you can build and deploy using the same commands you would use with a normal micropython build environment.

If it was not already done in your micropython folder, you need to build the mpy cross compiler first:
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
You can find the output files in `micropython/ports/esp32/build-GENERIC` and these files will stay available even after you exited the container.

# Start rshell: 
After building and deploying, you can interact with the micropython REPL using rshell.
```zsh
rshell -p /dev/ttyUSB0 -b 115200
```

# I want to go home:
Sure, just type `exit`.

Have fun.

