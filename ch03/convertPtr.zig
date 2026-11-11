const std = @import("std");

const c = @cImport({
    @cInclude("stdio.h");
});

pub fn printC(s: [*:0]const u8) c_int {
    return c.printf("%s\n", s);
}

pub fn main(_: std.process.Init.Minimal) !void {
    const allocator = std.heap.page_allocator;
    const dir = "/usr";
    const util = "ls";
    _ = printC(dir);

    var pathBuf = std.ArrayList(u8).empty;
    defer pathBuf.deinit(allocator);
    try pathBuf.appendSlice(allocator, dir);
    try pathBuf.append(allocator, '/');
    try pathBuf.appendSlice(allocator, util);

    const fullPath = pathBuf.items;
    std.debug.print("Zig slice: {s}\n", .{fullPath});
    // Minimal C-String conversion
    const buffer = try allocator.alloc(u8, fullPath.len + 1);
    defer allocator.free(buffer);
    std.mem.copyForwards(u8, buffer[0..fullPath.len], fullPath);
    buffer[fullPath.len] = 0;
    _ = printC(@as([*:0]const u8, @ptrCast(buffer.ptr)));
}
