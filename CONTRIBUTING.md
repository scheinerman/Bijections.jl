# Contributing

Everyone is welcome to contribute! You can contribute via simply opening Issues reporting bugs or requesting features.

## Pull Request Contributions

The best way to contribute is by doing a Pull Request that fixes a bug or implements a new feature.

However, before opening the PR, consider first discussing the change you wish to make via an issue, so that a good design can be discussed.

To make a good PR, follow these steps:

1. Ensure all tests pass locally before starting the pull request.
2. Add adequate description in the Pull Request, or cite the corresponding issue if one exists by using `#` and the issue number.
3. Always allow the "editing from maintainers" option in your PR.
4. Update the CHANGELOG.md with details of the (notable) changes to the exported API.
5. Feel free to explicitly tag (with `@`) one of the maintainers to request a review of your PR when it is ready.


## Source Code Formatting

This project uses the [Blue code style](https://github.com/JuliaDiff/BlueStyle), enforced via [JuliaFormatter](https://github.com/domluna/JuliaFormatter.jl). For pull requests, adherence to the code style is automatically checked during continuous integration.

To apply the code style locally, you should have `JuliaFormatter` installed in your global Julia environment. Then, in a Julia REPL within the `Bijections` project folder, run `using JuliaFormatter; format(".")`.

Alternatively, if you are on Unix and have `make` installed, run `make codestyle`. See `make help` for details.


## Running the Tests

There are a few way to run the tests:

* Start a Julia REPL with `julia --project=.`, then type `] test`

* If you are on Unix and have `make` installed, run `make test`. Also consider `make testrepl`, `make coverage` and `make htmlcoverage`, see `make help` for details.

* Start a Julia REPL in the test environment with `julia --project=test`. Instantiate with `] instantiate`, then run the tests with `include("test/runtests.jl")`. On Julia < 1.11, you may need `] dev .` to ensure that the test environment uses the current code.

Run `make clean` or `make distclean` to delete coverage information, see `make help` for details.


## Building the Documentation

Use one of the following two possibilities to build the documentation locally:

* Start a Julia REPL in the docs environment with `julia --project=docs`. Instantiate with `] instantiate`, then build the documentation with `include("docs/make.jl")`. On Julia < 1.11, you may need `] dev .` to ensure that the test environment uses the current code

* If you are on Unix and have `make` installed, run `make docs`. See `make help` for details.

This will build the documentation in `./docs/build`. The preview it, you must run a web server, either via the [LiveServer](https://github.com/JuliaDocs/LiveServer.jl) package, or (if you have Python installed), via `python3 -m http.server`. See the [Documenter Guide](https://documenter.juliadocs.org/stable/man/guide/#Note-6b659cc6046c5199) for details.

Run `make clean` or `make distclean` to remove the documentation build, see `make help` for details.


## Maintainer Notes

### Maintainers

* The original author of the package is Ed Scheinerman (@scheinerman), retaining authority over the development of the package as a co-maintainer.
* The current maintainer of the package is Sergio Sánchez Ramírez (@mofeing).
* Michael Goerz (@goerz) is a contributor with commit access for administrative purposes

### PR review and merging

* PRs can be merged by anyone with commit access.
* PRs by authors with commit access can be self-merged after approval from a (co-)maintainer, or directly (without review) for trivial PRs
