## Environment Setup
- Need Ghostscript and Draw.io (desktop) installed for PDF manipulations and conversions
- To recover Julia and Python environemnts with `Project.toml`, `Manifest.toml`, and `CondaPkg.toml`, run in Julia: 
```julia
using Pkg
Pkg.activate(".")
Pkg.instantiate()

using CondaPkg
CondaPkg.resolve()
```