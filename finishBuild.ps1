
echo "start package";


if ($env:OS -eq 'Windows_NT')
{
    echo "lets start!"
    $currentLoc = $PWD;

    Set-Location -Path ($PSScriptRoot);

    try 
    {
        $headers = @{
            "Authorization" = "Bearer $env:api_key"
            "Content-type" = "application/json"
        };

        $apiUrl = 'https://ci.appveyor.com/api';
        
        echo "Try to get files"

        $projectInfos = Invoke-RestMethod -Method Get -Uri "$apiUrl/projects/dotchris90/lapack" -Headers $headers;

        echo "got"
        echo $projectInfos


        $job0Id = $projectInfos.build.jobs[0].jobId;
        $job1Id = $projectInfos.build.jobs[1].jobId;

        echo "before arti."

        $artifacts = Invoke-RestMethod -Method Get -Uri "$apiUrl/buildjobs/$job0Id/artifacts" -Headers $headers

        $artifact0FileName = $artifacts[0].fileName;

        $artifacts = Invoke-RestMethod -Method Get -Uri "$apiUrl/buildjobs/$job1Id/artifacts" -Headers $headers

        $artifact1FileName = $artifacts[0].fileName;

        echo "create tmp folder"

        mkdir "C:\\tmp";

        Invoke-RestMethod -Method Get -Uri "$apiUrl/buildjobs/$job0Id/artifacts/$artifact0FileName" `
            -OutFile ("C:/tmp/" + $artifact0FileName) -Headers @{ "Authorization" = "Bearer $env:api_key" };
        Invoke-RestMethod -Method Get -Uri "$apiUrl/buildjobs/$job1Id/artifacts/$artifact1FileName" `
            -OutFile ("C:/tmp/" + $artifact1FileName) -Headers @{ "Authorization" = "Bearer $env:api_key" }
   
        mkdir ("C:\\tmp\\_" + $artifact0FileName);
        mkdir ("C:\\tmp\\_" + $artifact1FileName);

        Expand-Archive -LiteralPath C:/tmp/$artifact0FileName -DestinationPath ("C:/tmp/_" + $artifact0FileName);
        Expand-Archive -LiteralPath C:/tmp/$artifact1FileName -DestinationPath ("C:/tmp/_" + $artifact1FileName);

        Remove-Item -Path ("C:/tmp/" + $artifact0FileName);
        Remove-Item -Path ("C:/tmp/" + $artifact1FileName);

        Get-ChildItem -Recurse -Path C:/tmp/ -File | % {echo $_.FullName   };

        Get-ChildItem -Path "C:/tmp/" -File -Recurse | % { Copy-Item -Path $_.FullName -Destination ("./build/lib/" + $_.Name) };

        dotnet build ./NUGET/NetLib.LAPACK.csproj;

        $nupkg = ls  'C:\projects\lapack\NUGET\NetLib.LAPACK.*.nupkg';

        Push-AppveyorArtifact $nupkg;
    }
    catch 
    {
    
    }
    
    Set-Location $currentLoc;
}
