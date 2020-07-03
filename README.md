# ESP32 Micropython build and tool container
This container will build, deploy and monitor your esp32 micropython firmware. Usage is pretty straightforward and doesn't change compared to the usual micropython way, but it greatly simplifies the installation and setting of the build environement.
The image comes with ESP-IDF v4.0.1, python3 and rshell. The micropython source is not present in this image. It is your micropython folder that will be used for the build.

## Build the image:
```
& git clone 'this repository'
& cd docker_esp32-micropython-build
& docker build -t esp32-micropython-build .
```
It will take a while.

## Run the container:
This command will start the container in interactive mode. You'll end up in a bash shell ready to build.
```
>>> docker run -it -rm \ 
	-v YOUR/MICROPYTHON/PATH:/root/micropython \
	--device=/dev/YOUR/ESP32/TTYUSB \
	esp32-micropython-build
```

## Build, deploy:
Once in the container:
If you just pulled micropython from git, you need to build the mpy cross compiler first:
```
>>> cd micropython/mpy-cross
>>> make mpy-cross
```

Then you can build and deploy the esp32 micropython.
```
>>> cd micropython/ports/esp32
>>> make submodules
>>> make
>>> make erase
>>> make deploy
```

## Start rshell: 
`>>> rshell -p /dev/ttyUSBx -b 115200`


