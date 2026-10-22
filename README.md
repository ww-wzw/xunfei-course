# 多模态智能模拟面试评测平台

> **课程设计项目** - 人工智能Ⅱ方向 - 软件工程行业案例分析与实现

[![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.5.16-brightgreen.svg)](https://spring.io/projects/spring-boot)
[![Vue.js](https://img.shields.io/badge/Vue.js-3.x-blue.svg)](https://vuejs.org/)
[![Python](https://img.shields.io/badge/Python-3.10-yellow.svg)](https://www.python.org/)

---

## 📖 项目简介

基于 **Spring Boot 3 + Vue 3 + Python AI** 的多模态智能面试评测系统，整合了语音识别、视觉分析和大模型技术，为求职者提供真实的 AI 模拟面试体验。

### 核心功能

- ✅ **语音分析**（感知模块1）：实时语音转文字、内容质量评估
- ✅ **视觉行为分析**（感知模块2）：面部表情识别、眼神注意力检测
- ✅ **大模型面试官**（扩展能力）：智能问题生成、简历解析、回答评价
- ✅ **融合评分引擎**：综合评分算法 = 语音内容(60%) + 视觉行为(40%)
- ✅ **可追溯评测报告**：完整记录面试过程和评分依据

---

## 🏗️ 系统架构

```
┌─────────────────────────────────────────────────┐
│          浏览器 (http://localhost:5173)          │
└────────────────┬────────────────────────────────┘
                 │
                 ↓ HTTP
┌─────────────────────────────────────────────────┐
│          Vue 3 前端 (端口 5173)                  │
│  - Element Plus UI                              │
│  - Pinia 状态管理                               │
│  - Axios HTTP 客户端                            │
└────────────────┬────────────────────────────────┘
                 │
                 ↓ REST API
┌─────────────────────────────────────────────────┐
│       Java 后端 (端口 8080)                      │
│  - Spring Boot 3 + Spring Security              │
│  - MyBatis-Plus + MySQL                         │
│  - JWT 认证 + Redis 会话                        │
│  - MinIO 文件存储                               │
└────────────────┬────────────────────────────────┘
                 │
                 ↓ HTTP 调用
┌─────────────────────────────────────────────────┐
│      Python AI 服务 (端口 8765)                  │
│  - Flask + Waitress                             │
│  - Whisper ASR (语音识别)                        │
│  - Edge-TTS (语音合成)                          │
│  - MediaPipe (视觉分析)                          │
│  - DeepSeek (大模型)                             │
│  - 简历解析 + 评分引擎                           │
└─────────────────────────────────────────────────┘

辅助服务：
├─ Redis (6379)        - 用户会话存储（必需）
├─ MinIO (9000/9001)   - 对象存储（文件/视频）
└─ MySQL (3306)        - 业务数据存储
```

---

## 🚀 快速启动

### 方式一：一键启动（推荐）

**双击运行根目录的：**
```
启动系统.bat
```

脚本会自动打开 5 个窗口并按顺序启动所有服务（Redis、MinIO、Python AI、Java、Vue）。

> 💡 更多启动方式请查看 [scripts/README.md](scripts/README.md)

---

### 方式二：手动启动

**启动顺序很重要！必须按以下顺序启动：**

#### 窗口 1：启动 Redis

```powershell
cd redis
.\redis-server.exe
```

**等待显示：** `Ready to accept connections`

---

#### 窗口 2：启动 MinIO

```powershell
cd minio
.\minio.exe server .\data --console-address ":9001"
```

**等待显示：** `MinIO Object Storage Server`  
**控制台：** http://localhost:9001 (minioadmin / minioadmin)

---

#### 窗口 3：启动 Python AI 服务

```powershell
cd smartspeech_optimized
.venv\Scripts\Activate.ps1
python -m backend.run
```

**等待显示：** `智能体模拟面试系统 正在启动：http://127.0.0.1:8765`

---

#### 窗口 4：启动 Java 后端

```powershell
# 设置 JAVA_HOME（重要！）
$env:JAVA_HOME = "C:\Program Files\Eclipse Adoptium\jdk-17.0.20.101-hotspot"

cd interview-ai\interview-bootstrap
..\mvnw.cmd spring-boot:run
```

**等待显示：** `Started InterviewAiApplication in X.XXX seconds`

---

#### 窗口 5：启动 Vue 前端

```powershell
cd interview-ai\frontend
npm run dev
```

**等待显示：** `Local: http://localhost:5173/`

---

### 访问系统

浏览器打开：**http://localhost:5173**

**测试账号：**
- 管理员：`admin` / `admin123`
- 候选人：`test01` / `test0123`
- 面试官：`host01` / `host0123`

> 💡 所有密码均符合系统规则：**6-30位，必须包含字母和数字**

**API 文档：** http://localhost:8080/doc.html

---

## 📦 环境配置（首次使用）

### 环境要求

| 组件 | 版本要求 | 说明 |
|------|---------|------|
| **Java** | 17+ | OpenJDK 或 Eclipse Adoptium |
| **Python** | 3.10 | 推荐使用虚拟环境 |
| **Node.js** | 20+ | 包含 npm |
| **MySQL** | 8.0+ | 数据库 |
| **Redis** | 5.0+ | 会话存储（必需） |
| **MinIO** | 2023+ | 对象存储（已包含） |

---

### 一键安装依赖

**运行：**
```powershell
.\scripts\安装所有依赖.ps1
```

或手动执行：

```powershell
# 1. 配置 Python 虚拟环境
cd smartspeech_optimized
python -m venv .venv
.venv\Scripts\Activate.ps1
pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple

# 2. 安装 Java 依赖
cd ..\interview-ai
$env:JAVA_HOME = "C:\Program Files\Eclipse Adoptium\jdk-17.0.20.101-hotspot"
.\mvnw.cmd clean install -DskipTests

# 3. 安装前端依赖
cd frontend
npm install
```

---

### 配置数据库

```bash
# 1. 登录 MySQL
mysql -u root -p

# 2. 创建数据库并导入数据
CREATE DATABASE interview_ai DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE interview_ai;
SOURCE D:/课设/new-course/interview-ai/sql/interview_ai.sql;
SOURCE D:/课设/new-course/interview-ai/sql/interview_ai_audio_video_delta.sql;
SOURCE D:/课设/new-course/interview-ai/sql/interview_ai_vision_delta.sql;
SOURCE D:/课设/new-course/interview-ai/sql/interview_ai_state_delta.sql;
SOURCE D:/课设/new-course/interview-ai/sql/interview_transcript_delta.sql;
exit;
```

---

### 配置文件

#### Python AI 服务配置

文件：`smartspeech_optimized/.env`

```ini
# DeepSeek API 配置
DEEPSEEK_API_KEY=sk-your-api-key-here
DEEPSEEK_API_URL=https://api.deepseek.com/chat/completions
DEEPSEEK_MODEL=deepseek-chat

# 服务配置
APP_HOST=127.0.0.1
APP_PORT=8765

# AI 模型配置
WHISPER_MODEL_SIZE=small  # 可选: tiny/base/small/medium/large
WHISPER_DEVICE=cpu
DEFAULT_TTS_VOICE=zh-CN-YunxiNeural
```

**Whisper 模型下载：**

首次运行时会自动下载模型（约 500 MB），可能需要几分钟。

也可以提前下载：
```powershell
cd smartspeech_optimized
.venv\Scripts\Activate.ps1
python download_whisper_model.py
```

模型大小对比：
- `tiny` - 75 MB（最快，准确度较低）
- `base` - 150 MB（较快）
- `small` - 500 MB（**推荐，平衡速度和准确度**）
- `medium` - 1.5 GB（准确度高）
- `large` - 3 GB（最准确，最慢）

---

#### Java 后端配置

文件：`interview-ai/interview-bootstrap/src/main/resources/application-dev.yml`

```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/interview_ai
    username: root
    password: 422529  # 修改为你的 MySQL 密码

app:
  ai:
    base-url: http://127.0.0.1:8765  # Python AI 服务地址
```

---

## 🧪 功能测试

### 1. 用户登录
- 使用 `admin/admin123` 登录系统
- 验证 JWT Token 正确返回

### 2. 简历上传
- 上传 PDF/DOCX 简历
- 验证 AI 解析结果（姓名、技能、项目）

### 3. 创建面试
- 选择面试场景（Java后端工程师）
- 验证面试记录创建成功

### 4. AI 面试
- 开启摄像头和麦克风
- 测试语音识别（Whisper）
- 测试视觉分析（MediaPipe）
- 测试大模型问答（DeepSeek）

### 5. 评测报告
- 查看综合评分
- 验证评分公式：语音(60%) + 视觉(40%)
- 检查数据可追溯性

---

## 📊 评分规则

```
最终得分 = 语音内容得分 × 60% + 视觉行为得分 × 40%

视觉行为得分 = 表情得分 × 50% + 注意力得分 × 50%
```

### 评分维度

| 维度 | 权重 | 说明 |
|------|------|------|
| 语音内容 | 60% | AI 评估回答的完整性、准确性、逻辑性 |
| 面部表情 | 20% | 表情自然度、自信程度 |
| 眼神注意力 | 20% | 视线稳定性、专注程度 |

---

## 📂 项目结构

```
new-course/
├── interview-ai/                    # Java 主项目
│   ├── interview-bootstrap/         # Spring Boot 启动模块
│   ├── interview-common/            # 公共模块（安全、异常、工具）
│   ├── interview-modules/           # 业务模块
│   │   ├── interview-system/        # 用户权限模块
│   │   ├── interview-question/      # 题库模块
│   │   ├── interview-interview/     # 面试模块
│   │   ├── interview-resume/        # 简历模块
│   │   └── interview-file/          # 文件模块
│   ├── frontend/                    # Vue 3 前端
│   └── sql/                         # 数据库脚本
│
├── smartspeech_optimized/           # Python AI 服务
│   ├── backend/
│   │   ├── app/api/                 # Flask API 接口
│   │   └── app/services/            # AI 服务
│   │       ├── asr_service.py       # Whisper 语音识别
│   │       ├── tts_service.py       # Edge-TTS 语音合成
│   │       ├── deepseek_service.py  # 大模型调用
│   │       ├── resume_service.py    # 简历解析
│   │       └── vision/              # MediaPipe 视觉分析
│   └── .venv/                       # Python 虚拟环境
│
├── 启动系统.bat                      # 一键启动脚本
├── 安装所有依赖.ps1                  # 依赖安装脚本
├── 快速启动指南.md                   # 启动说明文档
└── README.md                        # 本文件
```

---

---

## 📚 文档导航

- **[快速启动指南](docs/快速启动指南.md)** - 精简启动步骤
- **[环境配置指南](docs/环境配置指南.md)** - 详细配置说明
- **[启动脚本说明](docs/启动脚本使用说明.md)** - 脚本使用方法
- **[文档索引](docs/文档索引.md)** - 完整文档导航
- **[脚本目录](scripts/README.md)** - 所有启动脚本

---

## 🔧 常见问题

### Q1: Java 后端启动失败 - Java 版本错误

**错误信息：**
```
class file version 61.0, this version only recognizes class file versions up to 52.0
```

**解决方案：**
```powershell
# 设置 JAVA_HOME 为 Java 17
$env:JAVA_HOME = "C:\Program Files\Eclipse Adoptium\jdk-17.0.20.101-hotspot"

# 验证
& "$env:JAVA_HOME\bin\java.exe" -version
```

---

### Q2: Python 虚拟环境路径错误

**错误信息：**
```
Fatal error in launcher: Unable to create process using '...'
```

**解决方案：**
```powershell
# 删除旧虚拟环境
cd smartspeech_optimized
Remove-Item -Recurse -Force .venv

# 重新创建
python -m venv .venv
.venv\Scripts\Activate.ps1
pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple
```

---

### Q3: 端口被占用

**检查端口占用：**
```powershell
Get-NetTCPConnection -LocalPort 8080,8765,5173 -State Listen
```

**关闭占用进程：**
```powershell
Stop-Process -Id <进程ID> -Force
```

---

### Q4: MySQL 连接失败

**错误信息：**
```
Communications link failure
```

**解决方案：**
1. 检查 MySQL 服务是否启动
2. 验证数据库密码：`application-dev.yml` 中的 `password`
3. 确认数据库已创建：`interview_ai`

---

### Q5: 前端无法连接后端

**检查 Vite 代理配置：**

文件：`interview-ai/frontend/vite.config.js`

```javascript
server: {
  proxy: {
    '/api': {
      target: 'http://localhost:8080',
      changeOrigin: true
    }
  }
}
```

---

### Q6: 登录失败 - 服务器内部错误 500

**错误信息：**
```
服务器内部错误，请稍后重试
```

**原因：** Redis 未启动，无法存储用户会话

**解决方案：**
```powershell
# 启动 Redis
cd D:\课设\new-course\redis
.\redis-server.exe
```

**验证 Redis：**
```powershell
# 检查端口 6379 是否监听
Get-NetTCPConnection -LocalPort 6379 -State Listen
```

---

### Q7: MinIO 初始化失败

**错误信息：**
```
MinIO 初始化失败
Connection refused: /127.0.0.1:9000
```

**影响：** 文件上传功能不可用（简历上传、视频存储）

**解决方案：**
```powershell
# 启动 MinIO
cd D:\课设\new-course\minio
.\minio.exe server .\data --console-address ":9001"
```

**MinIO 控制台：**
- 地址：http://localhost:9001
- 账号：minioadmin
- 密码：minioadmin

---

### Q8: 所有服务状态检查

**一键检查所有服务：**
```powershell
# 检查所有端口
Get-NetTCPConnection -LocalPort 6379,9000,3306,8765,8080,5173 -State Listen | Select-Object LocalPort,OwningProcess

# 预期结果：
# 6379  - Redis
# 9000  - MinIO API
# 9001  - MinIO Console
# 3306  - MySQL
# 8765  - Python AI
# 8080  - Java 后端
# 5173  - Vue 前端
```

**常见缺失服务：**
- Redis 未启动 → 无法登录
- MinIO 未启动 → 无法上传文件
- MySQL 未启动 → 数据库连接失败

---

### Q9: Python AI 服务启动慢

**现象：** 首次启动 Python AI 服务时很慢，卡在初始化

**原因：** Whisper 模型首次使用时需要下载（约 500 MB）

**解决方案：**

提前下载模型：
```powershell
cd smartspeech_optimized
.venv\Scripts\Activate.ps1
python download_whisper_model.py
```

或等待自动下载完成（5-10 分钟）

**检查模型是否已下载：**
```powershell
# 查看 Whisper 缓存目录
ls $env:USERPROFILE\.cache\whisper\
```
```

---

## 🎓 课设提交材料

根据《软件工程行业案例分析与实现考核实施方案》要求：

### 小组提交
- ✅ README.md（本文件）
- ✅ 源代码（interview-ai/ 和 smartspeech_optimized/）
- ✅ 数据库脚本（sql/）
- ✅ 测试数据
- ⏳ 小组报告 PDF
- ⏳ 成员任务表 Excel
- ⏳ 测试结果 Excel

### 个人提交
- ⏳ 作业01：需求与方案分析
- ⏳ 作业02：Vue3 页面与交互
- ⏳ 作业03：Spring Boot 接口
- ⏳ 作业04：测试及风险分析
- ⏳ 个人报告 + 工作证据

---

## 📚 技术栈

### 后端
- **Java 17** - 编程语言
- **Spring Boot 3.5.16** - 核心框架
- **Spring Security + JWT** - 认证授权
- **MyBatis-Plus 3.5.15** - ORM 框架
- **MySQL 8.0** - 数据库
- **Redis 5.0+** - 会话存储（必需）
- **MinIO 2023+** - 对象存储
- **Maven** - 依赖管理

### 前端
- **Vue 3** - 前端框架
- **Element Plus** - UI 组件库
- **Pinia** - 状态管理
- **Vue Router** - 路由管理
- **Axios** - HTTP 客户端
- **Vite** - 构建工具

### AI 服务（Python）
- **Python 3.10** - 编程语言
- **Flask + Waitress** - Web 框架
- **Whisper** - 语音识别（OpenAI）
- **Edge-TTS** - 语音合成（Microsoft）
- **MediaPipe** - 视觉分析（Google）
- **DeepSeek** - 大语言模型

---

## 📈 系统特点

1. **双后端架构**
   - Java 处理业务逻辑、数据持久化
   - Python 提供 AI 能力、模型推理

2. **多模态融合**
   - 语音 + 视觉 + 文本三位一体
   - 融合评分引擎综合评价

3. **可追溯性**
   - 完整记录面试过程
   - 评分依据透明可查

4. **模块化设计**
   - 前后端分离
   - 服务独立部署
   - 易于扩展维护

---

## 🔒 安全说明

- ⚠️ 不要提交 `.env` 文件（包含 API 密钥）
- ⚠️ 不要提交 `application-*.yml` 中的真实密码
- ⚠️ 生产环境需修改 JWT 密钥
- ⚠️ 建议使用 HTTPS 部署

---

## 📞 联系方式

- **项目地址：** `D:\课设\new-course`
- **文档支持：** 查看 `快速启动指南.md` 和 `环境配置指南.md`
- **问题反馈：** 提交 Issue 或联系开发团队

---

## 📝 更新日志

### v1.0.0 (2026-10-21)
- ✅ 完成双后端架构搭建
- ✅ 实现语音分析模块（Whisper）
- ✅ 实现视觉分析模块（MediaPipe）
- ✅ 集成大模型面试官（DeepSeek）
- ✅ 实现融合评分引擎
- ✅ 完成前端面试间页面
- ✅ 生成可追溯评测报告

---

## 📄 许可证

本项目为教育用途，仅供学习参考。

---

**开发团队** | 人工智能Ⅱ方向 | 2026年度课程设计
