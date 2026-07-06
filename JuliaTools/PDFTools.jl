# need MuPDF, Ghostscript, and Draw.io installed
# make sure the path names of PDFs have ".pdf" at the end

using Pkg;Pkg.activate(raw"D:\Toolboxes\JuliaTools");Pkg.instantiate()  # change to the path of the folder PDFTools.jl is in

const path_Mu = raw"D:\Program Files\mupdf-1.28.0-windows\mutool.exe"  # change to local MuPDF mutool path
const path_GS = raw"D:\Program Files\gs\gs10.06.0\bin\gswin64c.exe" # change to the local Ghostscript installation path
const path_Tessdata = raw"D:\Program Files\gs\gs10.06.0\Resource\tessdata"  # change to Tess data path for Ghostscript OCR
const path_Drawio = raw"D:\Program Files\draw.io\draw.io.exe"   # change to the local Draw.io installation path

# repair and compress PDF
function repairPDF(inputPath::String;outputPath::String="",method::String="MuPDF")
    if !isfile(inputPath)
        error("file not found: $inputPath")
    end
    if isempty(outputPath)
        outputPath = replace(inputPath,".pdf"=>"_Fixed.pdf")
    end

    if method == "MuPDF"
        cmd = `"$path_Mu" clean -g "$inputPath" "$outputPath"`
    elseif method == "Ghostscript"
        # Ghostscript arguments
        flags = [
            "-dSAFER",
            "-sDEVICE=pdfwrite",
            "-dCompatibilityLevel=1.4",
            "-dPDFSETTINGS=/prepress",
            "-dEmbedAllFonts=true",
            "-dSubsetFonts=true",
            "-dDetectDuplicateImages=true",
            "-dCompressFonts=true",
            "-dAutoRotatePages=/None",
            # "-dHaveTransparency=false", # commented out to prevent black pages
            "-o",outputPath,
            "-f",inputPath
        ]
        cmd = `$path_GS $flags`
    else
        error("method does not exist: $method")
    end

    # execute command
    println("processing: $inputPath")
    run(cmd)
    println("repair complete; saved to: $outputPath")
end

# merge PDFs
function mergePDFs(inputFiles::Vector{String};outputPath::String="")
    if isempty(inputFiles)
        error("input vector is empty; provide at least one PDF")
    end
    if isempty(outputPath)
        outputPath = replace(inputFiles[1],".pdf"=>"_Merged.pdf")
    end

    # MuPDF syntax: mutool merge -o output.pdf input1.pdf input2.pdf
    fullCommandArgs = vcat(["merge","-o",outputPath],inputFiles)
    println("merging $(length(inputFiles)) files")
    run(`"$path_Mu" $fullCommandArgs`)
    println("merge complete; saved to: $outputPath")
end

# extract pages
function extractPages(inputPath::String,pageList::Vector{Int64};outputPath::String="")
    if !isfile(inputPath)
        error("file not found: $inputPath")
    end
    if isempty(outputPath)
        outputPath = replace(inputPath,".pdf"=>"_Extracted.pdf")
    end

    # convert Vector to String
    pageListString = join(pageList,",")

    # MuPDF syntax for extraction: mutool clean input.pdf output.pdf [pages]
    cmd = `"$path_Mu" clean "$inputPath" "$outputPath" $pageListString`
    println("extracting pages $pageListString")
    run(cmd)
    println("extraction complete; saved to: $outputPath")
end

# OCR 
function OCR(inputPath::String;outputPath::String="",language::String="eng",DPI=300)
    if !isfile(inputPath)
        error("file not found: $inputPath")
    end
    if isempty(outputPath)
        outputPath = replace(inputPath,".pdf"=>"_OCR.pdf")
    end

    # Ghostscript arguments for OCR
    flags = [
        "-dSAFER",
        "-sDEVICE=pdfocr8",       # Ghostscript's OCR output device
        "-r$(DPI)",                  # 300 DPI is the sweet spot for OCR accuracy
        "-sOCRLanguage=$language", # default is English ("eng")
        "-dAutoRotatePages=/None",
        "-o",outputPath,
        "-f",inputPath
    ]

    # execute command
    println("running OCR via Ghostscript on: $inputPath")
    try
        cmd = addenv(`$path_GS $flags`,"TESSDATA_PREFIX"=>path_Tessdata)    # add a temporary environment variable
        run(cmd)
        println("OCR complete; saved to: $outputPath")
    catch e
        error("OCR failed. (Note: Ensure Ghostscript has access to the 'tessdata' folder for language packs). Error: $e")
    end
end

# Drawio to PDF 
function Drawio2PDF(inputPath::String;outputPath::String="",crop::Bool=true)
    if !isfile(inputPath)
        error("file not found: $inputPath")
    end
    if isempty(outputPath)
        outputPath = replace(inputPath,r"\.(svg|drawio)$"i=>".pdf")
    end

    # generate Draw.io commands
    if crop == true
        cmd = `"$path_Drawio" -x -f pdf --crop --transparent -o "$outputPath" "$inputPath"`
    else
        cmd = `"$path_Drawio" -x -f pdf --transparent -o "$outputPath" "$inputPath"`
    end

    # convert
    println("converting: $inputPath")
    try
        run(cmd)
        println("conversion complete; saved to: $outputPath")
    catch e
        error("conversion failed; error: $e")
    end
end