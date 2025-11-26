# Approximate Recurrence Quantification Analysis apRQA

[![SWH](https://archive.softwareheritage.org/badge/origin/https://github.com/pucicu/apRQA/)](https://archive.softwareheritage.org/browse/origin/?origin_url=https://github.com/pucicu/apRQA)
![file size](https://img.shields.io/github/repo-size/pucicu/apRQA)
![GitHub Release](https://img.shields.io/github/v/release/pucicu/apRQA)

## General

Julia package to calculate selected main measures of the recurrence 
quantification analysis (RQA). The calculation is performed in an 
highly efficient but very approximative way using the algorithm 
described in Spiegel et al, 2016. 

The RQA approximation corresponds to non-embedded RQA and using
maximum norm.

__Note:__ Depending on the time series and its length, the results can deviate
much from standard (exact) RQA implementation. Be careful when using this approach!

## Installation

### From GitHub

Since this package is not yet registered in the Julia General registry, you can install it directly from GitHub:

```julia
using Pkg
Pkg.add(url="https://github.com/pucicu/apRQA")
```

### Development Installation

If you want to modify the package or contribute to development:
```julia
using Pkg
Pkg.develop(url="https://github.com/pucicu/apRQA")
```

Or clone the repository and install locally:
```bash
git clone https://github.com/pucicu/apRQA.git
cd apRQA
```

Then in Julia:
```julia
using Pkg
Pkg.activate(".")
Pkg.instantiate()
```

### Requirements

- Julia ≥ 1.6
- Dependencies (automatically installed):
  - LinearAlgebra
  - StatsBase

## Quick Start

```julia
using apRQA
using Random

# Generate example data
Random.seed!(42)
x = rand(10000)

# Parameters
ε = 0.1       # similarity threshold
minL = 2      # minimum line length

# Compute approximate RQA measures
results = approximate_rqa(x, ε, minL)
RR, DET, L, LAM = results

println("RR:  $(results[:RR])")   # Recurrence Rate
println("DET: $(results[:DET])")  # Determinism
println("L:   $(results[:L])")    # Average diagonal line length
println("LAM: $(results[:LAM])")  # Laminarity
```

## Testing

Run the test suite:
```julia
using Pkg
Pkg.test("apRQA")
```

# Reference

S. Spiegel, D. Schultz, N. Marwan: Approximate Recurrence Quantification Analysis (aRQA) in Code of Best Practice, In: Recurrence Plots and Their Quantifications: Expanding Horizons, Eds.: C. L. Webber, Jr. and C. Ioana and N. Marwan, Springer, Cham, 113–136 (2016). DOI:[10.1007/978-3-319-29922-8_6](https://doi.org/10.1007/978-3-319-29922-8_6)

# Copyright

Norbert Marwan\
Potsdam Institute for Climate Impact Research\
11/2025

License: GPLv3+
