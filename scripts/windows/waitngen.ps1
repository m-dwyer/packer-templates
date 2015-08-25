# Basic script to wait for .NET runtime optimization to start and then complete
Function Get-NgenStatus
{
    $statusMessage = "The .NET Runtime Optimization Service is"
    $netVersion =  [Environment]::Version.Major, [Environment]::version.Minor, [Environment]::Version.Build -join "."
    $ngenStatus = &C:\Windows\Microsoft.NET\Framework64\v$netversion\ngen.exe queue status
    $match = [regex]::match($ngenStatus, "$statusMessage ([a-z]+).")
    
    return $match.Groups[1].Value   
}

$pollingSec = 5
$timeoutStartSec = 300
$timeoutFinishSec = 900

# Wait for ngen to start
$ngenStarted = $false

Write-Host "Waiting for ngen.exe to start ($timeoutStartSec second timeout)..."
while ($timeoutStartSec -gt 0)
{
    $ngenStatus = Get-NgenStatus

    if ($ngenStatus -eq "running")
    {
        $ngenStarted = $true
        break
    }

    Start-Sleep -Seconds $pollingSec
    $timeoutStartSec -= $pollingSec
}

if ($ngenStarted -eq $true)
{
    Write-Host "ngen.exe has started!"
}
else
{
    Write-Host "Timed out waiting for ngen.exe to start..."
}

# Wait for ngen to complete
$ngenCompleted = $false

Write-Host "Waiting for ngen.exe worker processes to complete ($timeoutFinishSec second timeout)..."
while ($timeoutFinishSec -gt 0)
{
    $ngenTask = Get-Process -Name "ngentask" -ErrorAction SilentlyContinue
    $ngenStatus = Get-NgenStatus

    if ($ngenTask -eq $null -and $ngenStatus -eq "stopped")
    {
        $ngenCompleted = $true
        break
    }

    Start-Sleep -Seconds $pollingSec
    $timeoutFinishSec -= $pollingSec
}

if ($ngenCompleted -eq $true)
{
    Write-Host "ngen.exe worker processes completed!"
}
else
{
    Write-Host "Timed out waiting for ngen.exe worker processes to complete..."
}

