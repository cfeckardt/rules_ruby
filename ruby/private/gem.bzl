load(
    ":gemspec.bzl",
    _rb_gemspec = "rb_gemspec",
)

load("@rules_pkg//:pkg.bzl",
     "pkg_zip",
)

def rb_gem(name, version, srcs = [], **kwargs):
    _zip_name = "%s-%s" %(name, version)
    print("zipname")
    print(_zip_name)

    _rb_gemspec(
        name = name,
        version = version,
        **kwargs
    )

    # pkg_zip(
    #     name = _zip_name,
    #     srcs = srcs + [":" + name],
    # )
