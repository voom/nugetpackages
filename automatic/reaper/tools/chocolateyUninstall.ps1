$packageName = '{{PackageName}}'
$fileType = 'exe'
$silentArgs = '/S'
$validExitCodes = @(0)

$processor = Get-WmiObject Win32_Processor
$is64bit = $processor.AddressWidth -eq 64
if ($is64bit) {
  $unpath = "$Env:ProgramFiles\Reaper (x64)\uninstall.exe"
} else {
  $unpath = "${Env:ProgramFiles(x86)}\Reaper\uninstall.exe"
}

Uninstall-ChocolateyPackage "$packageName" "$fileType" "$silentArgs" "$unpath" -validExitCodes $validExitCodes