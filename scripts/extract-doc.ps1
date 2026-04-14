﻿$ErrorActionPreference = 'Stop'

# Thai filename/path fragments built via char codes to avoid any encoding surprises
$thaiBotTi  = [string]([char]0x0E1A + [char]0x0E17 + [char]0x0E17 + [char]0x0E35 + [char]0x0E48) # บทที่
$thaiNganMae = [string]([char]0x0E07 + [char]0x0E32 + [char]0x0E19 + [char]0x0E41 + [char]0x0E21 + [char]0x0E48) # งานแม่

$Root = [System.IO.Path]::Combine('C:\Users\Asus\Documents', $thaiNganMae)
Write-Host "Root: $Root"
Write-Host "RootExists: $([System.IO.Directory]::Exists($Root))"

$contentDir = [System.IO.Path]::Combine($Root, 'content')
$imgBase    = [System.IO.Path]::Combine($contentDir, 'images')
[System.IO.Directory]::CreateDirectory($imgBase) | Out-Null

$word = New-Object -ComObject Word.Application
$word.Visible = $false
try {
  Add-Type -AssemblyName System.IO.Compression.FileSystem

  foreach ($n in 1..3) {
    $inName  = "$thaiBotTi $($n)_AR.doc"
    $inPath  = [System.IO.Path]::Combine($Root, $inName)
    $txtPath = [System.IO.Path]::Combine($contentDir, "ch$n.txt")
    $imgDir  = [System.IO.Path]::Combine($imgBase, "ch$n")
    $tmpDocx = [System.IO.Path]::Combine($env:TEMP, "ar_ch$n.docx")

    [System.IO.Directory]::CreateDirectory($imgDir) | Out-Null

    if (-not [System.IO.File]::Exists($inPath)) {
      Write-Host "[ch$n] MISSING input: $inPath"
      continue
    }

    Write-Host "[ch$n] opening"
    $doc = $word.Documents.Open($inPath, $false, $true)

    # Save as .docx only — we'll pull text from document.xml directly (Word's text export is codepage-unreliable)
    $doc.SaveAs2($tmpDocx, 16)
    $doc.Close()
    Write-Host "[ch$n] saved docx"

    $extractDir = "$tmpDocx.extract"
    if ([System.IO.Directory]::Exists($extractDir)) {
      [System.IO.Directory]::Delete($extractDir, $true)
    }
    [System.IO.Compression.ZipFile]::ExtractToDirectory($tmpDocx, $extractDir)

    # Extract text from word/document.xml
    $docXmlPath = [System.IO.Path]::Combine($extractDir, 'word', 'document.xml')
    if ([System.IO.File]::Exists($docXmlPath)) {
      [xml]$xml = [System.IO.File]::ReadAllText($docXmlPath, [System.Text.Encoding]::UTF8)
      $ns = New-Object System.Xml.XmlNamespaceManager($xml.NameTable)
      $ns.AddNamespace('w', 'http://schemas.openxmlformats.org/wordprocessingml/2006/main')

      $sb = New-Object System.Text.StringBuilder
      foreach ($p in $xml.SelectNodes('//w:p', $ns)) {
        $paraText = ''
        foreach ($node in $p.SelectNodes('.//w:t | .//w:tab | .//w:br', $ns)) {
          switch ($node.LocalName) {
            't'   { $paraText += $node.InnerText }
            'tab' { $paraText += "`t" }
            'br'  { $paraText += "`n" }
          }
        }
        [void]$sb.AppendLine($paraText)
      }
      [System.IO.File]::WriteAllText($txtPath, $sb.ToString(), (New-Object System.Text.UTF8Encoding($false)))
      Write-Host "[ch$n] wrote txt ($($sb.Length) chars)"
    } else {
      Write-Host "[ch$n] WARN: no document.xml"
    }

    $media = [System.IO.Path]::Combine($extractDir, 'word', 'media')
    if ([System.IO.Directory]::Exists($media)) {
      $count = 0
      foreach ($f in [System.IO.Directory]::EnumerateFiles($media)) {
        $dest = [System.IO.Path]::Combine($imgDir, [System.IO.Path]::GetFileName($f))
        [System.IO.File]::Copy($f, $dest, $true)
        $count++
      }
      Write-Host "[ch$n] extracted $count images"
    } else {
      Write-Host "[ch$n] no images"
    }
    [System.IO.Directory]::Delete($extractDir, $true)
    [System.IO.File]::Delete($tmpDocx)
  }
}
catch {
  Write-Host "ERROR: $($_.Exception.Message)"
  Write-Host $_.ScriptStackTrace
  throw
}
finally {
  $word.Quit() | Out-Null
  [System.Runtime.Interopservices.Marshal]::ReleaseComObject($word) | Out-Null
  [GC]::Collect() | Out-Null
}
Write-Host "DONE"
