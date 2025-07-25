import cv2
import numpy as np

# set-up
input_path = 'input.mp4'
output_path = 'output.mp4'
interpolation = "4x"    # or "2x"

# open video
cap = cv2.VideoCapture(input_path)
fps = cap.get(cv2.CAP_PROP_FPS)
width  = int(cap.get(cv2.CAP_PROP_FRAME_WIDTH))
height = int(cap.get(cv2.CAP_PROP_FRAME_HEIGHT))
fourcc = cv2.VideoWriter_fourcc(*'mp4v')
multiplier = int(interpolation[0])  # "2x" → 2, "4x" → 4
out = cv2.VideoWriter(output_path, fourcc, fps * multiplier, (width, height))

# get first frame
ret, prev_frame = cap.read()
if not ret:
    print("❌ Failed to read first frame.")
    cap.release()
    exit()

prev_gray = cv2.cvtColor(prev_frame, cv2.COLOR_BGR2GRAY)

while True:
    ret, next_frame = cap.read()
    if not ret:
        break

    next_gray = cv2.cvtColor(next_frame, cv2.COLOR_BGR2GRAY)

    # calculate optical flow
    flow = cv2.calcOpticalFlowFarneback(prev_gray, next_gray, None,
                                        pyr_scale=0.5, levels=3, winsize=15,
                                        iterations=3, poly_n=5, poly_sigma=1.2, flags=0)

    h, w = flow.shape[:2]
    grid_x, grid_y = np.meshgrid(np.arange(w), np.arange(h))
    flow_map = np.dstack((grid_x, grid_y)).astype(np.float32)

    # write original frame
    out.write(prev_frame)

    # interpolate N-1 frames
    for i in range(1, multiplier):
        alpha = i / multiplier
        interp_map = flow_map + flow * alpha
        mid_frame = cv2.remap(prev_frame, interp_map, None, cv2.INTER_LINEAR)
        out.write(mid_frame)

    prev_frame = next_frame
    prev_gray = next_gray

# write last frame
out.write(prev_frame)

cap.release()
out.release()
print(f"✅ Interpolation ({interpolation}) complete. Output saved to: {output_path}")