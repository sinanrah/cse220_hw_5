FROM mcr.microsoft.com/devcontainers/java
RUN sudo apt update && sudo apt upgrade -y
RUN sudo apt install -y gcc gdb cmake ninja-build
RUN git clone https://github.com/google/googletest.git -b v1.14.0 &&\
  cd googletest && mkdir build && cd build &&\
  cmake .. && make && sudo make install &&\
  cd ~/ && rm -fr googletest
