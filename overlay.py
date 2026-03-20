from PIL import Image, ImageDraw, ImageFont
import os

# Load video frames as images (first/last frame for overlay preview)
img = Image.open("forest_perfect.jpg").convert("RGBA")
draw = ImageDraw.Draw(img)
 
# π×7 bottom right (12px, white, 70% opacity)
try:
    font = ImageFont.truetype("/system/fonts/RobotoMono-Regular.ttf", 12)
except:
    font = ImageFont.load_default()

# Bottom right position (10% margin)
W, H = img.size
bbox = draw.textbbox((0,0), "π×7", font=font)
text_w, text_h = bbox[2]-bbox[0], bbox[3]-bbox[1]
x = W - text_w - 20
y = H - text_h - 20

draw.text((x, y), "π×7", fill=(255,255,255,180), font=font)  # 70% opacity
img.save("forest_overlay.png")
print("Overlay created: forest_overlay.png")
