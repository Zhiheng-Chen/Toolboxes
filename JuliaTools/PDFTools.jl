# need Ghostscript and Draw.io installed
# make sure the path names of PDFs have ".pdf" at the end

using Pkg;Pkg.activate(raw"D:\Toolboxes\JuliaTools");Pkg.instantiate()  # change to the path of the folder PDFTools.jl is in

module PDFTools

export repairPDF,mergePDFs,extractPages,Drawio2PDF

const path_GS = raw"D:\Program Files\gs\gs10.06.0\bin\gswin64c.exe" # change to the local Ghostscript installation path
const path_Drawio = raw"D:\Program Files\draw.io\draw.io.exe"   # change to the local Draw.io installation path

# repair and compress PDF
function repairPDF(inputPath::String;outputPath::String="")
    if !isfile(inputPath)
        error("file not found: $inputPath")
    end
    if isempty(outputPath)
        outputPath = replace(inputPath,".pdf"=>"_Fixed.pdf")
    end

    # Ghostscript arguments
    flags = ["-dSAFER",
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
             "-f",inputPath]

    # execute command
    println("processing: $inputPath")
    run(`$path_GS $flags`)
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

    # Ghostscript arguments
    flags = ["-dSAFER",
             "-sDEVICE=pdfwrite",
             "-dCompatibilityLevel=1.4",
             "-dPDFSETTINGS=/prepress", 
             "-dAutoRotatePages=/None",
             "-o",outputPath]

    # append input files to the flags list
    fullCommandArgs = vcat(flags,inputFiles)
    println("merging $(length(inputFiles)) files")
    
    # execute command
    run(`$path_GS $fullCommandArgs`)
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

    # Ghostscript arguments
    flags = ["-dSAFER",
             "-sDEVICE=pdfwrite", 
             "-dCompatibilityLevel=1.4",
             "-dPDFSETTINGS=/prepress", 
             "-dAutoRotatePages=/None",
             "-sPageList=$pageListString", 
             "-o",outputPath,
             "-f",inputPath]

    # execute command
    println("extracting pages $pageListString")
    run(`$path_GS $flags`)
    println("extraction complete; saved to: $outputPath")
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

end

using .PDFTools