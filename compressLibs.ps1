$currentLoc = $PWD;

Set-Location -Path ($PSScriptRoot);

if (Test-Path ./artLibs){ Remove-Item -Path ./artLibs };
if (Test-Path ./artLibs.zip) {Remove-Item -Path ./artLibs.zip};

New-Item -Path ./artLibs -ItemType Directory;
Copy-Item -Path C:\projects\lapack\build\bin\blas.dll -Destination ./artLibs/blas.dll;
Copy-Item -Path C:\projects\lapack\build\bin\lapack.dll -Destination ./artLibs/lapack.dll;

Compress-Archive -Path ./artLibs -DestinationPath ./artLibs.zip

Set-Location -Path $currentLoc;