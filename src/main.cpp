#include "some_stuff.h"

#include <expected>
#include <flat_map>
#include <iostream>
#include <print>
#include <string>
#include <string_view>

std::expected<int, std::string> parse(std::string_view s) {
    if (s.empty()) {
        return std::unexpected("empty input");
    }
    return 42;
}

struct Counter {
    int value = 0;

    auto& increment(this auto& self) {
        self.value++;
        return self; // chaining works on both & and &&
    }
};

void fn(int* num) {
    std::cout << num;
}

int main([[maybe_unused]] int argc, [[maybe_unused]] char** argv) {
#ifdef NDEBUG
    std::println("release mode");
#else
    std::println("debug mode");
#endif

    auto my_var = "hey!";
    std::print("hello {}\n", my_var);
    std::println("hello {}", "world");

    auto result = parse("hi");
    if (result) {
        std::println("got: {}", *result);
    } else {
        std::cerr << "Got an error!" << '\n';
    }

    auto my_test = Stuff();

    my_test.do_something();

    auto some_int = 42;

    print_some_stuff(some_int);

    std::flat_map<std::string, int> scores;
    scores["alice"] = 10;
    scores["bob"] = 20;

    return 0;
}
