#pragma once

#include <iostream>

class Stuff {
  public:
    Stuff() = default;

    void do_something();
};

template <typename T> void print_some_stuff(T stuff) {
    std::cout << stuff << std::endl;
}
