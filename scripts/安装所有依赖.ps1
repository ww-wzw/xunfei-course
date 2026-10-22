# ========================================
# 一键安装所有依赖（PowerShell 版本）
# ========================================

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   一键安装所有依赖（使用虚拟环境）" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "本脚本将依次安装："
Write-Host "  1. Python 依赖（虚拟环境）"
Write-Host "  2. Java Maven 依赖"
Write-Host "  3. Vue 前端依赖"
Write-Host ""
Write-Host "预计耗时：10-20 分钟（取决于网速）" -ForegroundColor Yellow
Write-Host ""
Read-Host "按回车键继续"

# ========================================
# 1. 安装 Python 依赖（使用虚拟环境）
# ========================================
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "[1/3] 配置 Python 虚拟环境..." -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

Set-Location "D:\课设\new-course\smartspeech_optimized"
Write-Host "当前目录: $PWD" -ForegroundColor Gray

# 检查 Python
try {
    $pythonVersion = python --version 2>&1
    Write-Host "✅ Python 已安装: $pythonVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Python 未安装！" -ForegroundColor Red
    Write-Host "请先安装 Python 3.10" -ForegroundColor Yellow
    Read-Host "按回车键退出"
    exit 1
}

# 检查虚拟环境
if (Test-Path ".venv\Scripts\python.exe") {
    Write-Host "✅ 找到现有虚拟环境" -ForegroundColor Green
    & ".venv\Scripts\Activate.ps1"
} else {
    Write-Host "创建虚拟环境..." -ForegroundColor Yellow
    python -m venv .venv
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ 虚拟环境创建失败" -ForegroundColor Red
        Read-Host "按回车键退出"
        exit 1
    }
    Write-Host "✅ 虚拟环境创建成功" -ForegroundColor Green
    & ".venv\Scripts\Activate.ps1"

    Write-Host ""
    Write-Host "升级 pip..." -ForegroundColor Yellow
    python -m pip install --upgrade pip
}

Write-Host ""
Write-Host "当前 Python 环境: $env:VIRTUAL_ENV" -ForegroundColor Gray
python --version

Write-Host ""
Write-Host "开始安装 Python 依赖..." -ForegroundColor Yellow
pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "⚠️  部分依赖安装失败，尝试单独安装关键包..." -ForegroundColor Yellow
    pip install flask flask-cors waitress -i https://pypi.tuna.tsinghua.edu.cn/simple
    pip install openai-whisper opencv-python mediapipe -i https://pypi.tuna.tsinghua.edu.cn/simple
    pip install edge-tts python-docx PyPDF2 -i https://pypi.tuna.tsinghua.edu.cn/simple
}

Write-Host ""
Write-Host "✅ Python 依赖安装完成" -ForegroundColor Green
Start-Sleep -Seconds 3

# 退出虚拟环境
deactivate

# ========================================
# 2. 安装 Java 依赖
# ========================================
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "[2/3] 安装 Java Maven 依赖..." -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

Set-Location "D:\课设\new-course\interview-ai"
Write-Host "当前目录: $PWD" -ForegroundColor Gray

# 检查 Java
try {
    $javaVersion = java -version 2>&1 | Select-Object -First 1
    Write-Host "✅ Java 已安装: $javaVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Java 未安装！" -ForegroundColor Red
    Write-Host "请先安装 Java 17" -ForegroundColor Yellow
    Read-Host "按回车键退出"
    exit 1
}

Write-Host ""
Write-Host "开始下载 Maven 依赖（首次执行会下载 Maven，请耐心等待）..." -ForegroundColor Yellow
.\mvnw.cmd clean install -DskipTests

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "❌ Maven 依赖下载失败！" -ForegroundColor Red
    Write-Host "可能的原因：" -ForegroundColor Yellow
    Write-Host "  1. 网络连接问题"
    Write-Host "  2. Maven 仓库访问失败"
    Write-Host "  3. pom.xml 配置错误"
    Read-Host "按回车键退出"
    exit 1
}

Write-Host ""
Write-Host "✅ Java 依赖安装完成" -ForegroundColor Green
Start-Sleep -Seconds 3

# ========================================
# 3. 安装前端依赖
# ========================================
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "[3/3] 安装 Vue 前端依赖..." -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

Set-Location "D:\课设\new-course\interview-ai\frontend"
Write-Host "当前目录: $PWD" -ForegroundColor Gray

# 检查 Node.js
try {
    $nodeVersion = node --version
    Write-Host "✅ Node.js 已安装: $nodeVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Node.js 未安装！" -ForegroundColor Red
    Write-Host "请先安装 Node.js 20+" -ForegroundColor Yellow
    Read-Host "按回车键退出"
    exit 1
}

Write-Host ""
Write-Host "开始安装前端依赖..." -ForegroundColor Yellow
npm install

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "⚠️  npm install 失败，尝试清理缓存重试..." -ForegroundColor Yellow
    npm cache clean --force
    npm install
}

Write-Host ""
Write-Host "✅ 前端依赖安装完成" -ForegroundColor Green

# ========================================
# 完成
# ========================================
Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "   所有依赖安装完成！" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "✅ Python 虚拟环境: smartspeech_optimized\.venv" -ForegroundColor Green
Write-Host "✅ Java 依赖: 已下载" -ForegroundColor Green
Write-Host "✅ 前端依赖: 已安装" -ForegroundColor Green
Write-Host ""
Write-Host "下一步：" -ForegroundColor Cyan
Write-Host "  1. 配置 MySQL 数据库"
Write-Host '     运行: mysql -u root -p < sql/interview_ai.sql'
Write-Host ""
Write-Host "  2. 检查配置文件"
Write-Host "     - smartspeech_optimized\.env (DeepSeek API Key)"
Write-Host "     - interview-ai\...application-dev.yml (数据库密码)"
Write-Host ""
Write-Host "  3. 运行环境检查"
Write-Host "     双击: 0-环境检查.bat"
Write-Host ""
Write-Host "  4. 启动系统"
Write-Host "     双击: 一键启动所有服务.bat"
Write-Host ""
Read-Host "按回车键退出"
