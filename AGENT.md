# Elementa — Agent Log

## Project Overview
Elementa is an offline chemistry reference application for Flutter that renders the complete periodic table of elements as an interactive, zoomable, and pannable grid. Users can tap any element tile to inspect detailed chemical and physical properties, including atomic mass, classification category, period, group, and a descriptive summary. The app is built with Flutter and Dart, utilizing a clean modular architecture (`models/`, `data/`, `widgets/`, `screens/`). Developed across a disciplined 6-release roadmap, each release delivers a strictly superior, fully functional application.

## Data Source
The dataset consists of all 118 chemical elements from Atomic Number 1 (Hydrogen) to 118 (Oganesson), sourced from standard IUPAC periodic table standards and bundled locally as JSON in `assets/data/elements.json`. Each entry includes atomic number, symbol, name, atomic mass, chemical category, period, group, standard periodic-table grid coordinates (`row` 1-10 and `column` 1-18, including f-block offset positioning), and an informative 1-2 sentence description.

## Release Roadmap
### Release 1 — Minimum Usable App with Decent Features
- Set up Flutter project structure: main.dart, data/, screens/, models/, widgets/
- Build a complete dataset of all 118 elements as a bundled JSON in assets/data/elements.json — each entry: atomic number, symbol, name, atomic mass, category (e.g. alkali metal, noble gas, transition metal), period, group, standard periodic-table grid position (row/column, including the separated lanthanide/actinide rows)
- Element model class with JSON parsing
- Full periodic table grid rendered accurately to standard layout (18 groups × 7 periods, plus the lanthanide/actinide rows positioned correctly below the main grid) — use a GridView or custom Stack/Table layout with precise row/column placement, not a simplified list
- Each element box shows atomic number, symbol, and name (abbreviated if needed) at a glance, colored by category (color-coded legend included on screen)
- Tapping a box opens a detail popup/dialog showing: name, symbol, atomic number, atomic mass, category, period, group, and a short description (1-2 sentences)
- Pinch-to-zoom and pan support on the grid so all elements are reachable and readable on phone screens (the full table is wide — this is essential for usability, not optional)
- Basic styling: legible typography, clear color coding by element category, clean background — doesn't need to be fully polished yet, but should look intentional
- Deliverable: a real, usable app. Someone could open this, browse the full accurate periodic table, zoom/pan to read any element, tap any box, and see correct core details. Ship-able as a bare v1.

### Release 2 — Visual Polish Pass
- Apply a proper design system: theme file (theme/app_theme.dart) with a refined color palette per category (accessible, visually distinct, not garish), typography via google_fonts
- Polish the detail popup into a proper bottom sheet or dialog card: rounded corners, category color accent, better information hierarchy (symbol/name large, secondary stats smaller)
- Add a persistent, tappable legend (category → color) so users can identify categories without guessing
- Consistent spacing scale (8/16/24/32)
- Deliverable: same functionality as R1, now looking considered and professional

### Release 3 — Search & Filter
- Add a search bar (app bar or dedicated row) to find an element by name or symbol, which highlights/scrolls to and briefly pulses the matching box on the grid
- Add filter chips by category (e.g. "Show only Noble Gases") that dim/hide non-matching elements on the grid
- Deliverable: same core functionality, now with fast lookup for users who know what they're looking for

### Release 4 — Deeper Element Data
- Expand the dataset per element: electron configuration, melting/boiling point, density, discovery year, state at room temperature
- Expand the detail popup into a full detail screen (rather than just a dialog) with this deeper data laid out clearly, reachable via "See more" from the popup
- Add previous/next element navigation within the detail screen (swipe or arrow buttons) so users can browse sequentially without returning to the grid
- Deliverable: same app, now a genuinely deep reference tool, not just a glance-and-close table

