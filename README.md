# ESP32 Micropython build and tool container
This container will build, deploy and monitor your esp32 micropython firmware. Usage is pretty straightforward and doesn't change compared to the usual micropython way, but it greatly simplifies the installation and setting of the build environement.
The image comes with ESP-IDF v4.0.1, python3 and rshell. The micropython source is not present in this image. It is your micropython folder that will be used for the build.

## Build the image:
```
>>> git clone https://github.com/PureBasic/docker_esp32-micropython-build
>>> cd docker_esp32-micropython-build
>>> docker build -t esp32-micropython-build .
```
It will take a while.

## Pull the micropython source:
If you don't already have the micropython source present locally, you'll need to clone them from git.
```
>>> cd
>>> git clone https://github.com/micropython/micropython
```

## Run the container:
This command will start the container in interactive mode. You'll end up in the container bash shell, ready to build.
```
>>> docker run -it --rm \ 
	-v YOUR/MICROPYTHON/PATH:/root/micropython \
	--device=/dev/YOUR/ESP32/TTYUSB:/dev/ttyUSB0 \
	esp32-micropython-build
```
Don't forget to replace the paths with your micropython folder and your ESP32 serial devive.

## Build, deploy:
Once in the container, you can build and deploy the same way it is done with a normal micropython build environement:
If it was not already done, you need to build the mpy cross compiler first:
```
>>> cd micropython/mpy-cross
>>> make mpy-cross
```

Then you can build and deploy micropython.
```
>>> cd micropython/ports/esp32
>>> make submodules
>>> make
>>> make erase
>>> make deploy
```

## Start rshell: 
You can then interact with the micropython REPL using rshell.
`>>> rshell -p /dev/ttyUSB0 -b 115200`


