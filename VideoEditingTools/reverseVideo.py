import subprocess
import os

# input and output file names
input_path = "input.mp4"
reversed_video_path = "reversed_video.mp4"
reversed_audio_path = "reversed_audio.m4a"
final_output_path = "reversed_final.mp4"

# reverse video (no audio)
subprocess.run([
    "ffmpeg", "-y",
    "-i", input_path,
    "-an",  # no audio
    "-vf", "reverse",
    "-preset", "ultrafast",
    reversed_video_path
])

# extract and reverse audio
subprocess.run([
    "ffmpeg", "-y",
    "-i", input_path,
    "-vn",  # no video
    "-af", "areverse",
    reversed_audio_path
])

# combine reversed video and audio
subprocess.run([
    "ffmpeg", "-y",
    "-i", reversed_video_path,
    "-i", reversed_audio_path,
    "-c:v", "copy",
    "-c:a", "aac",
    "-shortest",
    final_output_path
])

print("Reverse finished! Output: ", final_output_path)