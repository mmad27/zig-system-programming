const std = @import("std");

pub fn main(init: std.process.Init) !void {
    var buffer: [4096]u8 = undefined;
    var stdout_impl = std.Io.File.stdout().writer(init.io, &buffer);
    const stdout = &stdout_impl.interface;

    try stdout.print("Hello {s}\n", .{"Buffered World"});
    try stdout.print("Writing number: {d}\n", .{42});
    try stdout.flush();
}
