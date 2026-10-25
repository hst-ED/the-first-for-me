# 每天一步：提交并推送 AI 学习档案
# 由「提交.cmd」调用，不用直接运行这个文件

$repo = "C:\Users\HST\Documents\ai-lab-journal"
Set-Location $repo
$env:GIT_TERMINAL_PROMPT = "0"   # 避免卡在看不见的登录提示上

Write-Host ""
Write-Host "================= AI 学习档案 =================" -ForegroundColor Cyan
Write-Host ""

# ---------- 1) 看看今天有没有改动 ----------
git add -A
$changes = @(git status --porcelain | Where-Object { $_.Trim() })
$hasCommit = $false

if ($changes.Count -eq 0) {
    Write-Host "今天没有新改动。" -ForegroundColor Yellow
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
        Write-Host "提交失败 —— 把这个窗口截图发给我。" -ForegroundColor Red
        return
    }
    Write-Host ""
    Write-Host "已提交：$full" -ForegroundColor Green
    $hasCommit = $true
}

# ---------- 2) 先探测一下 GitHub 通不通 ----------
Write-Host ""
Write-Host "检查 GitHub 连接 ..." -ForegroundColor Cyan
$ok = $false
try {
    $client = New-Object System.Net.Sockets.TcpClient
    $ar = $client.BeginConnect("github.com", 443, $null, $null)
    if ($ar.AsyncWaitHandle.WaitOne(6000)) {
        $client.EndConnect($ar)
        $ok = $true
    }
    $client.Close()
} catch { $ok = $false }

if (-not $ok) {
    Write-Host ""
    Write-Host "连不上 github.com:443 —— 是网络的问题，不是你的操作。" -ForegroundColor Red
    Write-Host "解决办法：打开 Watt Toolkit → 选 GitHub → 一键加速，然后再双击一次本文件。" -ForegroundColor Red
    if ($hasCommit) {
        Write-Host ""
        Write-Host "（改动已经安全存在本地，网络好了再推一次就行，不会丢。）" -ForegroundColor Yellow
    }
    return
}

# ---------- 3) 推送 ----------
Write-Host "连接正常，正在推送 ..." -ForegroundColor Cyan
git push *> $null

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "完成！https://github.com/hst-ED/the-first-for-me" -ForegroundColor Green
}
else {
    Write-Host ""
    Write-Host "推送被拒 —— 可能是网络中途断了。开 Watt Toolkit 后再试一次。" -ForegroundColor Red
}
Write-Host ""
Write-Host "===============================================" -ForegroundColor Cyan
