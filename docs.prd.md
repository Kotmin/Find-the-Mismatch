# Find the Mismatch? — Product Requirements Document (PRD)

## 1. Project Title
**Find the Mismatch?**

---

## 2. High-Level Description
Find the Mismatch? is an iOS SwiftUI game using the MVVM architectural pattern.  
The player interacts with animated cards via gestures under time pressure.  
Two gameplay modes exist: **Find the Non-Matching** and **Sort the Cards**.

The game:
- Works in **portrait and landscape**
- Uses **dynamic card counts**
- Always displays a **top header** (hearts, timer bar, game progress)
- Uses **SwiftUI**, **MVVM**, English naming, and contains **no comments in code**

---

## 3. Technology
- iOS (latest stable version)
- SwiftUI (latest version)
- MVVM structure
- Swift Concurrency for timers and animation triggers
- Adaptive UI for both device orientations
- No code comments, English identifiers

---

## 4. Game Entities

### Card
Each card has:
- `title` (String)
- `emoji` (String)
- `category` (Category)

### Card States
A card may be:
- Visible
- Correctly selected (green highlight, 70% opacity, 3s fade)
- Incorrectly selected (red highlight, 70% opacity, 3s fade)
- Removed (animated disappearance)
- Moved (drag gesture in Sort mode)

---

## 5. Categories
The game includes 12 unique categories, minimal starting set:

- Animals  
- Food  
- Objects  
- Weather *(added category)*  

More categories may be included but not removed.

---

## 6. Player Lives (Hearts)

Player starts with **3 hearts**.

Display rules:
- If hearts ≤ 3 → show separate emojis (❤ ❤ ❤)
- If hearts > 3 → show `"4 × ❤"` format

A wrong selection removes one heart.

---

## 7. Timer Bar

Displayed always at the top.

Behavior:
- Smooth shrinking animation based on remaining time
- Colors:
  - > 40% → green
  - 25%–40% → yellow
  - < 25% → red + blinking animation

Timer expiration ends the round.

---

## 8. Game Modes

---

### Mode A — Find the Non-Matching

**Objective**: Tap cards that do **not** fit a hidden chosen category.

Flow:
1. The system selects a category.
2. Any number of cards appears on the board.
3. Player taps cards:
   - Correct: green highlight (3s fade)
   - Incorrect: red highlight (3s fade) + heart loss
4. Round ends when:
   - All correct category cards are identified
   - Hearts reach zero
   - Timer expires

Required gesture: **tap**

Animations:
- Fade green/red overlays
- Possible card removal if needed

---

### Mode B — Sort the Cards

**Objective**: Drag cards into colored category areas.

Board:
- Divided into **N + 1 zones**:
  - N category zones (bright random colors)
  - 1 neutral zone (default app background)

Flow:
1. Cards start in the neutral zone.
2. Player drags a card into a category zone.
3. On drop:
   - Correct zone → green highlight
   - Wrong zone → red highlight + heart loss

Round ends when:
- All cards sorted correctly
- Hearts reach zero
- Timer expires

Required gesture: **drag**

Animations:
- Same highlight rules
- Cards animate to their dropped position

---

## 9. UI Layout

### Top Section (always visible)
- Heart display
- Timer bar
- Game status text (round, mode name, instructions)

### Center
- Card grid (Mode A)
- Category board layout (Mode B)
- Fully adaptive to unknown card count and orientation

### Bottom
- New game button
- Optional contextual controls

---

## 10. Required Gestures & Animations

### Gestures
- Tap
- Drag

### Animations
- Highlight fade (green/red, 70% opacity, 3s duration)
- Card removal fade or scale-out
- Timer bar blinking under 25%

---

## 11. MVVM File Structure

### Models
- `/Sources/Models/Card.swift`
- `/Sources/Models/Category.swift`
- `/Sources/Models/GameState.swift`
- `/Sources/Models/GameMode.swift`

### ViewModels
- `/Sources/ViewModels/GameViewModel.swift`
- `/Sources/ViewModels/FindMismatchViewModel.swift`
- `/Sources/ViewModels/SortCardsViewModel.swift`
- `/Sources/ViewModels/TimerViewModel.swift`

### Views
- `/Sources/Views/RootView.swift`
- `/Sources/Views/GameHeaderView.swift`
- `/Sources/Views/CardView.swift`
- `/Sources/Views/FindMismatchView.swift`
- `/Sources/Views/SortCardsView.swift`
- `/Sources/Views/TimerBarView.swift`

---

## 12. Round End Conditions
- All cards correctly handled according to mode
- Hearts depleted
- Timer reaches zero

---

## 13. Orientation Support
- UI layouts must adapt to **portrait** and **landscape**
- Top header always stays at top logically (horizontal top in landscape)

---

## 14. New Game
- Player can start a new game at any time
- Resets:
  - Timer
  - Hearts
  - Cards
  - Mode state

---

# End of Document
