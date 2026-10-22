# ========================================
# 多模态智能面试系统 - 一键启动脚本
# ========================================

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "   多模态智能面试系统 - 一键启动" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

Write-Host "本脚本将依次启动以下服务：" -ForegroundColor Yellow
Write-Host "  1. Redis 缓存服务 (端口 6379)"
Write-Host "  2. MinIO 对象存储 (端口 9000/9001)"
Write-Host "  3. Python AI 服务 (端口 8765)"
Write-Host "  4. Java 主后端 (端口 8080)"
Write-Host "  5. Vue 前端 (端口 5173)"
Write-Host ""
Write-Host "启动完成后将自动打开浏览器访问系统`n" -ForegroundColor Yellow

Read-Host "按回车键开始启动"

# ========================================
# 环境检查
# ========================================
Write-Host "`n[环境检查]" -ForegroundColor Cyan

# 检查 Python 虚拟环境
if (-not (Test-Path "D:\课设\new-course\smartspeech_optimized\.venv\Scripts\python.exe")) {
    Write-Host "  ❌ Python 虚拟环境不存在" -ForegroundColor Red
    Write-Host "  请先运行: 安装所有依赖.ps1" -ForegroundColor Yellow
    Read-Host "按回车键退出"
    exit 1
}
Write-Host "  ✅ Python 虚拟环境" -ForegroundColor Green

# 检查 Java
try {
    $javaHome = "C:\Program Files\Eclipse Adoptium\jdk-17.0.20.101-hotspot"
    if (Test-Path "$javaHome\bin\java.exe") {
        Write-Host "  ✅ Java 17" -ForegroundColor Green
    } else {
        throw "Java not found"
    }
} catch {
    Write-Host "  ❌ Java 17 未找到" -ForegroundColor Red
    Write-Host "  请检查 Java 安装路径" -ForegroundColor Yellow
    Read-Host "按回车键退出"
    exit 1
}

# 检查 Node.js
try {
    node --version | Out-Null
    Write-Host "  ✅ Node.js" -ForegroundColor Green
} catch {
    Write-Host "  ❌ Node.js 未安装" -ForegroundColor Red
    Read-Host "按回车键退出"
    exit 1
}

# 检查 MySQL
$mysqlRunning = Get-Process mysqld -ErrorAction SilentlyContinue
if ($mysqlRunning) {
    Write-Host "  ✅ MySQL 服务运行中" -ForegroundColor Green
} else {
    Write-Host "  ⚠️  MySQL 服务未运行" -ForegroundColor Yellow
    Write-Host "  系统可能无法正常启动，是否继续？(y/n)" -ForegroundColor Yellow
    $continue = Read-Host
    if ($continue -ne "y") {
        exit 0
    }
}

# 检查 Redis
$redisExe = "D:\课设\new-course\redis\redis-server.exe"
if (Test-Path $redisExe) {
    Write-Host "  ✅ Redis 已安装" -ForegroundColor Green
} else {
    Write-Host "  ⚠️  Redis 未安装（会话管理需要）" -ForegroundColor Yellow
}

# ========================================
# 检查端口占用
# ========================================
Write-Host "`n[端口检查]" -ForegroundColor Cyan

$ports = @{
    "6379" = "Redis"
    "9000" = "MinIO API"
    "9001" = "MinIO Console"
    "8765" = "Python AI"
    "8080" = "Java 后端"
    "5173" = "Vue 前端"
}

$hasConflict = $false
foreach ($port in $ports.Keys) {
    $conn = Get-NetTCPConnection -LocalPort $port -State Listen -ErrorAction SilentlyContinue
    if ($conn) {
        Write-Host "  ⚠️  端口 $port ($($ports[$port])) 已被占用 (PID: $($conn.OwningProcess | Select-Object -First 1))" -ForegroundColor Yellow
        $hasConflict = $true
    } else {
        Write-Host "  ✅ 端口 $port 可用" -ForegroundColor Green
    }
}

