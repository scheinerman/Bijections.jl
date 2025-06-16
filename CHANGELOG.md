# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).


## [1.0.0][] - TBD


### Changed

* Moved project to the [JuliaCollections org](https://github.com/JuliaCollections)
* Optimized `Serialization.serialize` size by saving only the forward dictionary ([#32][], [#34][]).

### Breaking

* Removed `domain` and `image` functions. Use `Base.keys` and `Base.values` instead ([#27][], [#28][]).
* Removed composition with `*`. With a `Bijection` allowing `AbstractDict` instances other than `Dict` for the forward and inverse mapping, as introduced in `0.2.0`, the correct type for a composition of two bijections is no longer well-defined, see the discussion in [#41][]. Existing use of `a * b` can be replaced by `Bijection((x => a[b[x]] for x in keys(b))...)`.
([#30][], [#39][])


## [0.2.2][] - 2025-05-27

### Added

* Added API documentation
* Added a CHANGELOG


## [0.2.1][] - 2025-05-26

### Fixed

* Minor changes to the documentation


## [0.2.0][] - 2025-05-26

### Breaking changes

* The `domain` and `image` functions now return iterators.
* The `Bijection` data structure has been simplified.
* Option to use `IdDict` instead of `Dict`; see the Mutable page in this documentation.

It is likely that code using version 0.1 will not need to be modified to work with 0.2.


## 0.1.x

See https://github.com/JuliaCollections/Bijections.jl/releases for changelog of `v0.1.x` releases.

[0.2.2]: https://github.com/JuliaCollections/Bijections.jl/releases/tag/v0.2.2
[0.2.1]: https://github.com/JuliaCollections/Bijections.jl/releases/tag/v0.2.1
[0.2.0]: https://github.com/JuliaCollections/Bijections.jl/releases/tag/v0.2.0
[#27]: https://github.com/JuliaCollections/Bijections.jl/issues/27
[#28]: https://github.com/JuliaCollections/Bijections.jl/pull/28
[#30]: https://github.com/JuliaCollections/Bijections.jl/issues/30
[#32]: https://github.com/JuliaCollections/Bijections.jl/issues/32
[#34]: https://github.com/JuliaCollections/Bijections.jl/pull/34
[#39]: https://github.com/JuliaCollections/Bijections.jl/pull/39
[#41]: https://github.com/JuliaCollections/Bijections.jl/pull/41
