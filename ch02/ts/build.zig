const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // fetch tsdist package
    const tsdist_dep = b.dependency("tsdist", .{
        .target = target,
        .optimize = optimize,
    });

    // create root module for the executable
    const exe_mod = b.createModule(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    // add tsdist as import (matches root module name in tsdist-zigL: "distances")
    exe_mod.addImport("distances", tsdist_dep.module("distances"));

    // build the executable
    const exe = b.addExecutable(.{
        .name = "ts",
        .root_module = exe_mod,
    });
    b.installArtifact(exe);

    // run command
    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
