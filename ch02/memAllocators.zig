const std = @import("std");

fn createNumbers(allocator: std.mem.Allocator) ![]u32 {
    const slice = try allocator.alloc(u32, 4);
    for (slice, 0..) |*item, i| {
        item.* = @intCast(i * 10);
    }
    return slice;
}

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    const stdout_file = std.Io.File.stdout();
    var buf: [4096]u8 = undefined;
    var stdout_impl = stdout_file.writer(io, &buf);
    const stdout = &stdout_impl.interface;

    defer stdout.flush() catch {};
}