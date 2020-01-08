load(
    "//ruby/private/tools:deps.bzl",
    _transitive_deps = "transitive_deps",
)


def _to_ruby_array_string(arr):
    """Converts an array of strings to a ruby representation of those strings

    Args:
      arr: an array of strings
    """


def _generate_gemspec(ctx):
    return

def _rb_gem_impl(ctx):
    gemspec = ctx.actions.declare_file("%s.gemspec" % ctx.attr.name)

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
            "{srcs}": repr(ctx.attr.deps),
            "{authors}": repr(ctx.attr.authors),
        },
    )

_ATTRS = {
    "version": attr.label(),
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
}

rb_gem = rule(
    implementation = _rb_gem_impl,
    attrs = _ATTRS,
)
