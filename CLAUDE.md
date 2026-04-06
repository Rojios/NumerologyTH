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

### v2.1 — เซียมซีดูดวง + Share ✅
- เซียมซีดูดวง (FortuneStickView + FortuneMenuView)
- เลขนำโชค (LuckyNumberView)
- Share Feature (ShareHelper)
- Background ใหม่
- Tag: `v2.1` @ `7f97431`

### v2.3 — เขย่าเซียมซี + Cross-link ✅
- เขย่า iPhone สุ่มเซียมซี (ShakeDetector + haptic feedback)
- ตัวเลข slot machine วิ่งทีละหลัก (SlotNumberView)
- หน้าแรกเพิ่มปุ่มที่ 3 "เปิดรหัสธาตุประจำตัว"
- BaziResultView → ปุ่มลิงค์ไปทำนายมือถือ (เมื่อเข้าจากหน้าแรก)
- ResultView → ถ้าเคยเปิดธาตุแล้ว ดูความสมพงศ์ตรง (BaziStore)
- BaziStore: เก็บ birthDate/birthTime ใน UserDefaults
- ปุ่มล้างประวัติรหัสธาตุใน BaziInputView
- Tag: `v2.3` @ `f6454e7`

### v2.5 — แก้ Bazi Engine ✅
- Month/Hour pillar ใช้ Heavenly Stem ถูกต้อง (五虎遁/五鼠遁)
- เจ้าชะตา (日主) = Day Stem ตามหลัก Bazi ดั้งเดิม
- แก้ Yin-Yang pairing ใช้ %5 (甲己/乙庚/丙辛/丁壬/戊癸)
- ตัดตาราง "สัดส่วนธาตุ" ที่ไม่รวม hidden stems ออก
- เพิ่ม BaziEngineTests (14 tests) verify ตรง sinsae.net
- Tag: `v2.5` @ `3334776`

### v2.6 — Compatibility inline + UI ✅ (ปัจจุบัน)
- ResultView: แสดงความสมพงศ์ธาตุ inline ทันทีถ้าเคยเปิดธาตุแล้ว
- Share Card: เพิ่ม "แม่หมอเหมียว" บนสุด + ลบประโยคปิดล่าง
- ปุ่ม Home (house.fill) ที่หน้าผลมือถือ + หน้ารหัสธาตุ
- NavigationRouter: popToRoot กลับหน้าแรกจากทุกหน้า
- Tag: `v2.6` @ `8b6b5fb`

### v3.0 — AI แม่หมอเหมียว (iOS)
- Chat ถามดวง 3 คำถาม ฿88/เซสชัน
- ปุ่มแชร์ผลลัพธ์ — ช่วยไวรัล

### Phase ถัดไป
- Android version: `github.com/Rojios/NumerologyTH-Android` (Kotlin / Jetpack Compose)

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
│   ├── BaziEngine.swift          — Bazi/ธาตุประจำตัว (五虎遁/五鼠遁/Day Master)
│   ├── BaziStore.swift           — persistence วันเกิด/เวลาเกิด (UserDefaults)
│   ├── WuXingCompatibility.swift — ความสมพงศ์ธาตุ
│   ├── ShakeDetector.swift       — ตรวจจับการเขย่า iPhone
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
│   └── Components/                 — GradeTag, ModeCard, PairRow, ScoreGauge, ElementUnlockCard, PhoneResultCard, SlotNumberView
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

## Bazi Engine (v2.5+)
- `ChineseElement` enum: น้ำ💧 ดิน🌍 ไม้🌿 ไฟ🔥 ทอง⚙️
- 4 เสาหลัก: ปี/เดือน/วัน/ยาม — ทุกเสาใช้ Heavenly Stem
- เจ้าชะตา (日主) = Day Stem เสมอ
- Month Stem: สูตร 五虎遁 (yearStem % 5)
- Hour Stem: สูตร 五鼠遁 (dayStemIdx % 5)
- Verified: sinsae.net (Boss 06/03/1972 11:00 = 壬子/癸卯/丙申/甲午)
- Phone element: Lo Shu digit mapping (1=น้ำ, 2=ดิน, 3=ไม้, etc.)
- BaziStore: เก็บ birthDate/birthTime → recompute เมื่อต้องการ

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
