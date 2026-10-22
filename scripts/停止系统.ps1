# ========================================
# 停止所有服务
# ========================================

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "   停止多模态智能面试系统" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

Write-Host "本脚本将停止以下服务：" -ForegroundColor Yellow
Write-Host "  - Python AI 服务 (端口 8765)"
Write-Host "  - Java 后端 (端口 8080)"
Write-Host "  - Vue 前端 (端口 5173)"
Write-Host ""

$confirm = Read-Host "确认停止所有服务？(y/n)"
if ($confirm -ne "y") {
    Write-Host "已取消" -ForegroundColor Gray
    exit 0
}

# ========================================
# 查找并停止服务
# ========================================
Write-Host "`n[停止服务]" -ForegroundColor Cyan

$ports = @{
    "8765" = "Python AI 服务"
    "8080" = "Java 后端"
    "5173" = "Vue 前端"
}

$stoppedCount = 0
foreach ($port in $ports.Keys) {
    $conn = Get-NetTCPConnection -LocalPort $port -State Listen -ErrorAction SilentlyContinue
    if ($conn) {
        $pid = $conn.OwningProcess | Select-Object -First 1
        $processName = (Get-Process -Id $pid -ErrorAction SilentlyContinue).ProcessName

        Write-Host "  停止 $($ports[$port]) (PID: $pid, 进程: $processName)..." -ForegroundColor Yellow

        try {
            Stop-Process -Id $pid -Force
            Write-Host "    ✅ 已停止" -ForegroundColor Green
            $stoppedCount++
        } catch {
            Write-Host "    ❌ 停止失败: $($_.Exception.Message)" -ForegroundColor Red
        }
    } else {
        Write-Host "  ⚪ $($ports[$port]) 未运行" -ForegroundColor Gray
    }
}

# ========================================
# 完成
# ========================================
Write-Host "`n========================================" -ForegroundColor Green
Write-Host "   操作完成" -ForegroundColor Green
Write-Host "========================================`n" -ForegroundColor Green

Write-Host "已停止 $stoppedCount 个服务`n" -ForegroundColor Cyan

Read-Host "按回车键退出"
