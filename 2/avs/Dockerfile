FROM gcc:latest

COPY . /avs

WORKDIR /avs

RUN apt-get update && apt-get install -y gcc g++
RUN g++ --std=c++20 -o main main.cxx

STOPSIGNAL SIGINT

ENTRYPOINT ["./main"]