$ErrorActionPreference = "Stop"

function Has-Cmd($name) {
  return $null -ne (Get-Command $name -ErrorAction SilentlyContinue)
}

if ((Has-Cmd "python") -or (Has-Cmd "python3") -or (Has-Cmd "py")) {
  Write-Host "Python found."
}
else {
  Write-Error "Python 3 is required but not found. Install Python 3 first: https://www.python.org/downloads/"
}

if (Has-Cmd "yt-dlp") {
  Write-Host "yt-dlp already installed: $(yt-dlp --version)"
  exit 0
}

if (Has-Cmd "winget") {
  winget install --id yt-dlp.yt-dlp --silent --accept-source-agreements --accept-package-agreements
  Write-Host "Installed yt-dlp via winget."
  exit 0
}

if (Has-Cmd "choco") {
  choco install yt-dlp -y
  Write-Host "Installed yt-dlp via chocolatey."
  exit 0
}

Write-Error "Neither winget nor choco found. Install yt-dlp manually: https://github.com/yt-dlp/yt-dlp"
