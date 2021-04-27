# Multivector.jl

![julia-version][julia-version] ![status][status] ![package-version][package-version]

[julia-version]: https://img.shields.io/badge/julia_version-v1.6-9558B2?style=flat&logo=julia
[status]: https://img.shields.io/badge/project_status-🚧_work--in--progress-ba8a11?style=flat
[package-version]: https://img.shields.io/badge/package_version-0.1-blue?style=flat

Julia implementation of multivectors for [Geometric Algebra](https://en.wikipedia.org/wiki/Geometric_algebra)

❌ **BROKEN: use at your own risk**

🚧 _This is a work-in-progress project: it is not ready to use and much of the code has yet to be written._

## Table of Contents

- [Multivector.jl](#multivectorjl)
  - [Table of Contents](#table-of-contents)
  - [Installation](#installation)
  - [Usage](#usage)
  - [Examples](#examples)
  - [Contributing](#contributing)
  - [License](#license)

## Installation

The package is still under development and is not available in the official registry. To add this package to your work environment, open julia and type the following commands:

```julia
import Pkg
Pkg.add(url="https://github.com/Samuele-Colombo/Multivectors")
```

## Usage

An instance of `MultiVector3D` can be constructed both with the default constructor and with the following notation:
```julia
julia> 1 + 3x̂ + 4x̂ŷ + 1ı̂
1 + 3x̂ + 4x̂ŷ + 1x̂ŷẑ
```
Where using the symbols `ı̂`, `x̂ŷẑ` or `im` is equivalent.

## Examples

WIP

## Contributing

WIP

## License

The code is released under a MIT license. See the file [LICENSE.md](./LICENSE.md).
