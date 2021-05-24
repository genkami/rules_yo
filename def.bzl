load("@bazel_skylib//lib:shell.bzl", "shell")
load("@io_bazel_rules_go//go:def.bzl", "go_context")

def _yo_impl(ctx):
    go = go_context(ctx)
    godir = go.go.path[:-1 - len(go.go.basename)]
    env = dict(go.env)
    env["YO"] = ctx.attr._yo_executable.files.to_list()[0].path
    env["SCHEMA_FILE"] = ctx.attr.schema.files.to_list()[0].path
    env["OUT"] = ctx.outputs.out.path
    env["PACKAGE"] = ctx.attr.package
    env["GODIR"] = godir

    ctx.actions.run(
        inputs = ctx.files.schema,
        outputs = [ctx.outputs.out],
        tools = ctx.files._yo_executable + [go.go],
        env = env,
        executable = ctx.executable._yo_runner,
    )

yo = rule(
    implementation = _yo_impl,
    attrs = {
        "schema": attr.label(
            allow_single_file = True,
            mandatory = True,
        ),
        "out": attr.output(
            mandatory = True,
        ),
        "package": attr.string(
            mandatory = True,
        ),
        "_yo_runner": attr.label(
            default = "//:yo.tmpl.bash",
            executable = True,
            allow_single_file = True,
            cfg = "exec",
        ),
        "_yo_executable": attr.label(
            default = "@io_mercari_go_yo//:yo",
            executable = True,
            allow_single_file = True,
            cfg = "exec",
        ),
        "_go_context_data": attr.label(
            default = "@io_bazel_rules_go//:go_context_data",
        ),
    },
    toolchains = ["@io_bazel_rules_go//go:toolchain"],
)
