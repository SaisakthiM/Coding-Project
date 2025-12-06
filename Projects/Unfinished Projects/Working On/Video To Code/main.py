import cv2
import os
import time
from keyboard import is_pressed

# ASCII characters used to build the output
ASCII_CHARS = "@%#*+=-:. "

# Resize and convert image to ASCII
def frame_to_ascii(image, width=100):
    # Convert to grayscale
    gray_image = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

    # Calculate height keeping aspect ratio
    height, original_width = gray_image.shape
    aspect_ratio = height / original_width
    new_height = int(aspect_ratio * width * 0.55)  # 0.55 adjusts for character height

    # Resize the grayscale image
    resized_gray = cv2.resize(gray_image, (width, new_height))

    # Convert each pixel to ASCII
    ascii_img = []
    for row in resized_gray:
        line = "".join([ASCII_CHARS[pixel // 25] for pixel in row])  # 255/10 ≈ 25
        ascii_img.append(line)

    return "\n".join(ascii_img)

# Path to your video file
VIDEO_PATH = "video.mp4"
MAX_DURATION = 30  # seconds

# Load video
cap = cv2.VideoCapture(VIDEO_PATH)
fps = cap.get(cv2.CAP_PROP_FPS) or 25
interval = max(1, int(fps // 15))
total_frames = int(cap.get(cv2.CAP_PROP_FRAME_COUNT))
max_frames = min(total_frames, int(fps * MAX_DURATION))

ascii_frames = []
count = 0

# Convert video frames to ASCII
while cap.isOpened() and len(ascii_frames) < max_frames:
    ret, frame = cap.read()
    if not ret:
        break
    if count % interval == 0:
        ascii_frame = frame_to_ascii(frame)
        ascii_frames.append(ascii_frame)
    count += 1

cap.release()

# Clear screen command
os.system('cls' if os.name == 'nt' else 'clear')
delay = 1 / fps

# Display ASCII animation
try:
    while True:
        for f in ascii_frames:
            print(f)
            time.sleep(delay)
            os.system('cls' if os.name == 'nt' else 'clear')
        if is_pressed('q'):
            break
except KeyboardInterrupt:
    pass
