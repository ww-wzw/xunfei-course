# 多模态智能模拟面试评测平台

**版本**：1.0.0  
**技术栈**：Spring Boot 3 + Vue 3 + MySQL + Redis + MinIO  
**项目类型**：人工智能Ⅱ方向软件工程课程设计  
**感知模块**：语音分析 + 视觉行为分析  
**扩展能力**：大模型面试官  

---

## 项目简介

本项目是一个基于 Spring Boot 3 和 Vue 3 的多模态智能模拟面试评测系统。系统通过集成语音识别、视频表情分析和大模型问答能力，为求职者提供真实的AI模拟面试体验，并生成详细的评测报告。

### 核心功能

1. **语音分析模块**（感知模块1）
   - 实时语音转文字（基于Whisper ASR）
   - 语音内容质量评估
   - 回答完整性分析

2. **视觉行为分析模块**（感知模块2）
   - 面部表情识别（基于MediaPipe）
   - 眼神注意力检测
   - 面试状态评估

3. **大模型面试官**（扩展能力）
   - 智能问题生成（基于DeepSeek/讯飞星火）
   - 简历解析与针对性提问
   - 回答质量评价

4. **评分引擎**
   - 综合评分算法：`最终分 = 语音内容分 × 60% + 视觉行为分 × 40%`
   - 可追溯的评测报告
   - 多维度得分展示

---

## 系统架构

```
┌─────────────────────────────────────────────────────────┐
│                      前端 (Vue 3)                        │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐             │
│  │登录注册  │  │面试间    │  │报告查看  │             │
│  └──────────┘  └──────────┘  └──────────┘             │
└──────────────────────┬──────────────────────────────────┘
                       │ HTTP/WebSocket
┌──────────────────────┼──────────────────────────────────┐
│             Spring Boot 后端 (端口 8080)                 │
│  ┌────────────────────────────────────────────────┐    │
│  │ Controller: User, Interview, Audio, Video ...   │    │
│  └────────────────────┬───────────────────────────┘    │
│  ┌────────────────────┴───────────────────────────┐    │
│  │ Service: Interview, Transcription, Vision ...   │    │
│  └────────────────────┬───────────────────────────┘    │
│  ┌────────────────────┴───────────────────────────┐    │
│  │ AiApiClient ───────────────────┐                │    │
│  └────────────────────────────────│────────────────┘    │
│  ┌────────────────────────────────│────────────────┐    │
│  │ MyBatis-Plus -> MySQL          │                │    │
│  │ Redis Cache                    │                │    │
│  │ MinIO File Storage             │                │    │
│  └────────────────────────────────│────────────────┘    │
└────────────────────────────────────│─────────────────────┘
                                     │ HTTP API
┌────────────────────────────────────┼─────────────────────┐
│          Python AI 服务 (端口 8765)  │                    │
│  ┌────────────────────────────────┴────────────────┐    │
│  │ Flask API: /ai/asr, /ai/tts, /ai/sessions ...   │    │
│  └────────────────────┬─────────────────────────────┘    │
│  ┌────────────────────┴─────────────────────────────┐    │
│  │ ASR Service (Whisper)                            │    │
│  │ TTS Service (Edge-TTS)                           │    │
│  │ Vision Service (MediaPipe)                       │    │
│  │ LLM Service (DeepSeek/讯飞星火)                   │    │
│  │ Score Service (评分引擎)                          │    │
│  └──────────────────────────────────────────────────┘    │
└──────────────────────────────────────────────────────────┘
```

---

## 技术选型

### 后端技术
- **Spring Boot 3.5.16** - 核心框架
- **MyBatis-Plus 3.5.15** - ORM框架
- **Spring Security + JWT** - 认证授权
- **Redis** - 缓存与会话
- **MySQL 8.0** - 数据库
- **MinIO** - 对象存储
- **Java 17** - 编程语言