### Release 5 — Motion & Delight
- Add flutter_animate dependency
- Animated popup/detail transitions (scale/fade in from the tapped box's position)
- Smooth pinch-zoom/pan easing on the grid
- Subtle hover/press animation on element boxes (scale down slightly on tap)
- Animated search highlight (pulse effect on the matched box)
- Deliverable: same app, now feels responsive and polished in motion, not just static

### Release 6 — Store-Ready Completion
- Full responsive testing: confirm the grid, zoom/pan, and detail screens work well on both phone and tablet aspect ratios
- Accessibility pass: color contrast check per category (especially against text), semantic labels for screen readers on each element box, adjustable text scaling support in detail views
- App icon, splash screen, finalized pubspec.yaml metadata (name: "Elementa", version, description)
- Performance pass: confirm smooth 60fps zoom/pan on the full grid, no jank from rendering 118 boxes at once (consider RepaintBoundary where needed)
- Final AGENT.md update: mark project "Complete Product", list any deliberately excluded features under "Future Ideas" (e.g. quiz mode, electron shell visualizer, trend graphs like electronegativity across periods) so scope is explicit
- Deliverable: a Play Store–submission-ready build — polished, tested, documented, no placeholder content remaining

## Status Log
### Release 1 — Complete (Session 1)
- Completed:
  - Created `elementa` Flutter application with dark theme (`#0F172A`).
  - Generated complete, comprehensive dataset of all 118 verified elements in `assets/data/elements.json` with atomic numbers (1-118), chemical symbols, names, atomic masses, categories, periods (1-7), groups (1-18 or null), grid coordinates (rows 1-10, columns 1-18), and educational summaries.
  - Implemented `ElementData` model with full serialization and category color mappings.
  - Implemented `ElementRepository` with memory caching, lookup by atomic number, symbol, grid coordinate, and category filter.
  - Built interactive 18-column periodic table grid layout (`PeriodicTableGrid`) with standard IUPAC periods 1-7 and separated f-block (Lanthanides on row 9, Actinides on row 10, placeholder series boxes in row 6/7 column 3).
  - Built `InteractiveViewer` integration enabling pinch-to-zoom (0.25x to 3.5x scale) and smooth 2D panning, plus zoom in/out/reset action buttons in the AppBar.
  - Implemented interactive `ElementBox` tiles displaying atomic number, symbol, name, and category accents.
  - Implemented `ElementDetailDialog` showing element overview, symbol badge, atomic mass, period, group, and descriptive summary.
  - Implemented horizontal scrollable category legend chip bar with 10 chemical category indicators.
  - Added comprehensive test suites: 11 tests verifying 118-element integrity, zero duplicate symbols/numbers, coordinate bounds, f-block placement, repository methods, and widget smoke tests (`All tests passed!`, `flutter analyze` 0 issues).
- Deferred:
  - Release 2: Visual styling elevation, Google Fonts (e.g. Orbitron / Inter / Roboto Mono), element box visual hierarchy, element count badges.
  - Release 3: Search bar (symbol, name, atomic number), category filter chips, tap-to-focus on table.
  - Release 4: Full-page element detail view with rich data tabs (physical states, melting/boiling points, electron configurations, electronegativity).
  - Release 5: Fluid animations with `flutter_animate`, hero transitions, pulse effects.
  - Release 6: Store-ready build, accessibility semantic labels, icon/splash, Play Store preparation.
- Decisions:
  - Grid Coordinates: 10 rows x 18 columns canvas layout. Main table on rows 1-7; visual spacer on row 8; Lanthanides (57-71) on row 9, columns 3-17; Actinides (89-103) on row 10, columns 3-17.
  - Category Color Palette: 10 distinct hex colors spanning red, orange, blue, cyan, emerald, lime, purple, pink, rose, and slate.
  - Viewport Scaling: Default view centered with min scale 0.25x and max scale 3.5x for crisp readability on mobile screens.
- Keystore & Splash Setup:
  - Generated release keystore at `android/app/upload-keystore.jks` with default credentials (`storePassword=android`, `keyPassword=android`, `keyAlias=upload`).
  - Configured `android/key.properties` and wired `signingConfigs.release` in `android/app/build.gradle.kts`.
  - Excluded `key.properties` and keystores in `.gitignore`.
  - Generated 512x512 app icon at `assets/icon/app_icon_512.png` and standard Android launcher mipmap densities (`mdpi`, `hdpi`, `xhdpi`, `xxhdpi`, `xxxhdpi`).
  - Implemented custom splash screen in `drawable/launch_background.xml` and `drawable-v21/launch_background.xml` featuring centered `launch_image.png` with deep slate background (`#0F172A`).
  - Verified with successful `flutter build apk --release` (built `app-release.apk` cleanly).
- App state: Stable and fully usable Release 1 with release signing & splash screen.

## Known Issues / TODO
- None. All automated tests pass, zero analyze warnings, release build succeeds.

