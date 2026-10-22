# 重新创建虚拟环境并安装依赖

Write-Host "`n========== 重新创建 Python 虚拟环境 ==========" -ForegroundColor Cyan

# 进入项目目录
Set-Location "D:\课设\new-course\smartspeech_optimized"
Write-Host "当前目录: $PWD`n" -ForegroundColor Gray

# 删除旧虚拟环境
if (Test-Path ".venv") {
    Write-Host "删除旧虚拟环境..." -ForegroundColor Yellow
    Remove-Item -Recurse -Force .venv
}

# 创建新虚拟环境
Write-Host "创建虚拟环境..." -ForegroundColor Yellow
python -m venv .venv

if (-not (Test-Path ".venv\Scripts\python.exe")) {
    Write-Host "❌ 虚拟环境创建失败！" -ForegroundColor Red
    Read-Host "按回车键退出"
    exit 1
}

Write-Host "✅ 虚拟环境创建成功`n" -ForegroundColor Green

# 激活虚拟环境
Write-Host "激活虚拟环境..." -ForegroundColor Yellow
& ".venv\Scripts\Activate.ps1"

# 升级 pip
Write-Host "`n升级 pip..." -ForegroundColor Yellow
python -m pip install --upgrade pip

# 安装依赖
Write-Host "`n安装 Python 依赖（需要 3-5 分钟）..." -ForegroundColor Yellow
python -m pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n✅ 依赖安装成功！" -ForegroundColor Green

    # 验证
    Write-Host "`n验证关键依赖..." -ForegroundColor Yellow
    python -c "import flask; import whisper; import cv2; import mediapipe; print('✅ 所有依赖可用')"

} else {
    Write-Host "`n❌ 部分依赖安装失败" -ForegroundColor Red
    Write-Host "尝试单独安装关键包..." -ForegroundColor Yellow

    python -m pip install flask flask-cors waitress -i https://pypi.tuna.tsinghua.edu.cn/simple
    python -m pip install openai-whisper opencv-python mediapipe -i https://pypi.tuna.tsinghua.edu.cn/simple
    python -m pip install edge-tts python-docx PyPDF2 -i https://pypi.tuna.tsinghua.edu.cn/simple
}

Write-Host "`n========== 完成 ==========" -ForegroundColor Green
Write-Host "虚拟环境路径: D:\课设\new-course\smartspeech_optimized\.venv" -ForegroundColor Cyan
Write-Host "Python 路径: .venv\Scripts\python.exe" -ForegroundColor Cyan

Read-Host "`n按回车键退出"
