# Variables
$package = '{{PackageName}}'
$build = '{{PackageVersion}}'

# Determine if Sublime Text 3 $build Version is installed
#   - Return the path if found
#   - Return $false if not
function getInstallationDirectory($buildArg) {

  $installFolder = 'Sublime Text 3'
  $installedPath = [string]::empty
  $found = $false

  if(!${env:ProgramFiles(x86)}) {

    # 32 bit machine
    $installedPath = Join-Path $Env:ProgramFiles $installFolder;

  } else {

    # 64 bit machine
    # Get the first path which is existing
    $installedPath = (Join-Path "${Env:ProgramFiles(x86)}" $installFolder),
    (Join-Path $Env:ProgramFiles $installFolder) |
    ? { Test-Path $_ } |
    Select -First 1

  }

  # Check Sublime Text's folder existence
  if (![string]::IsNullOrEmpty($installedPath) -and (Test-Path $installedPath)) {

    $exe = Join-Path $installedPath 'sublime_text.exe'

    # Check Sublime Executable existence
    if (![string]::IsNullOrEmpty($exe) -and (Test-Path $exe)) {
      $version = (Get-Command $exe).FileVersionInfo.ProductVersion
      $found = ($version -eq $buildArg)
    }
  }

  # If we don't found the build we are looking for
  if (!$found) {
    $installedPath = $false
  }

  return $installedPath;
}

# Self Executing utiliy function
$result = (getInstallationDirectory($build))

if ( !($result -eq $false) )  {

  # Sublime is installed Start the uninstallation
  Push-Location $result # move to Sublime Text Folder
  $uninstallerName = 'unins000.exe'

  # Check if the Uninstaller is present in $result folder
  if (Test-Path $uninstallerName) {

    $params = @{
      PackageName = $package;
      FileType = 'exe';
      SilentArgs = '/SILENT /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /TASKS="contextentry"';
      File = (Join-Path $result $uninstallerName)
    }

   Uninstall-ChocolateyPackage @params

  }
} else {

  # Sublime is not installed
  Write-Host "Sublime Text $build is not installed"
}