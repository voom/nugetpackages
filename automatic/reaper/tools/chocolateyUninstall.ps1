$packageName = '{{PackageName}}'
$installerType = 'exe'
$silentArgs = '/S'
$validExitCodes = @(0)

try {
  $processor = Get-WmiObject Win32_Processor
  $is64bit = $processor.AddressWidth -eq 64
  if ($is64bit) {
    $unpath = "$Env:ProgramFiles\Reaper (x64)\uninstall.exe"
  } else {
    $unpath = "${Env:ProgramFiles(x86)}\Reaper\uninstall.exe"
  }

  Uninstall-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$unpath" -validExitCodes $validExitCodes
  Write-ChocolateySuccess "$packageName"
} catch {
  Write-ChocolateyFailure "$packageName" "$($_.Exception.Message)"
  throw
}