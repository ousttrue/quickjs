const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const flags: []const []const u8 = &.{
        "-D_GNU_SOURCE",
        "-DCONFIG_VERSION=\"2024-02-14\"",
        "-DCONFIG_BIGNUM",
        "-DHAVE_CLOSEFROM",
        // "-DCONFIG_CHECK_JSVALUE",
        "-fwrapv",
    };
    const lib = b.addStaticLibrary(.{
        .target = target,
        .optimize = optimize,
        .name = "lib",
        .link_libc = true,
    });
    lib.addCSourceFiles(.{
        .files = &.{
            "quickjs.c",
            "libregexp.c",
            "libunicode.c",
            "cutils.c",
            "quickjs-libc.c",
            "libbf.c",
        },
        .flags = flags,
    });

    // gcc -g -o qjsc .obj/qjsc.o .obj/quickjs.o .obj/libregexp.o .obj/libunicode.o .obj/cutils.o .obj/quickjs-libc.o .obj/libbf.o -lm -ldl -lpthread ./qjsc -c -o repl.c -m repl.js
    const qjsc = b.addExecutable(.{
        .target = target,
        .optimize = optimize,
        .name = "qjsc",
        .link_libc = true,
    });
    const install_qjsc = b.addInstallArtifact(qjsc, .{});
    b.getInstallStep().dependOn(&install_qjsc.step);
    qjsc.entry = .disabled;
    qjsc.addCSourceFile(.{
        .file = b.path("qjsc.c"),
        .flags = flags,
    });
    qjsc.linkLibrary(lib);

    b.step("qjsc", "install qjsc").dependOn(&install_qjsc.step);

    // ./qjsc -c -o repl.c -m repl.js
    const gen_repl = b.addRunArtifact(qjsc);
    gen_repl.addArgs(&.{ "-c", "-m", "repl.js", "-o" });
    const repl_c = gen_repl.addOutputFileArg("repl.c");

    // ./qjsc -fbignum -c -o qjscalc.c qjscalc.js
    const gen_qjscalc = b.addRunArtifact(qjsc);
    gen_qjscalc.addArgs(&.{ "-fbignum", "-c", "qjscalc.js", "-o" });
    const qjscalc_c = gen_qjscalc.addOutputFileArg("qjscalc.c");

    // gcc -g -rdynamic -o qjs .obj/qjs.o .obj/repl.o .obj/quickjs.o .obj/libregexp.o .obj/libunicode.o .obj/cutils.o .obj/quickjs-libc.o .obj/libbf.o .obj/qjscalc.o -lm -ldl -lpthread
    const qjs = b.addExecutable(.{
        .target = target,
        .optimize = optimize,
        .name = "qjs",
        .link_libc = true,
    });
    qjs.addCSourceFile(.{
        .file = repl_c,
        .flags = flags,
    });
    qjs.addCSourceFile(.{
        .file = qjscalc_c,
        .flags = flags,
    });
    b.installArtifact(qjs);
    qjs.entry = .disabled;
    qjs.addCSourceFiles(.{
        .files = &.{
            "qjs.c",
        },
        .flags = flags,
    });
    qjs.linkLibrary(lib);
}
