const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const upstream = b.dependency("upstream", .{});
    const libtraceevent = b.dependency("libtraceevent", .{
        .target = target,
        .optimize = optimize,
    });

    const lib = b.addStaticLibrary(.{
        .name = "tracefs",
        .target = target,
        .optimize = optimize,
    });

    const cflags = [_][]const u8{
        "-D_GNU_SOURCE",
    };
    lib.linkLibC();
    lib.addCSourceFiles(.{
        .root = upstream.path(""),
        .files = &.{
            "src/tracefs-utils.c",
            "src/tracefs-instance.c",
            "src/tracefs-events.c",
            "src/tracefs-tools.c",
            "src/tracefs-marker.c",
            "src/tracefs-kprobes.c",
            "src/tracefs-hist.c",
            "src/tracefs-stats.c",
            "src/tracefs-filter.c",
            "src/tracefs-dynevents.c",
            "src/tracefs-eprobes.c",
            "src/tracefs-uprobes.c",
            "src/tracefs-record.c",
            "src/tracefs-mmap.c",
            "src/tracefs-vsock.c",
            "src/tracefs-perf.c",
            "src/sqlhist-lex.c",
            "src/sqlhist.tab.c",
            "src/tracefs-sqlhist.c",
        },
        .flags = &cflags,
    });
    lib.addIncludePath(.{ .dependency = .{
        .dependency = upstream,
        .sub_path = "include",
    } });
    lib.linkLibrary(libtraceevent.artifact("traceevent"));

    lib.installHeadersDirectory(upstream.path("include"), "", .{
        .include_extensions = &.{
            "tracefs.h",
        },
    });

    b.installArtifact(lib);
}
