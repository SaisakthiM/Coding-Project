import os
import pytesseract
from PIL import Image, ImageFilter, ImageOps
import pyperclip
from pathlib import Path
import keyboard  # pip install keyboard
import time

# Screenshot folder
SCREENSHOT_FOLDER = Path.home() / "Pictures" / "Screenshots"
# Tesseract path (Windows)
# pytesseract.pytesseract.tesseract_cmd = r"C:\Program Files\Tesseract-OCR\tesseract.exe"

def get_latest_screenshot(folder):
    images = list(folder.glob("*.png")) + list(folder.glob("*.jpg"))
    if not images:
        return None
    return max(images, key=lambda f: f.stat().st_mtime)

def preprocess_image(img):
    # Convert to grayscale
    img = img.convert("L")
    # Increase contrast
    img = ImageOps.autocontrast(img)
    # Optional: sharpen
    img = img.filter(ImageFilter.SHARPEN)
    return img

def ocr_image(image_path):
    img = Image.open(image_path)
    img = preprocess_image(img)
    return pytesseract.image_to_string(img)

def process_latest_screenshot():
    latest = get_latest_screenshot(SCREENSHOT_FOLDER)
    if not latest:
        print("No screenshots found!")
        return
    print("Processing:", latest)
    text = ocr_image(latest)
    if text.strip():
        pyperclip.copy(text)
        print("Text copied to clipboard!")
    else:
        print("No text detected.")

# Hotkey: Ctrl+Shift+S
keyboard.add_hotkey("ctrl+shift+s", process_latest_screenshot)

print("Press Ctrl+Shift+S to OCR latest screenshot. Press ESC to quit.")
keyboard.wait("esc")
