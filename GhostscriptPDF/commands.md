## Repairing PDFs
PowerShell command:

```powershell
$gsPath = "D:\Program Files\gs\gs10.06.0\bin\gswin64c.exe"
$inputPath = "D:\UW Madison\UW Marine Robotics Lab\Robotic Fish\RAL\RAL_1.pdf"
$outputPath = "D:\UW Madison\UW Marine Robotics Lab\Robotic Fish\RAL\RAL_fixed_FINAL.pdf"

$argsList = @(
    "-dSAFER",
    "-sDEVICE=pdfwrite",
    "-dCompatibilityLevel=1.4",
    "-dPDFSETTINGS=/prepress",
    "-dEmbedAllFonts=true",
    "-dSubsetFonts=true",
    "-dDetectDuplicateImages=true",
    "-dCompressFonts=true",
    "-dAutoRotatePages=/None",
    # Removed "-dHaveTransparency=false" to prevent black backgrounds
    "-o", $outputPath,
    "-f", $inputPath
)

& $gsPath @argsList
```

## Merging PDFs
PowerShell command:

```powershell
$gsPath = "D:\Program Files\gs\gs10.06.0\bin\gswin64c.exe"

# INPUTS (Order matters: Top file appears first in the PDF)
$file1 = "D:\UW Madison\UW Marine Robotics Lab\Robotic Fish\RAL\response.pdf"
$file2 = "D:\UW Madison\UW Marine Robotics Lab\Robotic Fish\RAL\diff.pdf"

# OUTPUT
$output = "D:\UW Madison\UW Marine Robotics Lab\Robotic Fish\RAL\Full_Resubmission_Package.pdf"

$argsList = @(
    "-dSAFER",
    "-sDEVICE=pdfwrite",
    "-dCompatibilityLevel=1.4",
    "-dPDFSETTINGS=/prepress",  # Keeps quality high
    "-dAutoRotatePages=/None",
    "-o", $output,              # Output file
    $file1,                     # First input
    $file2                      # Second input
)

& $gsPath @argsList
```
