const std = @import("std");

pub fn main(init: std.process.Init) !void {
    // Allocate buffers for the streams
    var out_buff: [4096]u8 = undefined;
    var err_buff: [4096]u8 = undefined;

    // Initialize buffered writers
    var stdout_impl = std.Io.File.stdout().writer(init.io, &out_buff);
    var stderr_impl = std.Io.File.stderr().writer(init.io, &err_buff);

    // Get the generic writer interfaces
    const stdout = &stdout_impl.interface;
    const stderr = &stderr_impl.interface;

    var i: usize = 0;
    while (i < 5) : (i += 1) {
        try stdout.print("OUT: This is stdout message #{d}\n", .{i});
        try stderr.print("ERR: This is stderr message #{d}\n", .{i});
    }

    // Flush
    try stdout.flush();
    try stderr.flush();
}
