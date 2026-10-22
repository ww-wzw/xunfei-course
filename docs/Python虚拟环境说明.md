# Python 虚拟环境说明

## 🤔 为什么需要虚拟环境？

虚拟环境（Virtual Environment）是 Python 的最佳实践，它可以：

1. **隔离依赖**：不同项目使用不同版本的包，互不干扰
2. **避免冲突**：系统 Python 和项目 Python 分开管理
3. **易于管理**：所有依赖都在项目目录内，清理方便
4. **团队协作**：保证所有人使用相同的依赖版本

---

## 📦 本项目的环境方案

### 方案对比

| 方案 | 优点 | 缺点 | 推荐度 |
|------|------|------|--------|
| **虚拟环境 .venv** | 依赖隔离、易管理 | 需要安装依赖 | ⭐⭐⭐⭐⭐ |
| **Anaconda nlp_env** | 可能已有依赖 | 与其他项目共享 | ⭐⭐⭐ |
| **系统 Python** | 无需配置 | 容易冲突 | ⭐ |

---

## 🛠️ 如何配置虚拟环境？

### 方式一：使用配置向导（推荐）

```bash
双击运行：配置Python环境.bat
```

会提供 3 个选项：
1. **使用项目虚拟环境**（推荐）
2. 使用 Anaconda 环境
3. 创建新的虚拟环境

---

### 方式二：手动配置

#### 1. 检查是否已有虚拟环境

```bash
cd D:\课设\new-course\smartspeech_optimized
dir .venv
```

如果存在 `.venv` 目录，说明虚拟环境已创建。

---

#### 2. 创建虚拟环境（如果不存在）

```bash
# 在项目根目录执行
python -m venv .venv
```

---

#### 3. 激活虚拟环境

**Windows：**
```bash
.venv\Scripts\activate.bat
```

**激活成功标志：**
命令行前面会显示 `(.venv)`

```
(.venv) D:\课设\new-course\smartspeech_optimized>
```

---

#### 4. 安装依赖

```bash
# 确保虚拟环境已激活
pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple
```

---

#### 5. 验证安装

```bash
python -c "import flask; import whisper; import cv2; print('依赖安装成功！')"
```

---

## 🚀 启动时的环境选择

### 自动检测（推荐）

新版的 `1-启动Python服务.bat` 会自动检测：
1. 优先使用 `.venv` 虚拟环境
2. 其次使用 Anaconda `nlp_env`
3. 最后使用系统 Python

---

### 手动指定

如果需要手动指定环境：

**使用虚拟环境：**
```bash
cd smartspeech_optimized
.venv\Scripts\activate.bat
python -m backend.run
```

**使用 Anaconda：**
```bash
cd smartspeech_optimized
D:\Work_Software\Anaconda3\envs\nlp_env\python.exe -m backend.run
```

**使用系统 Python：**
```bash
cd smartspeech_optimized
python -m backend.run
```

---

## 🔍 常见问题

### Q1: 虚拟环境激活失败

**错误信息：**
```
无法加载文件 .venv\Scripts\Activate.ps1，因为在此系统上禁止运行脚本。
```

**解决方案：**
使用 `.bat` 文件而不是 `.ps1`：
```bash
.venv\Scripts\activate.bat
```

或者在 PowerShell 中允许脚本执行：
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

---

### Q2: 虚拟环境中找不到某个包

**检查是否激活：**
```bash
# 命令行前面应该有 (.venv)
(.venv) D:\课设\new-course\smartspeech_optimized>
```

**重新安装：**
```bash
pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple
```

---

### Q3: 想删除虚拟环境重新创建

**删除虚拟环境：**
```bash
# 先退出虚拟环境
deactivate

# 删除 .venv 目录
rmdir /s .venv
```

**重新创建：**
```bash
python -m venv .venv
.venv\Scripts\activate.bat
pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple
```

---

### Q4: 虚拟环境占用空间太大

虚拟环境通常会占用 1-2GB 空间（包括所有依赖）。

**如果空间不够：**
- 清理不用的依赖包
- 使用 Anaconda 环境（多个项目共享）
- 清理 pip 缓存：
  ```bash
  pip cache purge
  ```

---

## 📊 虚拟环境 vs Anaconda

| 特性 | 虚拟环境 (.venv) | Anaconda (nlp_env) |
|------|------------------|-------------------|
| 依赖隔离 | ✅ 完全隔离 | ⚠️ 与其他项目共享 |
| 安装速度 | ⚡ 快 | 🐢 慢（包含科学计算包） |
| 磁盘占用 | 💾 小（约 1GB） | 💾 大（约 3-5GB） |
| 团队协作 | ✅ 易于复现 | ⚠️ 需要相同配置 |
| 推荐场景 | 📦 单个项目 | 🔬 多个项目共享 |

---

## ✅ 最佳实践建议

1. **使用虚拟环境**：每个项目独立的 `.venv`
2. **不要提交到 Git**：`.venv` 已在 `.gitignore` 中
3. **使用 requirements.txt**：记录依赖版本
4. **激活后再安装**：确保依赖安装到虚拟环境
5. **定期清理**：不用的虚拟环境可以删除

---

## 🎯 快速操作清单

```bash
# 创建虚拟环境
python -m venv .venv

# 激活虚拟环境
.venv\Scripts\activate.bat

# 安装依赖
pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple

# 运行项目
python -m backend.run

# 退出虚拟环境
deactivate
```

---

## 📚 更多资源

- [Python 虚拟环境官方文档](https://docs.python.org/zh-cn/3/library/venv.html)
- [Anaconda 环境管理](https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html)
- [pip 镜像源配置](https://mirrors.tuna.tsinghua.edu.cn/help/pypi/)
