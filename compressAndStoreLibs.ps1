$currentLoc = $PWD;

Set-Location -Path ($PSScriptRoot);

if (Test-Path ./artWinLibs){ Remove-Item -Path ./artWinLibs };
if (Test-Path ./artLinuxLibs){ Remove-Item -Path ./artLinuxLibs };
if (Test-Path ./artWinLibs.zip){ Remove-Item -Path ./artWinLibs.zip };
if (Test-Path ./artLinuxLibs.zip ){ Remove-Item -Path ./artLinuxLibs.zip };

if ($env:OS -eq "Windows_NT")
{
    New-Item -Path ./artWinLibs -ItemType Directory;
    Copy-Item -Path C:\projects\lapack\build\bin\blas.dll -Destination ./artWinLibs/blas.dll;
    Copy-Item -Path C:\projects\lapack\build\bin\lapack.dll -Destination ./artWinLibs/lapack.dll;
    Compress-Archive -Path ./artWinLibs -DestinationPath ./artWinLibs.zip;
    Push-AppveyorArtifact ./artWinLibs.zip;
}
else
{
    New-Item -Path ./artLinuxLibs -ItemType Directory;
    Copy-Item -Path '/home/appveyor/projects/lapack/build/lib/libblas.so' -Destination ./artLinuxLibs/libblas.so;
    Copy-Item -Path '/home/appveyor/projects/lapack/build/lib/liblapack.so' -Destination ./artLinuxLibs/liblapack.so;
    Compress-Archive -Path ./artLinuxLibs -DestinationPath ./artLinuxLibs.zip;
    Push-AppveyorArtifact ./artLinuxLibs.zip;
}

Set-Location -Path $currentLoc;

