
$currentLoc = $PWD;

Set-Location -Path ($PSScriptRoot);

try {

    if (Test-Path -Path ./build/lib ) {echo "lib exist"};
    if (Test-Path -Path ./build/bin ) {echo "bin exist"};

    Get-ChildItem -Recurse -Path ./build/lib | % {echo $_.Fullname}
    Get-ChildItem -Recurse -Path ./build/bin | % {echo $_.Fullname}

    dotnet build ./NUGET/NetLib.LAPACK.csproj
}
catch {
    
}

Set-Location $currentLoc;