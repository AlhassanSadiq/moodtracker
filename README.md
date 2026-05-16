# Mood Tracker

A polished Flutter Web application for tracking daily mood entries with a horizontal animated timeline.

## Features

- **Mood Selection** — Log Happy, Neutral, or Sad moods with a single tap
- **Custom Painted Faces** — All mood expressions are drawn using Flutter `CustomPainter` with `drawCircle`, `drawArc`, `drawPath`, and `drawLine` — no emojis or icon fonts
- **Horizontal Timeline** — Last 7 entries shown in a scrollable, color-coded timeline
- **Entry Animations** — Tap any timeline card to trigger a bounce + glow animation
- **Responsive Design** — Works on desktop, tablet, and mobile browsers
- **Provider State Management** — Clean `ChangeNotifier`-based architecture

## Tech Stack

- Flutter 3.x (Web)
- Dart 3.x
- `provider` ^6.1.2
- `intl` ^0.20.2

## Project Structure

```text
lib/
├── models/
│   └── mood_entry.dart        # MoodType enum + MoodEntry model
├── painters/
│   └── mood_face_painter.dart # CustomPainter for all faces
├── providers/
│   └── mood_provider.dart     # ChangeNotifier state management
├── widgets/
│   ├── mood_button.dart       # Selectable mood button
│   ├── timeline_item.dart     # Horizontal timeline card
│   └── animated_mood_card.dart# Bounce/glow animation wrapper
├── screens/
│   └── home_screen.dart       # Single-screen UI
└── main.dart
```

## Setup Instructions

### Prerequisites

- Flutter SDK ≥ 3.10.0 ([install guide](https://docs.flutter.dev/get-started/install))
- Chrome or any modern browser for web

### Run locally

```bash
git clone <your-repo-url>
cd mood_tracker
flutter pub get
flutter run -d chrome
```

## Build Instructions

```bash
flutter build web --release
```

Output is in `build/web/`.

## Deployment — Vercel

This project is configured for [Vercel](https://vercel.com) deployment.

### Manual deploy via Vercel CLI

```bash
# Install Vercel CLI
npm i -g vercel

# Build
flutter build web --release

# Deploy
vercel --prod build/web
```

### Vercel dashboard deploy

1. Push this repo to GitHub
2. Import the repo in [vercel.com/new](https://vercel.com/new)
3. Set **Framework Preset** to **Other**
4. Set **Build Command** to: `flutter build web --release`
5. Set **Output Directory** to: `build/web`
6. Click **Deploy**

> Note: Vercel build runners do not have Flutter pre-installed. For CI-based builds, add a `vercel.json` (already included) that skips the Vercel build step and deploys the pre-built `build/web` output directly, or use a custom build image.

### Quick deploy (pre-built)

Build locally, then deploy only the output:

```bash
flutter build web --release
cd build/web
vercel --prod
```

## Mood Colors

| Mood    | Color            | Hex       |
|---------|------------------|-----------|
| Happy   | Yellow / Orange  | `#FFB703` |
| Neutral | Blue / Grey      | `#90A4AE` |
| Sad     | Purple / Indigo  | `#7E57C2` |

## License

MIT
