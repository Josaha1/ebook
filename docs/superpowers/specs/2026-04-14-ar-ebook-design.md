# Interactive AR E-Book — Design Spec

**Date:** 2026-04-14
**Source content:** `บทที่ 1_AR.doc`, `บทที่ 2_AR.doc`, `บทที่ 3_AR.doc` (Thai, ~2,900 words total)

## Goal
นำเสนอเนื้อหาบทที่ 1–3 ของงานวิจัย/โครงงานเรื่อง Augmented Reality ให้เป็นเว็บไซต์ e-book แบบ interactive ที่ทันสมัย สวยงาม และเข้าถึงง่ายสำหรับบุคคลทั่วไป/นักเรียน เผยแพร่ออนไลน์ฟรีบน GitHub Pages

## Target Audience
บุคคลทั่วไปและนักเรียน — โทนสนุก ชวนเล่น มี animation เยอะ สีสดใส

## Design Direction

### Visual
- **Palette:** AR futuristic gradient — purple `#7C3AED` → pink `#EC4899` → orange `#F97316`
- **Mode:** Light/Dark toggle
- **Thai font:** IBM Plex Sans Thai (primary) / Prompt (fallback) จาก Google Fonts
- **Micro-interactions:** hover glow, scroll-reveal, animated counters, cursor-reactive elements

### Structure

| Section | Behavior |
|---------|----------|
| Hero | Fullscreen landing, 3D model หมุนลอย, ปุ่ม "เริ่มอ่าน" |
| Progress Navigator | แถบ side/top, เลือกกระโดดบท + progress bar |
| บทที่ 1 บทนำ | Scrollytelling + animated stats counter |
| บทที่ 2 เนื้อหา | Section cards + รูปจาก .doc + **AR demo จริง** (model-viewer) |
| บทที่ 3 วิธีดำเนินการ | Timeline แนวตั้ง scroll-triggered |
| Footer | ผู้เขียน, ปุ่มแชร์, ดาวน์โหลด PDF |

### Interactive AR Feature
ปุ่ม "ดูแบบ AR" ในบทที่ 2 ใช้ Google `<model-viewer>` ให้ผู้อ่านบนมือถือ iOS/Android ส่องกล้องเห็นโมเดล 3D ลอยในพื้นที่จริง (ใช้โมเดลฟรีจาก Sketchfab หรือ Google model library)

## Tech Stack

- **Framework:** Astro (static output, เหมาะกับ content-heavy, JS bundle เล็ก)
- **Styling:** Tailwind CSS
- **Animation:** GSAP + ScrollTrigger
- **Smooth scroll:** Lenis
- **3D/AR:** `<model-viewer>` (web component จาก Google)
- **Deploy:** GitHub Pages (ผ่าน GitHub Actions)

## Content Pipeline
1. แปลง `.doc` → ข้อความ UTF-8 (ผ่าน Word COM `SaveAs2` format 7 = wdFormatUnicodeText)
2. ดึงรูปภาพจาก `.doc` (ผ่าน Word COM หรือ unzip `.docx` ชั่วคราว) → `/public/images/ch{n}/`
3. เขียนเนื้อหาเป็น `.astro` pages พร้อมเสริม visual/diagram ใหม่
4. เลือกโมเดล 3D ฟรี 2–3 ตัวสำหรับ AR demo

## Out of Scope (ไม่ทำ)
- Quiz / แบบทดสอบ
- Backend / database
- บัญชีผู้ใช้ / login
- Multi-language (ไทยอย่างเดียว)

## Success Criteria
- เปิดบนมือถือและเดสก์ทอปสวยทั้งคู่ (responsive)
- scroll 60fps ไม่กระตุก
- AR demo ใช้ได้จริงบน iOS Safari + Android Chrome
- Lighthouse Performance ≥ 85
- Deploy online มีลิงก์แชร์ได้
