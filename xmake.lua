add_rules("mode.debug", "mode.release", "mode.asan")
add_rules("plugin.compile_commands.autoupdate", { outputdir = "." })

set_project("cpp23-template")
set_version("0.1.0")

target("cpp23-template")
set_kind("binary")
set_languages("c++23")
set_targetdir("bin")
set_toolchains("clang")

on_load(function(target)
    -- mode flags
    if is_mode("debug") then
        target:add("defines", "DEBUG")
        target:add("cxxflags", "-g", "-O0", "-fno-inline", { force = true })
    elseif is_mode("release") then
        target:add("defines", "NDEBUG")
        target:add("cxxflags", "-O3", { force = true })
    elseif is_mode("asan") then
        target:add("defines", "DEBUG")
        target:add(
            "cxxflags",
            "-g",
            "-O0",
            "-fno-inline",
            "-fsanitize=address,undefined",
            "-fno-omit-frame-pointer",
            { force = true }
        )
        target:add("ldflags", "-fsanitize=address,undefined", { force = true })
    end

    -- shared warnings
    target:add("cxxflags", "-Wall", "-Wextra", "-Wpedantic", "-Wshadow", { force = true })

    -- platform-specific
    if is_plat("macosx") then
        local brew = os.arch() == "arm64" and "/opt/homebrew/opt/llvm" or "/usr/local/opt/llvm"
        local sdk = "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk"

        target:add(
            "cxxflags",
            "-stdlib=libc++",
            "-isysroot" .. sdk,
            "-isystem" .. brew .. "/include/c++/v1",
            { force = true }
        )
        target:add(
            "ldflags",
            "-stdlib=libc++",
            "-L" .. brew .. "/lib/c++",
            "-Wl,-rpath," .. brew .. "/lib/c++",
            { force = true }
        )
    elseif is_plat("linux") then
        target:add("cxxflags", "-stdlib=libc++", { force = true })
        target:add("ldflags", "-stdlib=libc++", "-lc++abi", { force = true })
    elseif is_plat("windows") then
        -- clang on windows uses MSVC STL by default, don't force libc++
        target:add("cxxflags", "-Wall", "-Wextra", { force = true })
    end
end)

add_files("src/*.cpp")

-- tasks

task("debug")
set_menu({
    usage = "xmake debug [--build]",
    description = "configure, build and run in debug mode",
    options = {
        { "b", "build", "k", nil, "rebuild before running" },
    },
})
on_run(function()
    import("core.base.option")
    os.exec("xmake config -m debug")
    if option.get("build") then
        os.exec("xmake")
    end
    os.exec("xmake run")
end)

task("release")
set_menu({
    usage = "xmake release [--build]",
    description = "configure, build and run in release mode",
    options = {
        { "b", "build", "k", nil, "rebuild before running" },
    },
})
on_run(function()
    import("core.base.option")
    os.exec("xmake config -m release")
    if option.get("build") then
        os.exec("xmake")
    end
    os.exec("xmake run")
end)

task("clear")
set_menu({
    usage = "xmake clear [--cc]",
    description = "clear build output and config cache",
    options = {
        { "c", "cc", "k", nil, "also remove compile_commands.json" },
    },
})
on_run(function()
    import("core.base.option")
    local dirs = {
        os.projectdir() .. "/.xmake",
        os.projectdir() .. "/build",
        os.projectdir() .. "/.cache",
        os.projectdir() .. "/bin",
    }
    for _, dir in ipairs(dirs) do
        if is_host("windows") then
            os.run("rmdir /s /q " .. dir)
        else
            os.run("rm -rf " .. dir)
        end
    end
    if option.get("cc") then
        os.run("rm -f " .. os.projectdir() .. "/compile_commands.json")
    end
    print("Finished clearing.")
end)

task("san")
set_menu({ usage = "xmake san", description = "build and run with sanitizers" })
on_run(function()
    os.exec(
        "xmake config -m debug --policies=build.sanitizer.address:y,build.sanitizer.undefined:y"
    )
    os.exec("xmake")
    os.exec("xmake run")
end)
