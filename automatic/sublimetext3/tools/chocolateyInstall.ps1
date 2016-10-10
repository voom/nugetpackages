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

  # Sublime is installed
  Write-Host "$package is already installed to : " $result

} else {

  # Sublime is not installed
  $params = @{
    PackageName = $package;
    FileType = 'exe';
    #uses InnoSetup - http://www.jrsoftware.org/ishelp/index.php?topic=setupcmdline
    SilentArgs = '/VERYSILENT /NORESTART /TASKS="contextentry"';
    Url = '{{DownloadUrl}}';
    Url64Bit = '{{DownloadUrlx64}}';
  }

  Install-ChocolateyPackage @params
}