$appDir = "D:\ds-2026-labs\Valuator"
$nginxDir = "D:\nginx"
$logsDir = "$nginxDir\logs"

if (!(Test-Path $logsDir)) { 
    New-Item -ItemType Directory -Path $logsDir -Force | Out-Null 
}

foreach ($port in 5001, 5002, 8080) {
    $proc = Get-NetTCPConnection -LocalPort $port -ErrorAction SilentlyContinue | Get-Process -ErrorAction SilentlyContinue
    if ($proc) { 
        Stop-Process -Id $proc.Id -Force -ErrorAction SilentlyContinue 
    }
}

Set-Location $appDir
Start-Process "dotnet" -ArgumentList "run", "--urls", "http://0.0.0.0:5001" -WindowStyle Hidden
Start-Process "dotnet" -ArgumentList "run", "--urls", "http://0.0.0.0:5002" -WindowStyle Hidden

Set-Location $nginxDir
Start-Process ".\nginx.exe" -ArgumentList "-p", "." -WindowStyle Hidden

Write-Host "Запущена: http://localhost:8080" -ForegroundColor Green
$Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") | Out-Null
