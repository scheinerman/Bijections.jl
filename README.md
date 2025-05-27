# Bijections

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://scheinerman.github.io/Bijections.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://scheinerman.github.io/Bijections.jl/dev/)
[![Build Status](https://github.com/scheinerman/Bijections.jl/actions/workflows/CI.yml/badge.svg?branch=master)](https://github.com/scheinerman/Bijections.jl/actions/workflows/CI.yml?query=branch%3Amaster)

Julia dictionaries are not one-to-one. That is, two different keys might have the same value.
A `Bijection` data structure behaves just like a dictionary, except it prevents the assignment of the same value to two different keys.

See [the documentation](https://scheinerman.github.io/Bijections.jl/stable/) for more details.

See [the changelog](CHANGELOG.md) for a version history.
