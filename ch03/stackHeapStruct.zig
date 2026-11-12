const std = @import("std");

const Person = struct {
    name: []const u8,
    age: u8,
};

pub fn main(init: std.process.Init) !void {
    const allocator = init.gpa;

    const stack = Person{
        .name = "Malith",
        .age = 32,
    };

    std.debug.print("Stack: N = {s}, A = {}\n", .{ stack.name, stack.age });

    const heap_ptr = try allocator.create(Person);
    defer allocator.destroy(heap_ptr);

    heap_ptr.* = Person{
        .name = "Jithmi",
        .age = 33,
    };

    std.debug.print("Heap: N = {s}, A = {}\n", .{ heap_ptr.name, heap_ptr.age });
}
