# 每天一步：提交并推送 AI 学习档案
# 由「提交.cmd」调用，不用直接运行这个文件

$repo = "C:\Users\HST\Documents\ai-lab-journal"
Set-Location $repo

Write-Host ""
Write-Host "================= AI 学习档案 =================" -ForegroundColor Cyan
Write-Host ""

# 1) 看看今天有没有改动
git add -A
$changes = @(git status --porcelain | Where-Object { $_.Trim() })

if ($changes.Count -eq 0) {
    Write-Host "没有检测到改动 —— 今天还没写东西。" -ForegroundColor Yellow
    Write-Host "去 notes\ 里写三行，或者继续填一个提示词案例。" -ForegroundColor Yellow
}
else {
    Write-Host "检测到 $($changes.Count) 处改动：" -ForegroundColor Gray
    $changes | Select-Object -First 12 | ForEach-Object {
        Write-Host "    $_" -ForegroundColor DarkGray
    }
    if ($changes.Count -gt 12) {
        Write-Host "    …… 还有 $($changes.Count - 12) 处" -ForegroundColor DarkGray
    }

    Write-Host ""
    Write-Host "用一句话说明今天做了什么（直接回车 = 只记日期）"
    $msg = Read-Host "  备注"
    if ([string]::IsNullOrWhiteSpace($msg)) { $msg = "打卡" }

    $full = (Get-Date -Format "MM-dd") + " " + $msg

    git commit -q -m $full
    if ($LASTEXITCODE -ne 0) {
        Write-Host ""
        Write-Host "提交失败，把窗口截图发给我。" -ForegroundColor Red
        return
    }
    Write-Host ""
    Write-Host "已提交：$full" -ForegroundColor Green
}

# 2) 推送
Write-Host ""
Write-Host "正在推送到 GitHub ..." -ForegroundColor Cyan
git push *> $null

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "完成！https://github.com/hst-ED/the-first-for-me" -ForegroundColor Green
}
else {
    Write-Host ""
    Write-Host "推送失败 —— 九成是网络。" -ForegroundColor Red
    Write-Host "开一下 Watt Toolkit 的 GitHub 加速，然后再双击一次本文件。" -ForegroundColor Red
}
Write-Host ""
Write-Host "===============================================" -ForegroundColor Cyan
