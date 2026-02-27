Write-Host "→ Запуск первого экземпляра Valuator на порту 5001..." -ForegroundColor Cyan
Start-Process dotnet -ArgumentList "run --project Valuator --urls http://0.0.0.0:5001" -NoNewWindow

Write-Host "→ Запуск второго экземпляра Valuator на порту 5002..." -ForegroundColor Cyan
Start-Process dotnet -ArgumentList "run --project Valuator --urls http://0.0.0.0:5002" -NoNewWindow

# Ждём, чтобы приложения успели запуститься
Start-Sleep -Seconds 3

Write-Host "→ Запуск Nginx на порту 8080..." -ForegroundColor Green
Start-Process nginx -ArgumentList "-c nginx/conf/nginx.conf" -WorkingDirectory ".."

Write-Host "`n✅ Система запущена! Откройте в браузере: http://localhost:8080" -ForegroundColor Green