if ($hasConflict) {
    Write-Host "`n  是否关闭占用端口的进程并继续？(y/n)" -ForegroundColor Yellow
    $killProcess = Read-Host
    if ($killProcess -eq "y") {
        foreach ($port in $ports.Keys) {
            $conn = Get-NetTCPConnection -LocalPort $port -State Listen -ErrorAction SilentlyContinue
            if ($conn) {
                $pid = $conn.OwningProcess | Select-Object -First 1
                Write-Host "  终止进程 PID: $pid (端口 $port)" -ForegroundColor Yellow
                Stop-Process -Id $pid -Force -ErrorAction SilentlyContinue
            }
        }
        Start-Sleep -Seconds 2
    }
}

# ========================================
# 启动服务
# ========================================
Write-Host "`n[启动服务]" -ForegroundColor Cyan

# 1. 启动 Redis
Write-Host "`n[1/4] 启动 Redis 缓存服务..." -ForegroundColor Yellow
$redisExe = "D:\课设\new-course\redis\redis-server.exe"
if (Test-Path $redisExe) {
    Start-Process powershell -ArgumentList @(
        "-NoExit",
        "-Command",
        "cd 'D:\课设\new-course\redis'; " +
        "Write-Host '`n========================================' -ForegroundColor Cyan; " +
        "Write-Host '   Redis 缓存服务 (端口 6379)' -ForegroundColor Cyan; " +
        "Write-Host '========================================`n' -ForegroundColor Cyan; " +
        ".\redis-server.exe"
    ) -WindowStyle Normal

    Write-Host "  等待 Redis 初始化..." -ForegroundColor Gray
    Start-Sleep -Seconds 3

    # 验证 Redis
    $redisRunning = Get-NetTCPConnection -LocalPort 6379 -State Listen -ErrorAction SilentlyContinue
    if ($redisRunning) {
        Write-Host "  ✅ Redis 启动成功" -ForegroundColor Green
    } else {
        Write-Host "  ⚠️  Redis 可能未完全启动" -ForegroundColor Yellow
    }
} else {
    Write-Host "  ⚠️  Redis 未安装，跳过（登录功能可能不可用）" -ForegroundColor Yellow
}

# 2. 启动 MinIO 对象存储
Write-Host "`n[2/5] 启动 MinIO 对象存储..." -ForegroundColor Yellow
$minioExe = "D:\课设\new-course\minio\minio.exe"
if (Test-Path $minioExe) {
    Start-Process powershell -ArgumentList @(
        "-NoExit",
        "-Command",
        "cd 'D:\课设\new-course\minio'; " +
        "Write-Host '`n========================================' -ForegroundColor Cyan; " +
        "Write-Host '   MinIO 对象存储 (端口 9000/9001)' -ForegroundColor Cyan; " +
        "Write-Host '========================================`n' -ForegroundColor Cyan; " +
        ".\minio.exe server .\data --console-address ':9001'"
    ) -WindowStyle Normal

    Write-Host "  等待 MinIO 初始化..." -ForegroundColor Gray
    Start-Sleep -Seconds 5

    # 验证 MinIO
    $minioRunning = Get-NetTCPConnection -LocalPort 9000 -State Listen -ErrorAction SilentlyContinue
    if ($minioRunning) {
        Write-Host "  ✅ MinIO 启动成功" -ForegroundColor Green
    } else {
        Write-Host "  ⚠️  MinIO 可能未完全启动" -ForegroundColor Yellow
    }
} else {
    Write-Host "  ⚠️  MinIO 未安装，使用本地文件存储" -ForegroundColor Yellow
}

# 3. 启动 Python AI 服务
Write-Host "`n[3/5] 启动 Python AI 服务..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList @(
    "-NoExit",
    "-Command",
    "cd 'D:\课设\new-course\smartspeech_optimized'; " +
    ".venv\Scripts\Activate.ps1; " +
    "Write-Host '`n========================================' -ForegroundColor Cyan; " +
    "Write-Host '   Python AI 服务 (端口 8765)' -ForegroundColor Cyan; " +
    "Write-Host '========================================`n' -ForegroundColor Cyan; " +
    "python -m backend.run"
) -WindowStyle Normal

Write-Host "  等待 Python 服务初始化..." -ForegroundColor Gray
Start-Sleep -Seconds 10

# 验证 Python 服务
try {
    $response = Invoke-WebRequest -Uri "http://127.0.0.1:8765/api/ai/health" -TimeoutSec 5 -UseBasicParsing
    Write-Host "  ✅ Python AI 服务启动成功" -ForegroundColor Green
} catch {
    Write-Host "  ⚠️  Python AI 服务可能未完全启动，继续..." -ForegroundColor Yellow
}

