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
};