### 前端技术
- **Vue 3** - 前端框架
- **Element Plus** - UI组件库
- **Pinia** - 状态管理
- **Vue Router** - 路由管理
- **Axios** - HTTP客户端
- **Vite** - 构建工具

### AI 服务（Python）
- **Flask + Waitress** - Web框架
- **Whisper** - 语音识别
- **Edge-TTS** - 语音合成
- **MediaPipe** - 视觉分析
- **DeepSeek/讯飞星火** - 大模型

---

## 环境要求

### 必需环境
- **JDK 17** 或更高版本
- **Maven 3.8+**
- **Node.js 20+** 和 npm
- **MySQL 8.0**
- **Redis 6.0+**
- **Python 3.10** (用于AI服务)
- **MinIO** (对象存储，可选)

### 推荐配置
- 内存：8GB以上
- 硬盘：10GB可用空间
- 浏览器：Chrome/Edge最新版（支持摄像头和麦克风）

---

## 快速开始

### 1. 克隆项目

```bash
cd D:\课设\new-course\interview-ai
```

### 2. 初始化数据库

```bash
# 进入MySQL命令行
mysql -u root -p

# 执行SQL脚本
source D:\课设\new-course\interview-ai\sql\interview_ai.sql
source D:\课设\new-course\interview-ai\sql\interview_ai_audio_video_delta.sql
source D:\课设\new-course\interview-ai\sql\interview_ai_vision_delta.sql
source D:\课设\new-course\interview-ai\sql\interview_ai_state_delta.sql
source D:\课设\new-course\interview-ai\sql\interview_transcript_delta.sql

# 退出
exit
```

### 3. 启动Python AI服务

```bash
cd D:\课设\new-course\smartspeech_optimized

# 激活Python虚拟环境（如果有）
# conda activate nlp_env

# 安装依赖
pip install -r requirements.txt

# 配置API密钥（复制.env.example为.env并填写）
cp .env.example .env
# 编辑.env文件，填写DEEPSEEK_API_KEY

# 启动Python服务（端口8765）
python -m backend.run
```

### 4. 启动Spring Boot后端

```bash
cd D:\课设\new-course\interview-ai

# 修改配置文件
# interview-bootstrap/src/main/resources/application-dev.yml
# 配置MySQL、Redis、MinIO连接信息

# 编译打包
mvn clean install -DskipTests

# 启动主应用
cd interview-bootstrap
mvn spring-boot:run
```

### 5. 启动Vue前端

```bash
cd D:\课设\new-course\interview-ai\frontend

# 安装依赖
npm install

# 启动开发服务器（端口5173）
npm run dev
```

### 6. 访问系统

打开浏览器访问：`http://localhost:5173`

**测试账号：**
- 管理员：`admin` / `123456`
- 候选人：`test01` / `123456`

---

## 功能展示

### 用户角色与权限

| 角色 | 权限 |
|------|------|
| 管理员 | 用户管理、题库管理、场景管理、查看所有记录 |
| 面试官 | 查看记录、评分、查看报告 |
| 候选人 | 参加面试、查看自己的记录和报告 |

### 业务流程

```
1. 候选人注册/登录
     ↓
2. 上传简历（可选）
     ↓
3. 选择面试场景
     ↓
4. 创建面试记录
     ↓
5. 开始AI面试
   - 摄像头/麦克风采集
   - AI提问
   - 语音回答（实时转文字）
   - 视觉分析（表情、注意力）
     ↓
6. 提交面试
     ↓
7. 生成评测报告
   - 语音内容评分
   - 视觉行为评分
   - 综合评分
   - 改进建议
     ↓
8. 查看报告详情
```

---

## 核心接口文档

### 用户认证
- `POST /api/users/register` - 用户注册
- `POST /api/users/login` - 用户登录
- `GET /api/users/profile` - 获取个人信息

