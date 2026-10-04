const std = @import("std");

pub fn main(init: std.process.Init) !void {
    const args = try init.minimal.args.toSlice(init.arena.allocator());

    if (args.len < 2) {
        std.debug.print("Usage: {s} <file>\n", .{args[0]});
        return;
    }

    const filePath = args[1];

    // Open or create the file without truncating existing contents.
    const file = try std.Io.Dir.cwd().createFile(init.io, filePath, .{ .read = true, .truncate = false });
    defer file.close(init.io);

    // Get the current file size and write at the end (append)
    const stat = try file.stat(init.io);
    try file.writePositionalAll(init.io, "Appended line\n", stat.size);
}
