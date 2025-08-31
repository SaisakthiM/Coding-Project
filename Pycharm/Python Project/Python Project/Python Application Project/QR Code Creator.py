
from qrcode.console_scripts import error_correction
from xml.sax.expatreader import version

import qrcode as qr
from PIL import Image

qro = qr.QRCode(version=1,
                error_correction=qr.constants.ERROR_CORRECT_H,
                box_size=10,border=4)

qro.add_data("https://www.youtube.com/playlist?list=PLjVLYmrlmjGfAUdLiF2bQ-0l8SwNZ1sBl")
qro.make(fit=True)
img = qro.make_image(fill_color="blue",back_color="red")
img.save("Qr.png")