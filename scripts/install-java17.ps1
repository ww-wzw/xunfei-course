# Java 17 自动安装脚本
# 使用winget安装Eclipse Temurin 17

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Java 17 自动安装" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "正在安装 Eclipse Temurin JDK 17..." -ForegroundColor Yellow
Write-Host "这可能需要几分钟时间..." -ForegroundColor Gray
Write-Host ""

# 使用winget安装Java 17
# --accept-source-agreements: 自动接受协议
# --accept-package-agreements: 自动接受包协议
# --silent: 静默安装
winget install --id EclipseAdoptium.Temurin.17.JDK --accept-source-agreements --accept-package-agreements --silent

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "  Java 17 安装成功！" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""

    # 检测安装路径
    $possiblePaths = @(
        "C:\Program Files\Eclipse Adoptium\jdk-17*",
        "C:\Program Files\Java\jdk-17*"
    )

    $javaPath = $null
    foreach ($path in $possiblePaths) {
        $found = Get-Item $path -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($found) {
            $javaPath = $found.FullName
            break
        }
    }

    if ($javaPath) {
        Write-Host "Java 17 安装位置: $javaPath" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "正在更新启动脚本..." -ForegroundColor Yellow

        # 更新start-all-java17.bat中的路径
        $batFile = "D:\课设\new-course\start-all-java17.bat"
        if (Test-Path $batFile) {
            $content = Get-Content $batFile -Raw
            $content = $content -replace 'set JAVA17_HOME=.*', "set JAVA17_HOME=$javaPath"
            Set-Content $batFile $content -Encoding UTF8
            Write-Host "[OK] 启动脚本已更新" -ForegroundColor Green
        }
    }

    Write-Host ""
    Write-Host "下一步: 运行 start-all-java17.bat 启动项目" -ForegroundColor Yellow
    Write-Host ""

} else {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Red
    Write-Host "  安装失败" -ForegroundColor Red
    Write-Host "========================================" -ForegroundColor Red
    Write-Host ""
    Write-Host "请尝试手动安装:" -ForegroundColor Yellow
    Write-Host "1. 访问 https://adoptium.net/zh-CN/temurin/releases/?version=17" -ForegroundColor White
    Write-Host "2. 下载 Windows x64 .msi 安装包" -ForegroundColor White
    Write-Host "3. 运行安装程序" -ForegroundColor White
    Write-Host ""
}

Write-Host "按任意键继续..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
