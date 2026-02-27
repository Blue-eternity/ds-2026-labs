Write-Host "→ Остановка экземпляров Valuator..." -ForegroundColor Cyan

# Останавливаем все dotnet-процессы, связанные с Valuator
Get-Process | Where-Object {
    $_.ProcessName -eq "dotnet" -and 
    $_.Path -like "*Valuator*"
} | Stop-Process -Force -ErrorAction SilentlyContinue

Write-Host "→ Остановка Nginx..." -ForegroundColor Green

# Останавливаем процесс nginx
Stop-Process -Name nginx -Force -ErrorAction SilentlyContinue

Write-Host "`n✅ Все компоненты остановлены." -ForegroundColor Green