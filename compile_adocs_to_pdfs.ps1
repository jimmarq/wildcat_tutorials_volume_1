# This script searches all subfolders for .adoc files and looks
# for a matching .pdf file. If no .pdf is found, it will be
# created using asciidoctor-pdf. If a .pdf is found, the dates are 
# checked. If the .md file was modified later than the
# .pdf, the .pdf will be regenerated.
#
# asciidoctor-pdf must be in the PATH Windows environment variable.
#
$start_location = Get-Location
Do {
Write-Host "`nSearching $(Get-Location) and subfolders for for .adoc files"
$adocfiles = gci -rec -filter *.adoc
foreach ($adoc in $adocfiles)
{
    $pdfpath = "$($adoc.DirectoryName)\$($adoc.BaseName).pdf"
    if (-Not (Test-Path $pdfpath))
    {
        Write-Host "Creating $($adoc.BaseName).pdf"
        Set-Location $adoc.DirectoryName
        asciidoctor-pdf "$($adoc.FullName)"
    } else {
        $pdf = gci $pdfpath
        if ($pdf.LastWriteTime -lt $adoc.LastWriteTime)
        {
            Write-Host "Updating $($adoc.BaseName).pdf"
            Set-Location $adoc.DirectoryName
            asciidoctor-pdf "$($adoc.FullName)"
        }
    }
}
Set-Location $start_location
Write-Host "Done."
Write-Host -NoNewLine "Press any key to exit. Press 'y' to re-run.`n";
$input = [Console]::ReadKey()
} while($input.keyChar -eq 'y')

