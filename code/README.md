# ANTLR Docker & Cmake Starter

This is a simple project written in c++ that use [antlr4](https://www.antlr.org/)

## Install C++ & Antlr dev env via Dockerfile

### Install docker

* https://docs.docker.com/install/linux/docker-ce/ubuntu/

Or under proxy:

* https://gist.github.com/blockspacer/893b31e61c88f6899ffd0813111b3e41#file-install_docker-sh

### Run docker

```bash
# build Dockerfile
sudo -E docker build -t cpp-docker-antlr4 .
# Now let’s check if our image has been created. 
sudo -E docker images
cd code
mkdir build
# mounts $PWD to /home/u/cppantlr4 and runs command
sudo -E docker run --rm -v "$PWD":/home/u/cppantlr4 -w /home/u/cppantlr4/build cpp-docker-antlr4 cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_EXPORT_COMPILE_COMMANDS=ON ..
sudo -E docker run --rm -v "$PWD":/home/u/cppantlr4 -w /home/u/cppantlr4/build cpp-docker-antlr4 cmake --build .
./build/src/ex_calc
```

## How to run a terminal in container

```bash
sudo -E docker run --rm -v "$PWD":/home/u/cppantlr4 -w /home/u/cppantlr4/build  -it  -e DISPLAY         -v /tmp/.X11-unix:/tmp/.X11-unix  cpp-docker-antlr4
```

## Hot to run second example

run a terminal in container and install:

```bash
apt-get -y install pkg-config build-essential
apt-get -y install libfftw3-dev libtiff-dev ffmpeg openexr libopenexr-dev imagemagick libgtk2.0-dev
apt-get -y install libpng++-dev libpnglite-dev zlib1g-dbg zlib1g zlib1g-dev pngtools libjpeg8 libjpeg8-dbg libjpeg62 libjpeg62-dev libjpeg-progs libavcodec-dev libavformat-dev libswscale-dev
apt-get -y install libjpeg-turbo8-dev libopencv-dev libjpeg8-dev libjpeg-dev libtiff5-dev
apt-get -y install libblas-dev liblapack-dev
# Xrandr is used to set the size, orientation and/or reflection of the outputs for a screen. It can also set the screen size.
# xrandr in the package named x11-xserver-utils.
apt-get -y install x11-xserver-utils
# http://tech.yipp.ca/linux/xshm-h-no-such-file-or-directory/
apt-get -y install libxext-dev
exit
```

Build code from host machine using cmake and docker (see above)

Bun from host machine folder code/build/ex2_imagegen:

```bash
ls # make sure CURRENT folder contains input.scene and ex2_imagegen
./ex2_imagegen
```

## Output example

```bash
Please enter an expression (for instance (1+2)*(3-4)/(5-6))
input = 4/2-3*3+1-1
Result = -9
Tree = 
             
             4
            ╱
           ÷ 
          ╱ ╲
         ╱   2
        ╱    
       ╱        
      -         3
     ╱ ╲       ╱
    ╱   ╲     x 
   ╱     ╲   ╱ ╲
  ╱       ╲ ╱   3
 ╱         +    
-           ╲ 
 ╲           ╲
  ╲           1
   ╲          
    ╲ 
     ╲
      1
      
```