# 2. 启动 Java 后端
Write-Host "`n[4/5] 启动 Java 后端..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList @(
    "-NoExit",
    "-Command",
    "`$env:JAVA_HOME = 'C:\Program Files\Eclipse Adoptium\jdk-17.0.20.101-hotspot'; " +
    "cd 'D:\课设\new-course\interview-ai\interview-bootstrap'; " +
    "Write-Host '`n========================================' -ForegroundColor Cyan; " +
    "Write-Host '   Java 后端 (端口 8080)' -ForegroundColor Cyan; " +
    "Write-Host '========================================`n' -ForegroundColor Cyan; " +
    "..\mvnw.cmd spring-boot:run"
) -WindowStyle Normal

Write-Host "  等待 Java 后端初始化..." -ForegroundColor Gray
Start-Sleep -Seconds 15

# 验证 Java 后端
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8080/api/scenarios" -TimeoutSec 5 -UseBasicParsing
    Write-Host "  ✅ Java 后端启动成功" -ForegroundColor Green
} catch {
    if ($_.Exception.Response.StatusCode.value__ -eq 401) {
        Write-Host "  ✅ Java 后端启动成功 (401 是预期响应)" -ForegroundColor Green
    } else {
        Write-Host "  ⚠️  Java 后端可能未完全启动，继续..." -ForegroundColor Yellow
    }
}

# 3. 启动 Vue 前端
Write-Host "`n[5/5] 启动 Vue 前端..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList @(
    "-NoExit",
    "-Command",
    "cd 'D:\课设\new-course\interview-ai\frontend'; " +
    "Write-Host '`n========================================' -ForegroundColor Cyan; " +
    "Write-Host '   Vue 前端 (端口 5173)' -ForegroundColor Cyan; " +
    "Write-Host '========================================`n' -ForegroundColor Cyan; " +
    "npm run dev"
) -WindowStyle Normal

Write-Host "  等待前端服务启动..." -ForegroundColor Gray
Start-Sleep -Seconds 8

# 验证前端
try {
    $response = Invoke-WebRequest -Uri "http://localhost:5173" -TimeoutSec 5 -UseBasicParsing
    Write-Host "  ✅ Vue 前端启动成功" -ForegroundColor Green
} catch {
    Write-Host "  ⚠️  Vue 前端可能未完全启动，请稍后手动访问" -ForegroundColor Yellow
}

# ========================================
# 启动完成
# ========================================
Write-Host "`n========================================" -ForegroundColor Green
Write-Host "   🎉 所有服务启动完成！" -ForegroundColor Green
Write-Host "========================================`n" -ForegroundColor Green

Write-Host "服务地址：" -ForegroundColor Yellow
Write-Host "  Python AI:  " -NoNewline
Write-Host "http://127.0.0.1:8765" -ForegroundColor Cyan
Write-Host "  Java 后端:  " -NoNewline
Write-Host "http://localhost:8080" -ForegroundColor Cyan
Write-Host "  Vue 前端:   " -NoNewline
Write-Host "http://localhost:5173" -ForegroundColor Cyan
Write-Host "  API 文档:   " -NoNewline
Write-Host "http://localhost:8080/doc.html" -ForegroundColor Cyan

Write-Host "`n测试账号：" -ForegroundColor Yellow
Write-Host "  管理员: " -NoNewline
Write-Host "admin / 123456" -ForegroundColor Green
Write-Host "  候选人: " -NoNewline
Write-Host "test01 / 123456" -ForegroundColor Green
Write-Host "  面试官: " -NoNewline
Write-Host "host01 / 123456" -ForegroundColor Green

Write-Host "`n[提示] 如需停止服务，请关闭对应的 PowerShell 窗口`n" -ForegroundColor Gray

# 打开浏览器
Write-Host "正在打开浏览器..." -ForegroundColor Cyan
Start-Sleep -Seconds 2
Start-Process "http://localhost:5173"

Write-Host "`n系统已就绪！" -ForegroundColor Green
Read-Host "`n按回车键关闭本窗口"
