$nginxPath = "D:\nginx\nginx.exe"

if (Test-Path $nginxPath) { Start-Process $nginxPath -ArgumentList "-s","stop" -WindowStyle Hidden -ErrorAction SilentlyContinue }
Stop-Process -Name "nginx" -Force -ErrorAction SilentlyContinue

foreach ($port in 5001, 5002, 5003, 5004) {
    $conn = Get-NetTCPConnection -LocalPort $port -ErrorAction SilentlyContinue
    if ($conn) {
        Stop-Process -Id $conn.OwningProcess -Force -ErrorAction SilentlyContinue
    }
}

Get-Process -Name "dotnet" -ErrorAction SilentlyContinue | 
    Where-Object { $_.Path -like "*Valuator*" } | 
    Stop-Process -Force -ErrorAction SilentlyContinue

Write-Host "Остановлено" -ForegroundColor Green
$Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") | Out-Null