# Tech Stack — โปรเจค e-book

เอกสารสรุปเทคโนโลยีและโครงสร้างของโปรเจค

---

## 1. Framework หลัก

| เทคโนโลยี | เวอร์ชัน | บทบาท |
|-----------|---------|-------|
| [Astro](https://astro.build) | ^6.1.6 | Static site generator — สร้างหน้าเว็บแบบ static (`output: 'static'`) |
| TypeScript | — | Type safety (มี `tsconfig.json`) |
| Node.js | ≥ 22.12.0 | Runtime สำหรับ build |

**ทำไมเลือก Astro?** เพราะเป็น content-focused framework ที่ ship JS น้อย (zero JS by default) เหมาะกับเว็บ e-book/บทความที่เน้นอ่าน

---

## 2. Styling

| เทคโนโลยี | เวอร์ชัน | บทบาท |
|-----------|---------|-------|
| [Tailwind CSS](https://tailwindcss.com) | ^4.2.2 | Utility-first CSS framework |
| `@tailwindcss/vite` | ^4.2.2 | Plugin เชื่อม Tailwind v4 เข้ากับ Vite (ไม่ต้องใช้ PostCSS config แล้ว) |

Custom styles อยู่ที่ `src/styles/global.css`

---

## 3. Animation & Interaction

| เทคโนโลยี | เวอร์ชัน | บทบาท |
|-----------|---------|-------|
| [GSAP](https://gsap.com) | ^3.15.0 | Animation library — ใช้ใน scroll-reveal, transitions |
| [Lenis](https://lenis.darkroom.engineering) | ^1.3.21 | Smooth scrolling library |

---

## 4. 3D / AR

| เทคโนโลยี | เวอร์ชัน | บทบาท |
|-----------|---------|-------|
| [@google/model-viewer](https://modelviewer.dev) | ^4.2.0 | Web component สำหรับแสดงโมเดล 3D / AR |

โมเดล 3D เก็บอยู่ที่ `public/models/`

---

## 5. โครงสร้างโปรเจค

```
.
├── src/
│   ├── pages/              # Astro routes (file-based routing)
│   │   ├── index.astro     # หน้าแรก
│   │   ├── chapter-1.astro # บทที่ 1
│   │   ├── chapter-2.astro # บทที่ 2
│   │   └── chapter-3.astro # บทที่ 3
│   ├── components/         # UI components (.astro)
│   │   ├── Nav.astro
│   │   ├── Hero.astro
│   │   ├── Footer.astro
│   │   ├── ChapterCard.astro
│   │   ├── ChapterIntro.astro
│   │   ├── ChapterSidebar.astro
│   │   ├── ContentCard.astro
│   │   ├── Section.astro
│   │   ├── Prose.astro
│   │   ├── Figure.astro
│   │   ├── Pullquote.astro
│   │   ├── Timeline.astro
│   │   ├── ScrollReveal.astro
│   │   ├── StatCounter.astro
│   │   ├── HeartbeatIcon.astro
│   │   ├── ARCube.astro
│   │   ├── ARViewer.astro
│   │   ├── OrbitScene.astro
│   │   └── Phone3D.astro
│   ├── layouts/
│   │   └── BaseLayout.astro  # layout หลัก
│   └── styles/
│       └── global.css        # CSS global + Tailwind imports
│
├── content/                # เนื้อหา e-book
│   ├── ch1.txt
│   ├── ch2.txt
│   ├── ch3.txt
│   └── images/
│
├── public/                 # Static assets (เสิร์ฟตรง)
│   ├── favicon.ico
│   ├── favicon.svg
│   ├── images/
│   └── models/             # 3D models (.glb / .gltf)
│
├── scripts/                # PowerShell utilities
│   ├── extract-doc.ps1     # สกัดข้อความจาก .doc
│   └── convert-emf.ps1     # แปลงรูป EMF
│
├── docs/                   # เอกสารโปรเจค
├── astro.config.mjs        # ตั้งค่า Astro + Tailwind plugin
├── tsconfig.json
└── package.json
```

---

## 6. Build & Deployment

### Scripts

```bash
npm run dev      # dev server (astro dev)
npm run build    # build production → ./dist
npm run preview  # preview build ที่ build แล้ว
```

### Deployment targets

โปรเจค deploy 2 ที่ขนานกัน:

| Platform | URL | Trigger |
|----------|-----|---------|
| **Vercel** | https://ebook-one-woad.vercel.app | auto-deploy เมื่อ push `main` |
| **GitHub Pages** | https://josaha1.github.io/ebook | GitHub Actions workflow |

### `base` path แบบ conditional

ใน `astro.config.mjs` มีการตรวจ environment variable `VERCEL` เพื่อตั้ง `base` path:

```js
const isVercel = !!process.env.VERCEL;

export default defineConfig({
  site: isVercel ? 'https://ebook-one-woad.vercel.app' : 'https://josaha1.github.io',
  base: isVercel ? '/' : '/ebook',
  output: 'static',
  ...
});
```

เพราะ Vercel เสิร์ฟที่ root (`/`) แต่ GitHub Pages เสิร์ฟที่ subpath (`/ebook`)

---

## 7. Source data

ต้นฉบับเนื้อหา e-book เป็นไฟล์ Word (`.doc`) ที่ root:

- `บทที่ 1_AR.doc`
- `บทที่ 2_AR.doc`
- `บทที่ 3_AR.doc`

ใช้ PowerShell scripts ใน `scripts/` แปลงเป็น text + รูปภาพ → เก็บใน `content/`

---

## 8. สรุปสั้น

โปรเจค e-book **static interactive** สำหรับอ่าน 3 บท ใช้ Astro + Tailwind v4 เป็นแกน เพิ่ม GSAP สำหรับ animation, Lenis สำหรับ smooth scroll, และ model-viewer สำหรับ 3D/AR — สไตล์ modern editorial/magazine
