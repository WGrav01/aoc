const std = @import("std");

pub fn parse(input: []const u8) ![][]const u8 {
    var res = std.array_list.AlignedManaged([]const u8, null).init(std.heap.page_allocator);
    var lines = std.mem.tokenizeScalar((u8), input, '\n');

    while (lines.next()) |line| {
        try res.append(line);
    }
    return res.toOwnedSlice();
}

pub fn solve1(input: [][]const u8) u32 {
    var pos: i32 = 50;
    var count: u32 = 0;
    for (0..input.len) |i| {
        const number: i32 = std.fmt.parseInt(i32, input[i][1..input[i].len], 10) catch |e| {
            std.debug.panic("Failed to parse int: {}", .{e});
        };
        switch (input[i][0]) {
            'L' => pos -= number,
            'R' => pos += number,
            else => std.debug.panic("Invalid first number of {s}", .{input[i]})
        }

        pos = @mod(pos, 100);
        if (pos < 0) pos += 100;

        if (pos == 0) count += 1;
    }

    return count;
}

pub fn solve2(input: [][]const u8) u32 {
    var pos: i32 = 50;
    var count: i32 = 0;

    for (0..input.len) |i| {
        // const oldpos = pos;
        const number: i32 = std.fmt.parseInt(i32, input[i][1..input[i].len], 10) catch |e| {
            std.debug.panic("Failed to parse int: {}", .{e});
        };
        switch (input[i][0]) {
            'L' => {
                const newpos = @mod(pos - number, 100);

                if (pos == 0) {
                    count += @divFloor(number, 100);
                } else if (number > pos) {
                    count += @divFloor(number - pos - 1, 100) + 1;
                    if (newpos == 0) {
                        count += 1;
                    }
                } else if (number == pos) {
                    count += 1;
                }
                
                pos = newpos;
            },
            'R' => {
                count += @divFloor(pos + number, 100);
                pos = @mod(pos + number, 100);
            },
            else => std.debug.panic("Invalid first number of {s}", .{input[i]})
        }
    }

    return @abs(count); // needs to be casted to u32
}