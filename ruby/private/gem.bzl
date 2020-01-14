load(
    "//ruby/private/tools:deps.bzl",
    _transitive_deps = "transitive_deps",
)
load(
    "//ruby/private:providers.bzl",
    "RubyLibrary",
)

load("@rules_pkg//:pkg.bzl",
     "pkg_tar",
)

def _get_transitive_srcs(srcs, deps):
    for dep in deps:
        print(dep[RubyLibrary].transitive_ruby_srcs)

    return depset(
        srcs,
        transitive = [dep[RubyLibrary].transitive_ruby_srcs for dep in deps],
    )

def _rb_gem_impl(ctx):
    gemspec = ctx.actions.declare_file("%s.gemspec" % ctx.label.name)

    # example: https://github.com/bazelbuild/examples/blob/master/rules/expand_template/hello.bzl

    # deps = _transitive_deps(
    #     ctx,
    #     extra_files = [gemspec],
    #     # extra_deps = [],
    # )

    ctx.actions.expand_template(
        template = ctx.file._gemspec_template,
        output = gemspec,
        substitutions = {
            "{name}": "\"%s\"" % ctx.label.name,
            "{srcs}": repr(ctx.attr.deps),
            "{authors": repr(ctx.attr.authors),
            "{version}": ctx.attr.version,
        },
    )

    print(_get_transitive_srcs([gemspec], ctx.attr.deps))
    # _dep_files = [d[RubyLibrary].transitive_ruby_srcs for d in ctx.attr.deps]
    # _outputs = [f.transitive_ruby_srcs for f in _dep_files]

    _zip_name = "%s-%s", ctx.label.name, ctx.attr.version

    # pkg_zip(
    #     name = _zip_name,
    #     srcs = _get_transitive_srcs([gemspec], ctx.attr.deps)
    # )

    return [DefaultInfo(files = _get_transitive_srcs([gemspec], ctx.attr.deps))]

_ATTRS = {
    "version": attr.string(
        default = "0.0.1"
    ),
    "authors": attr.string_list(),
    "deps": attr.label_list(
        allow_files = True,
    ),
    "data": attr.label_list(
        allow_files = True,
    ),
    "_gemspec_template": attr.label(
        allow_single_file = True,
        default = "gemspec_template.tpl",
    ),
    "srcs": attr.label_list(
        allow_files = True,
        default = [],
    ),
    "includes": attr.label_list(
        allow_files = True,
        default = [],
    ),
}

rb_gem = rule(
    implementation = _rb_gem_impl,
    attrs = _ATTRS,
)
