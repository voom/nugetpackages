$packageName = '{{PackageName}}'
$fileType = 'exe'
$url = '{{DownloadUrl}}'
$url64 = '{{DownloadUrlx64}}'
$silentArgs = '/S'
$validExitCodes = @(0,1223)

Install-ChocolateyPackage "$packageName" "$fileType" "$silentArgs" "$url" "$url64"  -validExitCodes $validExitCodes