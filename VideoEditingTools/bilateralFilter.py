import cv2

input_path = "input.mp4"
output_path = "output.mp4"

# parameters
diameter = 12          # range of pixels of blur; 9 by default
sigma_color = 5000      # range of colors to mix（to what extent to "trust" different colors; larger=more blurred); 100 by default
sigma_space = 75      # to what extent to "trust" farther away pixels; 75 by defalt

cap = cv2.VideoCapture(input_path)
fps = cap.get(cv2.CAP_PROP_FPS)
width = int(cap.get(cv2.CAP_PROP_FRAME_WIDTH))
height = int(cap.get(cv2.CAP_PROP_FRAME_HEIGHT))
fourcc = cv2.VideoWriter_fourcc(*'mp4v')
out = cv2.VideoWriter(output_path, fourcc, fps, (width, height))

frame_count = int(cap.get(cv2.CAP_PROP_FRAME_COUNT))
current = 0

print("Using bilateral filter...")

while True:
    ret, frame = cap.read()
    if not ret:
        break

    # use bilateral filter
    filtered = cv2.bilateralFilter(frame, diameter, sigma_color, sigma_space)
    out.write(filtered)

    current += 1
    if current % 10 == 0:
        print(f"Progress: {current}/{frame_count} frames")

cap.release()
out.release()
print("Finished! Output: ", output_path)
