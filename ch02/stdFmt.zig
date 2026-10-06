const std = @import("std");

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    // page_allocator is used here for brevity before the full
    // allocator discussion in the next section. In production
    // code and in the rest of this book, prefer init.gpa.
    const allocator = std.heap.page_allocator;
    const stdout = std.Io.File.stdout();
    std.debug.print("Debug: program started.\n", .{});

    const number = 255;
    const msg_nums = try std.fmt.allocPrint(
        allocator, 
        "Decimal: {d}, Hex: {x}, Binary: {b}, Octal: {o}\n", 
        .{ number, number, number, number }
    );
    defer allocator.free(msg_nums);
    try stdout.writeStreamingAll(io, msg_nums);
}

const user = struct {
    name: []const u8,
    id: u32,
};