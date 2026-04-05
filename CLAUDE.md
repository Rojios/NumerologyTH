# NumerologyTH — แม่หมอเหมียว

## Project Overview
แอป iOS ทำนายเลขศาสตร์ไทย โดย "แม่หมอเหมียว" (น้องเหมียวพ่อมดหมวกม่วง)

**GitHub:** `github.com/Rojios/NumerologyTH`
**Platform:** iOS 17+ / Swift 5.9 / SwiftUI
**Team ID:** 252T283JF9

---

## Version Roadmap

### v1.0 — Pure Mobile Fortune (Free) ✅
- ทำนายหมายเลขโทรศัพท์ (คู่เลข 100 คู่ + ผลรวม + ธาตุห้า)
- ทำนายชื่อ (แปลงอักษรไทย → ตัวเลข)
- ทำนายทะเบียนรถ
- Scoring 1,000 คะแนน / เกรด A+ ถึง D
- ฟรีทั้งหมด (ลบ paywall แล้ว เหลือแค่เลี้ยงกาแฟ)
- App Icon: แม่หมอเหมียว / Background: ภาพแม่หมอเหมียวเต็มจอ
- Tag: `v1.0` @ `5de2b82`

### v2.0 — Bazi Module ✅
- นำ v1.0 มาต่อยอด + เพิ่ม module "รหัสธาตุประจำตัว" (Bazi)
- หน้าแรก: Background ภาพแมว + 2 แถบเลือก
- UI ม่วง/ชมพูพาสเทล + ขยายคำอธิบายความสมพงศ์
- Tag: `v2.0` @ `2afdea0`

### v2.1 — เซียมซีดูดวง + Share ✅ (ปัจจุบัน)
- เซียมซีดูดวง (FortuneStickView + FortuneMenuView)
- เลขนำโชค (LuckyNumberView)
- Share Feature (ShareHelper)
- Background ใหม่
- Tag: `v2.1` @ `7f97431`

### v3.0 — AI แม่หมอเหมียว (iOS)
- Chat ถามดวง 3 คำถาม ฿88/เซสชัน
- ปุ่มแชร์ผลลัพธ์ — ช่วยไวรัล

### Phase ถัดไป
- PWA — เว็บ version ให้ Android ใช้ได้

### หมายเหตุ
- ทุก version สร้างบน iOS ก่อน

---

## Project Structure

```
NumerologyTH/
├── App/                  — App entry + ContentView
├── Models/               — AnalysisSession, KnowledgeBase
├── Services/
│   ├── AnalysisEngine.swift      — core logic: คู่เลข, ผลรวม, ธาตุห้า (Lo Shu)
│   ├── BaziEngine.swift          — Bazi/ธาตุประจำตัว
│   ├── WuXingCompatibility.swift — ความสมพงศ์ธาตุ
│   ├── HistoryManager.swift
│   ├── QuotaManager.swift
│   ├── ShareHelper.swift         — share ผลลัพธ์
│   ├── ShareManager.swift
│   └── StoreKitManager.swift
├── ViewModels/           — Phone/Name/Plate/History/Purchase VMs
├── Views/
│   ├── HomeView.swift              — หน้าแรก
│   ├── PhoneInputView.swift        — input เบอร์โทร
│   ├── ResultView.swift            — แสดงผลทำนาย
│   ├── NameInputView.swift
│   ├── PlateInputView.swift
│   ├── BaziInputView.swift         — input ธาตุประจำตัว
│   ├── BaziResultView.swift        — ผลลัพธ์ธาตุประจำตัว
│   ├── CompatibilityPreviewView.swift
│   ├── FortuneMenuView.swift       — เมนูเซียมซี
│   ├── FortuneStickView.swift      — เซียมซีดูดวง
│   ├── LuckyNumberView.swift       — เลขนำโชค
│   ├── HistoryView.swift
│   ├── PaywallView.swift
│   └── Components/                 — GradeTag, ModeCard, PairRow, ScoreGauge, ElementUnlockCard, PhoneResultCard
├── Extensions/           — Color+Theme, String+Thai
└── Resources/
    ├── Assets.xcassets/  — AppIcon, HomeBG, Element images
    └── KnowledgeBase/    — 7 JSON files
        ├── pair_grades.json      — 100 คู่เลข + คำทำนาย
        ├── sum_scores.json       — คะแนนผลรวม
        ├── number_meanings.json  — ความหมายเลข 0-9
        ├── thai_char_map.json    — อักษรไทย → ตัวเลข
        ├── career_bonus.json     — โบนัสอาชีพ
        ├── element_meanings.json — ความหมายธาตุ
        └── fortune_sticks.json   — เซียมซี
```

## Scoring Logic (v1.0)
- คู่เลข 6 คู่ (ตำแหน่ง 5-6, 7-8, 9-10, 6-7, 8-9, closer)
- Closer cap 100pts: S=100, A=80, B=60, Penalty=0
- ไม่นับซ้ำกับคู่ที่ 6
- ผลรวม 10 หลัก → คะแนน + ความหมายผู้ถือครอง
- เกรด: A+ มงคลสูงมาก, A มงคล, B ดี, C ทั่วไป, D เหนื่อย

## Bazi / ธาตุห้า (Lo Shu)
- `ChineseElement` enum: น้ำ💧 ดิน🌍 ไม้🌿 ไฟ🔥 ทอง⚙️
- Digit mapping: 1=น้ำ, 2=ดิน, 3=ไม้, 4=ไฟ, 5=ดิน, 6=ทอง, 7=ทอง, 8=ไม้, 9=ไฟ, 0=น้ำ
- `analyzeElements()` → dominant element + count breakdown

## UI Theme
- บังคับ Light Mode
- พื้นผลรวม: ชมพูพาสเทล / พื้นคู่เลข: ม่วงพาสเทล
- เรียงคะแนนสูงก่อน
- Grade S → 👍👍👍 เขียวเข้ม, Grade A → 👍 เขียว

## Build & Run
```bash
# เปิดใน Xcode
open NumerologyTH.xcodeproj
# Build: Cmd+B / Run: Cmd+R
# Target: iPhone (iOS 17+)
```
