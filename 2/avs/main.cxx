#include <csignal>
#include <cstdlib>
#include <iostream>
#include <string>

void signal_handler(int signum) {
  std::cout << "SIGNAL HANDLER SIGNUM: " << signum << '\n';
  std::terminate();
}

int main(int argc, char *argv[]) {
  std::cout << "Hello Docker World\n";
  signal(SIGINT, signal_handler);

  sleep(1000000);
}