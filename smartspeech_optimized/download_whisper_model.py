"""
下载 Whisper 模型
"""
import whisper
import sys

print("=" * 50)
print("   下载 Whisper 模型")
print("=" * 50)

model_size = "small"
print(f"\n正在下载模型: {model_size} (约 500 MB)")
print("请稍候，这可能需要几分钟...\n")

try:
    model = whisper.load_model(model_size)
    print(f"\n✓ 模型下载成功！")
    print(f"模型位置: {whisper._MODELS[model_size]}")
    print(f"缓存目录: ~/.cache/whisper/")
except Exception as e:
    print(f"\n✗ 下载失败: {e}")
    sys.exit(1)