### 简历管理
- `POST /api/resumes/upload` - 上传简历
- `GET /api/resumes/current` - 获取当前简历

### 面试会话
- `POST /api/interview-sessions` - 创建面试会话
- `POST /api/interview-sessions/{id}/start` - 开始面试
- `POST /api/interview-sessions/{id}/complete` - 提交面试
- `GET /api/interview-sessions/{id}/state` - 获取会话状态

### 音频处理
- `POST /api/interview-audio/segments` - 创建音频片段
- `POST /api/interview-audio/segments/uploaded` - 标记上传完成

### 视频处理
- `POST /api/interview-video/frames` - 提交视频帧
- `GET /api/interview-video/records/{id}/frames` - 获取视频帧列表

### AI服务（Python）
- `POST /api/ai/asr` - 语音转文字
- `POST /api/ai/tts` - 文字转语音
- `POST /api/ai/sessions` - 创建AI会话
- `POST /api/ai/sessions/{id}/opening` - 生成首题
- `POST /api/ai/sessions/{id}/messages` - 提交回答并获取下一题
- `POST /api/ai/sessions/{id}/finish` - 结束并生成报告

完整API文档请访问：`http://localhost:8080/doc.html` (Knife4j)

---

## 评分规则

### 综合评分算法

```
最终得分 = 语音内容得分 × 60% + 视觉行为得分 × 40%

视觉行为得分 = 表情得分 × 50% + 注意力得分 × 50%
```

### 评分维度

| 维度 | 权重 | 说明 |
|------|------|------|
| 语音内容 | 60% | AI评估回答的完整性、准确性、逻辑性 |
| 面部表情 | 20% | 表情自然度、自信程度 |
| 眼神注意力 | 20% | 视线稳定性、专注程度 |

### 报告内容

- 总分与等级评定
- 各维度得分明细
- 问答历史记录
- 视觉分析指标
- 改进建议
- 可追溯的原始数据

---

## 测试用例

### 正常测试用例

| 测试项 | 输入 | 预期结果 |
|--------|------|----------|
| 用户注册 | 用户名`test02`，密码`123456` | 注册成功，返回用户信息 |
| 用户登录 | 用户名`test01`，密码`123456` | 登录成功，返回JWT Token |
| 简历上传 | PDF/DOCX文件 | 解析成功，提取姓名、技能等信息 |
| 创建面试 | 选择场景"Java后端工程师" | 创建成功，返回记录ID |
| 语音转写 | 上传音频文件 | 返回识别文本 |
| 视频分析 | 提交视频帧 | 返回表情和注意力指标 |
| 提交面试 | 完成所有问题 | 生成评测报告 |

### 异常测试用例

| 测试项 | 输入 | 预期结果 |
|--------|------|----------|
| 重复注册 | 已存在的用户名 | 返回错误：用户已存在 |
| 错误密码 | 用户名`test01`，密码`wrong` | 返回错误：密码错误 |
| 未登录访问 | 不携带Token访问受保护接口 | 返回401，提示未登录 |
| 越权访问 | 候选人访问管理员接口 | 返回403，提示无权限 |
| 文件过大 | 上传超过50MB的简历 | 返回错误：文件过大 |
| 空回答 | 提交空的回答内容 | 返回错误：回答不能为空 |

---

## 项目风险与应对

| 风险 | 影响 | 应对措施 | 责任人 | 状态 |
|------|------|----------|--------|------|
| AI服务不稳定 | 面试无法进行 | 添加降级逻辑，提供备用问题 | 后端开发 | 已处理 |
| 摄像头权限被拒 | 视觉分析失败 | 提示用户授权，允许跳过视觉分析 | 前端开发 | 已处理 |
| 网络延迟 | 用户体验差 | 添加加载提示，实现断线重连 | 前端开发 | 已处理 |
| 数据库连接失败 | 系统崩溃 | 配置连接池，添加健康检查 | 后端开发 | 已处理 |
| API密钥泄露 | 安全风险 | 使用环境变量，不提交.env文件 | 全员 | 已处理 |

