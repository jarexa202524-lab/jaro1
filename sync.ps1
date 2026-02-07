# GAME DEBATE - Sync Script
Write-Host "Syncing..." -ForegroundColor Cyan
git add .
$date = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
git commit -m "Sync: Restore Verification ($date)"
git push origin main --force
Write-Host "Done! Refresh Vercel in 1-2 minutes." -ForegroundColor Green
