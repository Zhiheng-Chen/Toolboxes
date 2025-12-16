## Environment Setup
- Need [Ghostscript](https://ghostscript.com/releases/gsdnld.html) and Draw.io ([desktop](https://www.drawio.com/)) installed for PDF manipulations and conversions
- No Python installation needed. `PythonCall.jl` and `CondaPkg.jl` will automatically build a local Python environment
- To recover Julia and Python environemnts with `Project.toml`, `Manifest.toml`, and `CondaPkg.toml`, run in Julia: 

```julia
using Pkg
Pkg.activate(".")
Pkg.instantiate()

using CondaPkg
CondaPkg.resolve()
```