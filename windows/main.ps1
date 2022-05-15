param(
  [Switch]$SkipGitInstall
)

function Set-EnvironmentVariables {
  $env:Path = [System.Environment]::GetEnvironmentVariable('Path', 'Machine')
}

$ErrorActionPreference = 'Stop'

$CurrentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (!($CurrentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))) {
  Write-Warning 'Script is not running as Administrator'
  Write-Warning 'Please rerun this script as Administrator.'
  exit
}

if (!(Test-Path -Path "$($PSScriptRoot)\packages.config")) {
  Write-Warning 'packages.config not detected in inputFiles folder'
  Write-Warning 'Did you forget to make the packages.config?'
  exit
}

try {
  choco --version
}
catch {
  Set-ExecutionPolicy Bypass -Scope Process -Force
  Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
  Set-EnvironmentVariables
}

[XML]$ConfigurationFile = Get-Content "$($PSScriptRoot)\packages.config"

$PreCommandsToRun = $ConfigurationFile.GetElementsByTagName('precommandstorun')

if ($PreCommandsToRun -and $PreCommandsToRun.command.length -gt 0) {
  $PreCommandsToRun.command | ForEach-Object {
    Invoke-Expression $_
  }
}

# Install all software from choco packages.config file
choco install "$PSScriptRoot\packages.config" -y
Set-EnvironmentVariables

# Any commands to run after software installation
$PostCommandsToRun = $ConfigurationFile.GetElementsByTagName('postcommandstorun')

if ($PostCommandsToRun -and $PostCommandsToRun.command.length -gt 0) {
  $PostCommandsToRun.command | ForEach-Object {
    Invoke-Expression $_
  }
}

# Clone Git Repos
if (!$SkipGitInstall) {

  choco install git
  Set-EnvironmentVariables

  $GitRepos = $ConfigurationFile.GetElementsByTagName('gitrepos')
  $GitFolder = $ConfigurationFile.GetElementsByTagName('gitrepos').repopath
  
  if ($GitRepos -and $GitRepos.repo.length -gt 0) {
  
    $GitRepos.repo | ForEach-Object {
      if ($GitFolder) {
        $RepoName = (Split-Path $_ -Leaf).Replace('.git' , '')
        Invoke-Expression "git clone $_ $($GitFolder)\$($RepoName)"
      }
      else {
        Invoke-Expression "git clone $_"
      }
    }
  
  }
}