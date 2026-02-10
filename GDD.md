# THE FORGOTTEN
## Game Design Document
**For:** Mini Jam 204: Café  
**Theme:** Café  
**Duration:** 72 Hours  
**Engine:** Godot 4.6  
**Visual Style:** 1-bit Isometric 3D

---

## 1. Elevator Pitch

A minimalist hidden object game set in a café. Players rotate a 1-bit isometric scene to find lost items scattered among tables, chairs, and patrons. Different angles reveal different secrets.

**Hook:** *What you see depends on where you stand.*

---

## 2. Core Loop

```
Find Item List → Rotate Scene → Spot Hidden Item → Click to Collect → Next Level
```

1. Each level shows 3-5 items to find (listed at top)
2. Player rotates the café scene freely (mouse drag)
3. Items may be hidden behind furniture or camouflaged
4. Click to collect found items
5. Find all items to unlock next level

---

## 3. Visual Style

### 3.1 Art Direction
- **1-bit monochrome:** Pure black and white, no gray
- **Isometric 3D:** 45° angle, orthographic camera
- **Dithering patterns:** Use checkerboard patterns for depth/shadows
- **Pixel perfect:** Crisp edges, retro Macintosh aesthetic

### 3.2 Visual Reference
- Obra Dinn (1-bit dithering)
- Papers, Please (UI style)
- Isometric pixel art classics

### 3.3 Scene Elements
| Object | Style |
|--------|-------|
| Tables/Chair | Simple cubes, black outlines |
| Customers | Blocky figures, minimal detail |
| Items | Distinct silhouettes, slightly smaller scale |
| Floor | Tiled pattern, alternating dither |
| Walls | Solid black or white |

---

## 4. Gameplay Mechanics

### 4.1 Rotation
- **Mouse drag** to rotate scene horizontally
- **Smooth rotation** (not discrete steps)
- Full 360° view
- Auto-snap to nearest 90° when close (optional polish)

### 4.2 Hidden Items
**Item Types:**
- 🔑 Keys
- 📱 Phone
- 📖 Book
- 🎧 Headphones
- 👓 Glasses
- 💼 Bag

**Hiding Mechanics:**
| Mechanic | Description |
|----------|-------------|
| Occlusion | Item hidden behind table/chair from certain angles |
| Camouflage | Black item on black surface, white on white |
| Scale | Small items tucked in corners |
| Reflection | Item visible only from specific angle |

### 4.3 Difficulty Progression
| Level | Cafe State | Items | Challenge |
|-------|-----------|-------|-----------|
| 1 | Empty, morning | 3 | Tutorial, obvious placements |
| 2 | Few customers | 4 | Basic occlusion |
| 3 | Busy lunch | 5 | Moving customers, camouflage |
| 4 | Messy closing | 5 | Cluttered, similar-looking items |
| 5 | Night mode | 5 | Limited visibility (spotlight) |

### 4.4 Moving Customers (Level 3+)
- Customers walk predetermined paths
- Can temporarily block view of items
- Adds timing element to observation

---

## 5. Controls

| Input | Action |
|-------|--------|
| Mouse Drag | Rotate scene |
| Left Click | Select/Collect item |
| Scroll Wheel | Zoom in/out (optional) |
| R | Reset rotation |
| H | Hint (highlight area) |

---

## 6. UI Design

### 6.1 HUD Elements
```
┌─────────────────────────────────┐
│  FIND: 🔑 📱 📖 🎧 👓      3/5   │  ← Item checklist
├─────────────────────────────────┤
│                                 │
│      [ ROTATING SCENE ]         │  ← Main viewport
│                                 │
├─────────────────────────────────┤
│  LEVEL 1    TIME: 02:34         │  ← Progress
└─────────────────────────────────┘
```

### 6.2 Visual Language
- **Font:** Pixel/bitmap font (monospace)
- **Borders:** 2px black outlines
- **Icons:** Simple 1-bit silhouettes
- **Feedback:** Flash white on successful find

---

## 7. Technical Specs

### 7.1 Godot Setup
- **Renderer:** Compatibility (for pixel-perfect)
- **Camera:** Orthographic, isometric angle
- **Scene:** 3D with unshaded materials (black/white only)

### 7.2 Asset Pipeline
```
Models: Simple primitives (Cube, Cylinder)
├── Table (Box)
├── Chair (Box + smaller boxes)
├── Customer (Capsule + Box head)
└── Items (Custom low-poly meshes)

Materials:
├── Black (albedo: #000000)
└── White (albedo: #FFFFFF)

Post-Process:
└── Dithering shader (optional)
```

### 7.3 Rotation Implementation
```gdscript
# Pseudo-code
func _input(event):
    if event is InputEventMouseMotion and dragging:
        rotation.y += event.relative.x * sensitivity
```

---

## 8. Level Design

### 8.1 Layout Template
```
    [WINDOW]
[BAR]         [TABLE2]
              [TABLE3]
    [TABLE1]  [TABLE4]
          [DOOR]
```

### 8.2 Item Placement Rules
- At least one item requires rotation to see
- No item completely hidden (always visible from some angle)
- Items never inside customers
- Balance: 2 easy, 2 medium, 1 hard per level

---

## 9. Audio (Optional)

| Sound | Event |
|-------|-------|
| Click | Item found |
| Whoosh | Rotation start/stop |
| Chime | Level complete |
| Ambient | Café background noise |

---

## 10. Scope for 72 Hours

### Must Have (Day 1-2)
- [ ] Basic 3D scene with rotation
- [ ] 3 levels
- [ ] 5 item types
- [ ] Click to collect
- [ ] Win condition

### Nice to Have (Day 3)
- [ ] Moving customers
- [ ] More levels (5 total)
- [ ] Sound effects
- [ ] Particle effects on find
- [ ] Timer/Scoring

### Cut if Time Runs Out
- Night mode spotlight
- Zoom functionality
- Hint system
- Save/load

---

## 11. Risk Mitigation

| Risk | Mitigation |
|------|------------|
| 3D too complex | Use primitive shapes only |
| Rotation feels bad | Test early, adjust sensitivity |
| Items too hard to find | Add silhouette highlight on hover |
| Performance | Low poly count, simple shaders |

---

## 12. Project Structure

```
the-forgotten/
├── scenes/
│   ├── main.tscn
│   ├── cafe_level_1.tscn
│   ├── cafe_level_2.tscn
│   └── cafe_level_3.tscn
├── scripts/
│   ├── camera_controller.gd
│   ├── item_manager.gd
│   └── game_manager.gd
├── assets/
│   ├── models/ (blend/tscn)
│   ├── materials/
│   └── fonts/
└── export_presets.cfg
```

---

**Next Step:** Create Godot project and prototype rotation + basic scene.
