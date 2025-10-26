# App Icon Generation

ใช้ online converter แปลง SVG เป็น PNG 512x512 หรือใช้ design tools:

1. นำไฟล์ `app_icon.svg` ไป convert ออนไลน์
2. ขนาด: 512x512 pixels
3. รูปแบบ: PNG
4. บันทึกเป็น `app_icon.png`

หรือใช้ ImageMagick:
```bash
magick app_icon.svg -background none -size 512x512 app_icon.png
```
