# ========================================
# 启动 Python AI 服务（PowerShell 版本）
# ========================================

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   启动 1/3：Python AI 服务 (端口 8765)" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Set-Location "D:\课设\new-course\smartspeech_optimized"

Write-Host "[1] 检查 Python 环境..." -ForegroundColor Yellow

# 优先使用虚拟环境
if (Test-Path ".venv\Scripts\python.exe") {
    Write-Host "✅ 找到虚拟环境，正在激活..." -ForegroundColor Green
    & ".venv\Scripts\Activate.ps1"
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ 虚拟环境激活失败" -ForegroundColor Red
        Read-Host "按回车键退出"
        exit 1
    }
    Write-Host "✅ 虚拟环境已激活: $env:VIRTUAL_ENV" -ForegroundColor Green
} elseif (Test-Path "D:\Work_Software\Anaconda3\envs\nlp_env\python.exe") {
    Write-Host "⚠️  未找到虚拟环境，使用 Anaconda 环境" -ForegroundColor Yellow
    $env:PATH = "D:\Work_Software\Anaconda3\envs\nlp_env;D:\Work_Software\Anaconda3\envs\nlp_env\Scripts;$env:PATH"
} else {
    Write-Host "⚠️  未找到虚拟环境，使用系统 Python" -ForegroundColor Yellow
    try {
        python --version | Out-Null
    } catch {
        Write-Host "❌ 未找到 Python，请先配置环境" -ForegroundColor Red
        Write-Host "运行: 配置Python环境.bat" -ForegroundColor Yellow
        Read-Host "按回车键退出"
        exit 1
    }
}

Write-Host ""
python --version

Write-Host ""
Write-Host "[2] 检查依赖..." -ForegroundColor Yellow
try {
    python -c "import flask" 2>$null
    Write-Host "✅ 依赖已安装" -ForegroundColor Green
} catch {
    Write-Host "⚠️  依赖未安装，正在安装..." -ForegroundColor Yellow
    pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple
}

Write-Host ""
Write-Host "[3] 检查配置文件..." -ForegroundColor Yellow
if (-not (Test-Path ".env")) {
    Write-Host "❌ 未找到 .env 配置文件" -ForegroundColor Red
    Write-Host "请复制 .env.example 为 .env 并配置 DEEPSEEK_API_KEY" -ForegroundColor Yellow
    Read-Host "按回车键退出"
    exit 1
}

Write-Host ""
Write-Host "[4] 启动 Python AI 服务..." -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Green
Write-Host "   服务地址: http://127.0.0.1:8765" -ForegroundColor Green
Write-Host "   按 Ctrl+C 可停止服务" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

python -m backend.run

Read-Host "按回车键退出"
