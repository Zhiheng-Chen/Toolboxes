module PDFTools
# need Ghostscript installed
# make sure the path names of PDFs have ".pdf" at the end

export repairPDF,mergePDFs,extractPages

const path_GS = raw"D:\Program Files\gs\gs10.06.0\bin\gswin64c.exe" # change to the local Ghostscript installation path

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
             # "-dHaveTransparency=false", # Commented out to prevent black pages
             "-o",outputPath,
             "-f",inputPath]

    # execute command
    println("processing: $inputPath")
    run(`$path_GS $flags`)
    println("repair complete; saved to: $outputPath")
end

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

end