---

## 目录结构

```
interview-ai/
├── interview-bootstrap/          # Spring Boot启动模块
│   └── src/main/resources/
│       ├── application.yml       # 主配置
│       └── application-dev.yml   # 开发环境配置
├── interview-common/             # 公共模块
│   └── src/main/java/.../common/
│       ├── ai/                   # AI客户端
│       ├── security/             # 安全配置
│       └── exception/            # 异常处理
├── interview-modules/            # 业务模块
│   ├── interview-system/         # 用户权限模块
│   ├── interview-question/       # 题库模块
│   ├── interview-resume/         # 简历模块
│   ├── interview-interview/      # 面试模块
│   └── interview-file/           # 文件模块
├── frontend/                     # Vue 3前端
│   ├── src/
│   │   ├── views/                # 页面组件
│   │   ├── components/           # 公共组件
│   │   ├── api/                  # API调用
│   │   └── router/               # 路由配置
│   └── package.json
├── sql/                          # 数据库脚本
│   ├── interview_ai.sql          # 主表结构和初始数据
│   └── *_delta.sql               # 增量表
├── pom.xml                       # Maven主配置
└── README.md                     # 本文件
```

---

## 开发团队

本项目为软件工程课程设计小组作业，团队成员职责分工如下：

| 成员 | 职责 | 主要工作 |
|------|------|----------|
| 组长 | 架构设计、后端开发 | Spring Boot后端、数据库设计 |
| 成员1 | 前端开发 | Vue 3页面、交互逻辑 |
| 成员2 | AI集成 | Python服务、模型调用 |
| 成员3 | 测试与文档 | 测试用例、API文档 |

---

## 常见问题

### Q1: Python AI服务启动失败？
**A**: 检查Python版本是否为3.10，确保已安装所有依赖：
```bash
pip install -r requirements.txt
```

### Q2: 前端无法连接后端？
**A**: 检查`frontend/vite.config.js`中的代理配置是否正确：
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

### Q3: MySQL连接失败？
**A**: 检查`application-dev.yml`中的数据库配置：
```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/interview_ai
    username: root
    password: root
```

### Q4: 摄像头无法使用？
**A**: 
- 确保浏览器已授权摄像头权限
- HTTPS环境下才能使用摄像头（开发环境localhost除外）
- 检查是否被其他应用占用

### Q5: AI模型响应慢？
**A**: 
- 检查网络连接
- 确认API密钥有效
- DeepSeek免费版有速率限制，建议升级付费版

---

## 部署说明

### 生产环境部署

1. **修改配置文件**
   - 使用`application-prod.yml`
   - 修改数据库密码
   - 配置真实的MinIO地址

2. **打包应用**
```bash
mvn clean package -P prod -DskipTests
```

3. **启动服务**
```bash
java -jar interview-bootstrap/target/interview-bootstrap-1.0.0.jar
```

4. **Nginx反向代理**（可选）
```nginx
server {
    listen 80;
    server_name your-domain.com;
    
    location / {
        proxy_pass http://localhost:5173;
    }
    
    location /api {
        proxy_pass http://localhost:8080;
    }
}
```

---

## 许可证

本项目为教育用途，仅供学习参考。

---

## 更新日志

### v1.0.0 (2026-10-21)
- ✅ 完成用户认证与权限管理
- ✅ 实现语音转写功能
- ✅ 实现视觉行为分析
- ✅ 集成大模型面试官
- ✅ 实现评分引擎
- ✅ 完成前端面试间页面
- ✅ 生成评测报告

---

## 联系方式

如有问题，请联系项目组长或提交Issue。

**项目地址**：`D:\课设\new-course\interview-ai`  
**演示账号**：`admin` / `123456`  
**技术支持**：查看项目Wiki或联系开发团队
