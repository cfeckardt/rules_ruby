package(default_visibility = ["//:__subpackages__"])

load(
    "@coinbase_rules_ruby//ruby:defs.bzl",
    "rb_gem",
)

rb_gem(
    name = "default_gem",
    authors = ["Coinbase"],
    deps = [
        "//lib:example_gem",
    ],
    version = "0.1.0",
)
