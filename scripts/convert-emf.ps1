$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing

$root = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$outDir = [System.IO.Path]::Combine($root, 'public', 'images', 'ch2')
[System.IO.Directory]::CreateDirectory($outDir) | Out-Null

foreach ($n in 1..7) {
  $src = [System.IO.Path]::Combine($root, 'content', 'images', 'ch2', "image$n.emf")
  $dst = [System.IO.Path]::Combine($outDir, "image$n.png")
  if (-not [System.IO.File]::Exists($src)) { continue }

  $metafile = New-Object System.Drawing.Imaging.Metafile($src)
  $size = $metafile.Size
  # Scale up for crispness on retina displays
  $scale = 2.0
  $w = [int]($size.Width * $scale)
  $h = [int]($size.Height * $scale)
  if ($w -lt 400) { $scale = 400 / $size.Width; $w = 400; $h = [int]($size.Height * $scale) }
  if ($w -gt 1600) { $scale = 1600 / $size.Width; $w = 1600; $h = [int]($size.Height * $scale) }

  $bmp = New-Object System.Drawing.Bitmap($w, $h)
  $bmp.SetResolution(144, 144)
  $gfx = [System.Drawing.Graphics]::FromImage($bmp)
  $gfx.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
  $gfx.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
  $gfx.Clear([System.Drawing.Color]::White)
  $gfx.DrawImage($metafile, 0, 0, $w, $h)

  $bmp.Save($dst, [System.Drawing.Imaging.ImageFormat]::Png)
  $gfx.Dispose(); $bmp.Dispose(); $metafile.Dispose()
  Write-Host "converted image$n.emf -> $w x $h px"
}
Write-Host "DONE"
