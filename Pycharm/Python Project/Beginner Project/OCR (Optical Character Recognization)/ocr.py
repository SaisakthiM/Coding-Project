import PIL
import pytesseract


myconfig = r"--psm 6 --oem 3"
text = pytesseract.image_to_string(PIL.Image.open('text.jpg'))
print(text)