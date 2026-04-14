# AR Interactive E-Book

เว็บไซต์ e-book แบบ interactive นำเสนอเนื้อหาบทที่ 1–3 เกี่ยวกับเทคโนโลยี Augmented Reality (AR)

**Live:** https://josaha1.github.io/ebook

## Tech
Astro · Tailwind CSS · GSAP ScrollTrigger · Lenis · `<model-viewer>`

## Development

```bash
npm install
npm run dev
npm run build
npm run preview
```

## Content pipeline

```bash
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/extract-doc.ps1
```
แปลงไฟล์ `.doc` ต้นฉบับเป็นข้อความ UTF-8 และดึงรูปภาพออกมาไว้ใน `content/`
