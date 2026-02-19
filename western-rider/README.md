# Frontier Gallop (Godot 4)

A modular 3D western riding game prototype designed for expansion into a full open-area game.

## Why Godot 4

- **Fast iteration** for gameplay feel (horse acceleration, turn radius, camera lag) using GDScript.
- **Modern 3D renderer** (Forward+) handles desert lighting, fog, and day/night transitions.
- **Open-source + lightweight** so the project is easy to share, fork, and scale.
- **Scene-based architecture** fits modular gameplay systems (missions, world activity, FX, UI).

## Gameplay Concept

You are a frontier rider traversing a stylized western biome of dunes, canyon lanes, and sparse frontier routes.

### Core Loop

1. **Explore** the desert zone and discover mission markers.
2. **Ride** with layered horse gaits (walk, trot, gallop) and stamina management.
3. **Interact** with race trigger points and world threats (bandit rider AI).
4. **Complete objectives** to gain money/reputation and unlock horse upgrades.

### Included Mission Type

- **Timed Horse Race: "Dust Sprint"**
  - Press `E` to start.
  - Hit all checkpoints before timer expires.
  - On success: earn money + reputation.
  - On failure: mission fails and rewards are skipped.

### Progression

- Runtime progression values:
  - Money
  - Reputation
  - Horse upgrades (`speed`, `stamina` tiers)
- Win/fail conditions are mission-explicit (finish checkpoints before time limit).

## Key Feel / Polish Features

- Heavy acceleration/brake tuning in `HorseController`.
- Turn-radius reduction at higher speed.
- Smooth third-person camera with velocity lag bias.
- Camera shake system triggered by high-speed riding.
- Dust particle driver tied to horse speed and grounded state.
- Gallop rhythm event system for hoofbeat audio sync.
- Dynamic day/night sunlight + sky tint cycling.

## Project Structure

```text
western-rider/
├── project.godot
├── README.md
├── scenes/
│   ├── Main.tscn
│   └── HUD.tscn
├── scripts/
│   ├── core/
│   │   └── GameManager.gd
│   ├── player/
│   │   ├── HorseController.gd
│   │   └── ThirdPersonCameraRig.gd
│   ├── world/
│   │   ├── DesertWorldBuilder.gd
│   │   ├── DayNightCycle.gd
│   │   └── BanditRiderAI.gd
│   ├── missions/
│   │   └── RaceMission.gd
│   ├── effects/
│   │   ├── SpeedShake.gd
│   │   └── DustEmitter.gd
│   ├── audio/
│   │   └── GallopAudioController.gd
│   └── ui/
│       └── HUDController.gd
└── assets/
    ├── materials/
    ├── models/
    └── sounds/
```

## How to Run

1. Install **Godot 4.2+**.
2. Open Godot Project Manager.
3. Import folder: `western-rider/`.
4. Run main scene (`scenes/Main.tscn`) or press **Play**.

## Expansion Roadmap

1. **Combat layer**
   - Revolver / rifle shooting from horseback.
   - Aim sway based on horse gait.
2. **NPC frontier towns**
   - Shops, stables, saloons, bounty boards.
3. **Mission system growth**
   - Delivery missions through dangerous routes.
   - Bounty chase + capture flows.
   - Procedural race variants.
4. **World simulation**
   - Wildlife herds, sandstorms, caravans.
5. **Narrative mode**
   - Factions, rival gangs, persistent story arcs.

## Notes

This is a production-oriented foundation (modular scripts + mission/progression plumbing), not a single-file tutorial snippet.
