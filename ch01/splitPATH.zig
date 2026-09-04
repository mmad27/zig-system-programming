const std = @import("std");

pub fn main(init: std.process.Init) !void {
    // Get the PATH env variable from the environ map
    const pathEnv = init.environ_map.get("PATH") orelse {
        std.debug.print("Error: PATH variable not found\n", .{});
        return;
    };

    //Splits PATH into individual directories
    var dirs = std.mem.splitScalar(u8, pathEnv, ':');
    while (dirs.next()) |dir| {
        std.debug.print("Directory: {s}\n", .{dir});
    }
}
