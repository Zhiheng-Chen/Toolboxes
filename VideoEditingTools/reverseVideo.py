import subprocess
import os

# 输入和输出文件名
input_path = "input.mp4"
reversed_video_path = "reversed_video.mp4"
reversed_audio_path = "reversed_audio.m4a"
final_output_path = "reversed_final.mp4"

# 1️⃣ 倒放视频（不含音频）
subprocess.run([
    "ffmpeg", "-y",
    "-i", input_path,
    "-an",  # 不带音频
    "-vf", "reverse",
    "-preset", "ultrafast",
    reversed_video_path
])

# 2️⃣ 提取 + 倒放音频
subprocess.run([
    "ffmpeg", "-y",
    "-i", input_path,
    "-vn",  # 不带视频
    "-af", "areverse",
    reversed_audio_path
])

# 3️⃣ 合并倒放后的视频和音频
subprocess.run([
    "ffmpeg", "-y",
    "-i", reversed_video_path,
    "-i", reversed_audio_path,
    "-c:v", "copy",
    "-c:a", "aac",
    "-shortest",
    final_output_path
])

print("✅ 倒放完成！输出文件为：", final_output_path)