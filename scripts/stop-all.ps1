# 面试AI系统 - 一键停止脚本
# 该脚本会停止所有相关服务进程

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  面试AI系统 - 停止服务中..." -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$stopped = $false

# 停止Python进程
Write-Host "[1/2] 停止Python AI服务..." -ForegroundColor Yellow
$pythonProcesses = Get-Process python -ErrorAction SilentlyContinue | Where-Object {
    $_.CommandLine -like "*backend.run*"
}
if ($pythonProcesses) {
    $pythonProcesses | Stop-Process -Force
    Write-Host "✓ 已停止 $($pythonProcesses.Count) 个Python进程" -ForegroundColor Green
    $stopped = $true
} else {
    Write-Host "○ 未找到Python AI服务进程" -ForegroundColor Gray
}
Write-Host ""

# 停止Java/Maven进程
Write-Host "[2/2] 停止Spring Boot后端..." -ForegroundColor Yellow
$javaProcesses = Get-Process java -ErrorAction SilentlyContinue
if ($javaProcesses) {
    $javaProcesses | Stop-Process -Force
    Write-Host "✓ 已停止 $($javaProcesses.Count) 个Java进程" -ForegroundColor Green
    $stopped = $true
} else {
    Write-Host "○ 未找到Spring Boot进程" -ForegroundColor Gray
}
Write-Host ""

Write-Host "========================================" -ForegroundColor Cyan
if ($stopped) {
    Write-Host "  服务已停止！" -ForegroundColor Green
} else {
    Write-Host "  没有运行中的服务" -ForegroundColor Yellow
}
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "按任意键退出..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
