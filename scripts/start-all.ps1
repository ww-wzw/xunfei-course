# 面试AI系统 - 一键启动脚本
# 该脚本会在独立窗口中启动所有服务

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  面试AI系统 - 启动中..." -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 设置项目根目录
$ROOT_DIR = "D:\课设\new-course"

# 检查目录是否存在
Write-Host "[1/4] 检查项目目录..." -ForegroundColor Yellow
if (-not (Test-Path "$ROOT_DIR\smartspeech_optimized")) {
    Write-Host "错误: Python AI服务目录不存在" -ForegroundColor Red
    exit 1
}
if (-not (Test-Path "$ROOT_DIR\interview-ai")) {
    Write-Host "错误: Spring Boot后端目录不存在" -ForegroundColor Red
    exit 1
}
Write-Host "✓ 目录检查完成" -ForegroundColor Green
Write-Host ""

# 启动Python AI服务
Write-Host "[2/4] 启动Python AI服务 (端口 8765)..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList @(
    "-NoExit",
    "-Command",
    "cd '$ROOT_DIR\smartspeech_optimized'; Write-Host '启动Python AI服务...' -ForegroundColor Cyan; python -m backend.run"
)
Write-Host "✓ Python AI服务窗口已打开" -ForegroundColor Green
Write-Host ""

# 等待Python服务启动
Write-Host "等待Python AI服务启动 (5秒)..." -ForegroundColor Gray
Start-Sleep -Seconds 5

# 启动Spring Boot后端
Write-Host "[3/4] 启动Spring Boot后端..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList @(
    "-NoExit",
    "-Command",
    "cd '$ROOT_DIR\interview-ai'; Write-Host '启动Spring Boot后端...' -ForegroundColor Cyan; .\mvnw.cmd spring-boot:run"
)
Write-Host "✓ Spring Boot后端窗口已打开" -ForegroundColor Green
Write-Host ""

# 等待Spring Boot启动
Write-Host "等待Spring Boot后端启动 (15秒)..." -ForegroundColor Gray
Start-Sleep -Seconds 15

# 打开浏览器
Write-Host "[4/4] 打开前端页面..." -ForegroundColor Yellow
Start-Process "http://localhost:5173"
Write-Host "✓ 浏览器已打开" -ForegroundColor Green
Write-Host ""

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  所有服务启动完成！" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "服务状态:" -ForegroundColor White
Write-Host "  - Python AI服务: http://127.0.0.1:8765" -ForegroundColor White
Write-Host "  - Spring Boot后端: 运行中" -ForegroundColor White
Write-Host "  - 前端界面: http://localhost:5173" -ForegroundColor White
Write-Host ""
Write-Host "提示: 关闭各个PowerShell窗口即可停止对应服务" -ForegroundColor Yellow
Write-Host "或运行 stop-all.ps1 停止所有服务" -ForegroundColor Yellow
Write-Host ""
Write-Host "按任意键退出此窗口..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
