$ErrorActionPreference = 'Stop'

if (!(Test-Path -Path "$($PSScriptRoot)\inputFiles\packages.config")) {
  Write-Warning 'packages.config not detected in inputFiles folder'
  Write-Warning 'Did you forget to make the packages.config?'
  exit
}

$ChocoCheck = choco --version

if (!$ChocoCheck) {
  try {
    Set-ExecutionPolicy Bypass -Scope Process -Force
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
  }
  catch {
    Write-Warning 'There was an error installing Chocolately'
    Write-Warning $Error
    exit
  }
}


if (Test-Path -Path "$($PSScriptRoot)\inputFiles\commandsToRun.json") {
  $CommandsToRun = Get-Content "$($PSScriptRoot)\inputFiles\commandsToRun.json" | ConvertFrom-Json -Depth 5
}

# Any commands to run prior to software installation
if ($CommandsToRun.preCommandsToRun.length -gt 0) {
  $CommandsToRun.preCommandsToRun | ForEach-Object {
    Invoke-Expression $_
  }
}

# Install all software from choco packages.config file
choco install "$PSScriptRoot\inputFiles\packages.config" -y

# Any commands to run after software installation
if ($CommandsToRun.preCommandsToRun.length -gt 0) {
  $CommandsToRun.postCommandsToRun | ForEach-Object {
    Invoke-Expression $_
  }
}