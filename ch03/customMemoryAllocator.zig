const std = @import("std");
const bitsInByte = 8;

pub const TrackingAllocator = struct {
    allocator: std.mem.Allocator,
    allocBytes: usize,

    // Initialize the Tracking allocator
    pub fn init(allocator: std.mem.Allocator) TrackingAllocator {
        return TrackingAllocator {
            .allocator = allocator,
            .allocBytes = 0,
        };
    }

    pub fn alloc(
        self: *TrackingAllocator,
        comptime T: type,
        n: usize,
    ) ![]T {
        const initialValue: usize = self.allocBytes;
        const slice: []T = try self.allocator.alloc(T, n);
        self.allocBytes += @sizeOf(T) * n;
        const AFTER = self.allocBytes - initialValue;
        std.debug.print(
            "Allocated: {}. Current: {}\n", 
            .{ AFTER, self.allocBytes }
        );
        return slice;
    }

    pub fn free(
        self: *TrackingAllocator,
        comptime T: type,
        slice: []T,
    ) void {
        if (slice.len > 0) {
            const initialValue: usize = self.allocBytes;
            self.allocBytes -= @sizeOf(T) * slice.len;
            self.allocator.free(slice);
            const FREED: usize = initialValue - self.allocBytes;
            std.debug.print(
                "{} freed. Current: {}\n", 
                .{ FREED, self.allocBytes }
            );
        }
    }

    pub fn create(
        self: *TrackingAllocator,
        comptime T: type,
    ) !T {
        const initialValue: usize = self.allocBytes;
        const memory: *T = try self.allocator.create(T);
        self.allocBytes += @sizeOf(T);
        const AFTER = self.allocBytes - initialValue;
        std.debug.print(
            "Allocated {}. Current: {}\n", 
            .{ AFTER, self.allocBytes }
        );
        return memory;
    }

    pub fn destroy(
        self: *TrackingAllocator,
        comptime T: type,
        memory: *T,
    ) void {
        const initialValue: usize = self.allocBytes;
        self.allocBytes -= @sizeOf(T);
        self.allocator.destroy(memory);
        const FREED: usize = initialValue - self.allocBytes;
        std.debug.print(
            "{} freed. Now: {}\n", 
            .{ FREED, self.allocBytes }
        );
    }

    pub fn bytesAllocated(self: *TrackingAllocator) usize {
        return self.allocBytes;
    }

    pub fn printBits(self: TrackingAllocator) void {
        std.debug.print(
            "Memory: {} bits\n", 
            .{ self.allocBytes * bitsInByte }
        );
    }

    pub fn printBytes(self: TrackingAllocator) void {
        std.debug.print("Memory: {} bytes", .{ self.allocBytes });
    }
};