# C++23 Template

An opinionated C++23 project template using [xmake](https://xmake.io) with a batteries-included developer experience — clangd, clang-tidy, clang-format and custom tasks out of the box.

## Requirements

- [xmake](https://xmake.io/guide/quick-start.html)
- [LLVM](https://llvm.org/) — via Homebrew on macOS (`brew install llvm`), via apt on Linux (`sudo apt install clang libc++-dev libc++abi-dev`)

## Getting started

```bash
git clone <repo>
cd cpp23-template
xmake config -m release
xmake
xmake run
```

## Tasks

| task | description |
|---|---|
| `xmake debug` | configure, build and run in debug mode |
| `xmake release` | configure, build and run in release mode |
| `xmake san` | build and run with address and UB sanitizers |
| `xmake clear` | wipe `build/`, `bin/`, `.xmake/` and `.cache/` |

All tasks support `--help`. `xmake clear` accepts `-c` / `--cc` to also remove `compile_commands.json`.

## Project structure

```
.
├── .github/workflows/ci.yml  # CI for macOS, Linux, Windows
├── src/
│   └── main.cpp
├── .clangd              # clangd diagnostics config
├── .clang-format        # formatting rules
├── .clang-tidy          # linting and naming rules
├── .luarc.json          # Lua LSP config for xmake globals
└── xmake.lua            # build config and tasks
```

## Code style

Naming follows Rust conventions:

| construct | convention |
|---|---|
| types, structs, enums | `PascalCase` |
| functions, variables, parameters | `snake_case` |
| constants, macros | `UPPER_SNAKE_CASE` |
| private members | `snake_case_` (trailing underscore) |

Pointer and reference alignment is left: `int* x`, `int& y`.

## Debug macros

```cpp
#ifdef NDEBUG
    std::println("release build");
#else
    std::println("debug build");
#endif
```

## Editor setup (Zed)

Add to your Zed `settings.json`:

```json
{
  "lsp": {
    "clangd": {
      "binary": {
        "path": "/opt/homebrew/opt/llvm/bin/clangd",
        "arguments": [
          "--background-index",
          "--clang-tidy",
          "--completion-style=detailed",
          "--all-scopes-completion",
          "--header-insertion=iwyu",
          "--function-arg-placeholders=1",
          "--pch-storage=memory",
          "--enable-config",
          "-j=10"
        ]
      }
    }
  }
}
```

## CI

GitHub Actions runs on push and pull request across macOS, Linux and Windows. See [`.github/workflows/ci.yml`](.github/workflows/ci.yml).

## Resources

- [xmake docs](https://xmake.io/guide/quick-start.html)
- [clangd config reference](https://clangd.llvm.org/config.html)
- [C++23 compiler support](https://en.cppreference.com/w/cpp/compiler_support/23)
