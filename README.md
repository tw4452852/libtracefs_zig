# libtracefs package for zig

This is [libtracefs](https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/),
packaged for [Zig](https://ziglang.org/).

## How to use it

First, update your `build.zig.zon`:

```
zig fetch --save https://github.com/tw4452852/libtracefs_zig/archive/refs/tags/1.8.1-1.tar.gz
```

Next, add this snippet to your `build.zig` script:

```zig
const libtracefs_dep = b.dependency("libtracefs", .{
    .target = target,
    .optimize = optimize,
});
your_compilation.linkLibrary(libtracefs_dep.artifact("tracefs"));
```

This will add libtracefs as a static library to `your_compilation`.
