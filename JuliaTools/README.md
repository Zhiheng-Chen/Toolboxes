## Environment Setup
- Need [MuPDF](https://mupdf.com/releases?product=MuPDF), [Ghostscript](https://ghostscript.com/releases/gsdnld.html) and Draw.io ([desktop](https://www.drawio.com/)) installed for PDF manipulations and conversions. For Ghostscript OCR to function, need to download the [language package](https://github.com/tesseract-ocr/tessdata_best/blob/main/eng.traineddata) and put it inside the `Resource\tessdata` folder inside the Ghostscript folder.
- No Python installation needed. `PythonCall.jl` and `CondaPkg.toml` will automatically build a local Python environment
- To recover Julia and Python environemnts with `Project.toml`, `Manifest.toml`, and `CondaPkg.toml`, run in Julia: 

```julia
using Pkg
Pkg.activate(".")
Pkg.instantiate()

using CondaPkg
CondaPkg.resolve()
```