# qBank Lynx

A lightweight, offline Android app for 2nd year medical students to browse, study, and track progress across exam preparation topics. Built with Flutter using a dark Midnight Blue gradient theme.

---

## Overview

qBank Lynx is a question bank companion that organizes study topics by **Subject → Paper → Unit**. Each topic includes an importance rating, past exam year tags, bullet-point descriptions, and textbook references. Users can mark topics as "done" with a checkbox, and the app persists progress locally so students can pick up where they left off.

### Subjects Covered

| Subject | Paper 1 Units | Paper 2 Units |
|---------|---------------|---------------|
| **Pathology** | 13 CSVs | 14 CSVs |
| **Pharmacology** | 7 CSVs | 5 CSVs |
| **Microbiology** | 5 CSVs | 6 CSVs |

### Core Features

- **3-subject dashboard** with circular progress rings and completion percentages
- **Paper-level progress bars** showing per-paper completion
- **Topic list** with filter (Essay / Short Answer / All) and sort (Importance / Recent / Alphabetical)
- **Topic detail page** with key points, importance dots, year-asked tags, and textbook references
- **Persistent progress** — checkboxes survive app restarts via SharedPreferences
- **Offline-first** — all CSV data bundled inside the APK, no internet required

---

## Tech Stack

| Layer | Technology | Version | Purpose |
|-------|-----------|---------|---------|
| Framework | Flutter | 3.x | Cross-platform UI toolkit |
| Language | Dart | >=3.0.0 | Application logic |
| State Management | Provider | ^6.1.1 | Reactive state via ChangeNotifier |
| CSV Parsing | csv | ^6.0.0 | Parse bundled CSV asset files |
| Local Persistence | shared_preferences | ^2.2.2 | Store done-checkbox state as JSON |
| Typography | google_fonts | ^6.1.0 | Inter font family |
| Linting | flutter_lints | ^4.0.0 | Static analysis rules |
| CI/CD | GitHub Actions | — | Build release APK without Android Studio |
| Min Android SDK | API 26 | Android 8.0+ | ~90% device coverage |

---

## Directory Map

```
qBank Lynx/
│
├── .github/
│   └── workflows/
│       └── android.yml               # GitHub Actions: builds release APK
│
├── assets/
│   └── questions/                    # All CSV data bundled as Flutter assets
│       ├── Pathology/
│       │   ├── paper1/
│       │   │   ├── Cell Injury, Cell Death and Adaptations.csv
│       │   │   ├── Environmental and Nutritional Disorders.csv
│       │   │   ├── Genetic disorders.csv
│       │   │   ├── Hemodynamic Disorders, Thromboembolism and Shock.csv
│       │   │   ├── Immunology.csv
│       │   │   ├── Infancy and Diseases of Childhood.csv
│       │   │   ├── Infectious Diseases.csv
│       │   │   ├── Inflammation and Repair.csv
│       │   │   ├── Neoplasia.csv
│       │   │   ├── Platelets.csv
│       │   │   ├── Red Blood Cells.csv
│       │   │   ├── The Cell as a Unit of Health and Disease.csv
│       │   │   └── White Blood Cells.csv
│       │   └── paper2/
│       │       ├── Blood Vessels.csv
│       │       ├── Bones, Joints and Soft Tissue Tumors.csv
│       │       ├── Breast.csv
│       │       ├── Central Nervous System.csv
│       │       ├── Endocrinology.csv
│       │       ├── Female Genital Tract.csv
│       │       ├── Gastrointestinal System.csv
│       │       ├── Head and Neck.csv
│       │       ├── Heart.csv
│       │       ├── Kidney.csv
│       │       ├── Liver, Gall bladder and Pancreas.csv
│       │       ├── Male Genital Tract.csv
│       │       ├── Respiratory System.csv
│       │       └── Skin.csv
│       │
│       ├── Pharmacology/
│       │   ├── paper1/
│       │   │   ├── Autacoids.csv
│       │   │   ├── Autonomic Nervous System.csv
│       │   │   ├── Cardiovascular System.csv
│       │   │   ├── Central Nervous System.csv
│       │   │   ├── General Pharmacology.csv
│       │   │   ├── Peripheral Nervous System.csv
│       │   │   └── Respiratory System.csv
│       │   └── paper2/
│       │       ├── Anti-Microbial Drugs.csv
│       │       ├── Gastrointestinal System.csv
│       │       ├── Hormones.csv
│       │       ├── Miscellaneous Drugs.csv
│       │       └── Neoplastic Drugs.csv
│       │
│       └── Microbiology/
│           ├── paper1/
│           │   ├── General Microbiology.csv
│           │   ├── Hospital Infection Control.csv
│           │   ├── Immunology.csv
│           │   ├── Miscellaneous Bacteria and Microbial Zoonotic diseases.csv
│           │   └── Skin, Soft tissues and Musculoskeletal System Infections.csv
│           └── paper2/
│               ├── Bloodstream and Cardiovascular Infections.csv
│               ├── Central Nervous System Infections.csv
│               ├── Gastrointestinal Infections.csv
│               ├── Genito-Urinary and Sexually Transmitted Infections.csv
│               ├── Hepatobiliary Infections.csv
│               └── Respiratory Tract Infections.csv
│
├── lib/
│   ├── main.dart                         # Entry point, initializes Flutter bindings
│   ├── app.dart                          # MaterialApp, theme, Provider setup
│   │
│   ├── models/
│   │   ├── topic.dart                    # Topic data class + Reference parser
│   │   ├── topic_type.dart               # TopicType enum (essay / short)
│   │   └── paper.dart                    # Paper data class
│   │
│   ├── providers/
│   │   └── progress_provider.dart        # SharedPreferences-backed done-state
│   │
│   ├── services/
│   │   ├── csv_loader.dart               # Reads CSV from AssetBundle → List<Topic>
│   │   ├── asset_registry.dart           # Hardcoded subject/paper/file tree
│   │   └── topic_cache.dart              # In-memory cache to avoid re-parsing CSVs
│   │
│   ├── screens/
│   │   ├── home_screen.dart              # 3 subject cards with progress rings
│   │   ├── paper_list_screen.dart        # Paper cards with progress bars
│   │   ├── topic_list_screen.dart        # Filterable/sortable topic list
│   │   └── topic_detail_screen.dart      # Full topic view (descriptions + references)
│   │
│   ├── widgets/
│   │   ├── gradient_scaffold.dart        # Scaffold with dark gradient background
│   │   ├── subject_card.dart             # Home screen subject card
│   │   ├── progress_ring.dart            # Circular progress indicator with % label
│   │   ├── topic_tile.dart               # Topic list item with checkbox
│   │   ├── importance_dots.dart          # ●●●●○○○ importance rating dots
│   │   ├── year_tags.dart                # Year-asked chip tags
│   │   └── filter_bar.dart              # Essay/Short/All filter + sort dropdown
│   │
│   └── utils/
│       ├── constants.dart                # Color palette, gradient defs, dimensions
│       └── id_utils.dart                 # ID parsing, book code formatting
│
├── .gitignore
├── analysis_options.yaml                 # Dart lint rules
├── pubspec.yaml                          # Flutter dependencies + asset declaration
├── README.md                             # Setup + usage guide
└── project.md                            # This file
```

---

## CSV Data Format

Every CSV file follows this schema:

```csv
Id,Title,Descriptions,HasPreviouslyBeenAsked,Importance,YearsAsked,ProbableCases,References
```

### Column Reference

| Column | Type | Description | Example |
|--------|------|-------------|---------|
| `Id` | String | Unique hierarchical ID. Prefix determines type: `E_` = Essay, `S_` = Short Answer | `E_PH_1.16.4.1.1` |
| `Title` | String | Topic name displayed in the UI | `Salicylates` |
| `Descriptions` | String (multiline) | Bullet points to study, newline-separated with `- ` prefix | `- Mechanism of Action\n- Uses` |
| `HasPreviouslyBeenAsked` | Boolean | Whether this topic has appeared in past exams | `True` |
| `Importance` | Integer (1-7) | High-yield rating. 7 = most frequently asked | `5` |
| `YearsAsked` | Semicolon-separated | Dates when topic appeared in exams (format: `YYYY-MM`) | `2023-02;2015-02` |
| `ProbableCases` | String | Clinical case notes (mostly unused) | |
| `References` | Semicolon-separated | Textbook refs in `@book?` format with page after `#` | `@book?n=PH-kdtemp&ed=8&vol=0#212` |

### ID Prefix Convention

- **`E_`** → Essay-type question (long answer, detailed preparation)
- **`S_`** → Short-answer question (brief, focused preparation)
- The prefix after `E_`/`S_` indicates subject: `PH` = Pharmacology, `PA` = Pathology, `MB` = Microbiology

### Reference Format

References follow the pattern: `@book?n=<code>&ed=<edition>&vol=<volume>#<page>`

| Parameter | Meaning |
|-----------|---------|
| `n` | Book code (e.g., `PH-kdtemp` = KDT Pharmacology, `PH-tarav` = Tara Pharmacology) |
| `ed` | Edition number |
| `vol` | Volume number |
| `#` | Page number (after hash) |

Book codes are formatted for display via `IdUtils.formatBookCode()`:

| Raw Code | Display Name |
|----------|-------------|
| `PH-kdtemp` | KDT |
| `PH-tarav` | Tara |
| `PA-kdtemp` | KDT |
| `PA-tarav` | Tara |
| `MB-kdtemp` | KDT |
| `MB-tarav` | Tara |

---

## Architecture

### Data Flow

```
CSV Files (assets/)
    │
    ▼
CsvLoader (parses CSV → List<Topic>)
    │
    ▼
TopicCache (in-memory cache, avoids re-parsing)
    │
    ▼
Screens (TopicListScreen, HomeScreen, PaperListScreen)
    │
    ▼
ProgressProvider (reads/writes done-state to SharedPreferences)
```

### State Management

The app uses **Provider** with a single `ProgressProvider` (ChangeNotifier) at the root:

```dart
ChangeNotifierProvider(
  create: (_) => ProgressProvider()..load(),
  child: MaterialApp(...)
)
```

`ProgressProvider` manages:
- `Set<String> _doneTopics` — in-memory set of completed topic IDs
- Persisted to SharedPreferences as JSON under the key `done_topics`
- Provides: `isDone(id)`, `toggleDone(id)`, `doneCount(ids)`, `progressForIds(ids)`

### Caching

`TopicCache` is a singleton that stores parsed topics in memory:

```dart
final _cache = <String, List<Topic>>{};
```

Once a CSV is loaded, subsequent accesses return the cached result. This prevents redundant re-parsing when navigating between screens.

### Asset Registry

Since Flutter cannot dynamically enumerate bundled assets at runtime, `AssetRegistry` hardcodes the subject → paper → file mapping. When adding new CSV files, you must also add the filename to this registry.

---

## Screens

### 1. Home Screen

- Displays 3 subject cards (Pathology, Pharmacology, Microbiology)
- Each card shows: subject name, topic completion count, circular progress ring
- Tap → navigates to PaperListScreen

### 2. Paper List Screen

- Lists Paper 1 and Paper 2 for the selected subject
- Each paper card shows: name, topic count, completion count, linear progress bar, circular progress ring
- Tap → navigates to TopicListScreen

### 3. Topic List Screen

- Scrollable list of all topics across all units in that paper
- **Filter bar**: All | Essay | Short (filters by TopicType from Id prefix)
- **Sort dropdown**: Importance (default) | Most Recent | A-Z
- Each topic tile shows: type badge (E/S), title, importance dots, year-asked tags, done checkbox
- Checkbox toggles done state (persisted)
- Tap → navigates to TopicDetailScreen

### 4. Topic Detail Screen

- Full topic view with:
  - Type chip (Essay / Short Answer) + "Previously Asked" badge
  - Importance dots with numeric label (e.g., `●●●●●○○ 5/7`)
  - Times asked count
  - Year-asked tags (all years displayed as chips)
  - Key Points section (parsed from Descriptions column)
  - References section (formatted book + page info)
  - Done toggle in AppBar

---

## Design System

### Color Palette

| Name | Hex | Usage |
|------|-----|-------|
| Gradient Start | `#1A2980` | Deep blue, gradient origin |
| Gradient End | `#26D0CE` | Cyan, gradient destination |
| Surface | `#0D1B3E` | Scaffold background |
| Card Background | `#162350` | Card/tile backgrounds |
| Accent Cyan | `#26D0CE` | Progress indicators, links, badges |
| Text Primary | `#FFFFFF` | Main text |
| Text Secondary | `#B0BEC5` | Subtitles, descriptions |
| Done Green | `#4CAF50` | Completed checkboxes |
| Importance Gold | `#FFD700` | Importance rating dots |
| Essay Purple | `#7C4DFF` | Essay type badges |
| Short Orange | `#FF6E40` | Short answer type badges |

### Gradients

| Name | Colors | Direction | Usage |
|------|--------|-----------|-------|
| Dark Gradient | `#0D1B3E → #1A2980` | Top → Bottom | Screen backgrounds |
| Card Gradient | `#1E3A7D → #22B1CE` | Top-Left → Bottom-Right | Subject cards |

### Typography

- **Font Family**: Inter (via google_fonts)
- **Weights Used**: Regular (400), Medium (500), SemiBold (600), Bold (700)

### Spacing

| Token | Value |
|-------|-------|
| `paddingSmall` | 8px |
| `paddingMedium` | 16px |
| `paddingLarge` | 24px |
| `radiusSmall` | 8px |
| `radiusMedium` | 12px |
| `radiusLarge` | 16px |

---

## CI/CD — GitHub Actions

**File**: `.github/workflows/android.yml`

### Triggers

- **Push to `main`**: automatic build
- **Manual dispatch**: trigger from GitHub Actions UI

### Build Pipeline

```
Checkout → Setup Flutter 3.24.5 → flutter pub get → flutter analyze → flutter build apk --release → Upload artifact
```

### Key Details

- Runs on `ubuntu-latest` — no Android Studio required
- Uses `subosito/flutter-action@v2` to install Flutter SDK
- Builds a release APK: `build/app/outputs/flutter-apk/app-release.apk`
- APK is uploaded as a downloadable workflow artifact named `qbank-lynx-apk`
- Downloads are available from the **Actions → Artifacts** section of the GitHub repo

---

## Setup & Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) >=3.0.0
- No Android Studio needed

### Initial Setup

```bash
# Clone the repository
git clone <your-repo-url>
cd "qBank Lynx"

# Generate platform directories (android/, ios/, etc.)
flutter create .

# Install dependencies
flutter pub get

# Run on connected device/emulator
flutter run
```

### Building the APK Locally

```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

### Building via GitHub (No Local Setup)

1. Push code to `main` branch
2. Go to **Actions** tab on GitHub
3. Click **Build Android APK**
4. Wait for the workflow to complete (~3-5 minutes)
5. Download the APK from **Artifacts** section

---

## Adding New Topics

### Step 1: Add the CSV file

Place your CSV in the correct directory:

```
assets/questions/<Subject>/<paperN>/<UnitName>.csv
```

Example:
```
assets/questions/Pharmacology/paper1/Autacoids.csv
```

### Step 2: Register in Asset Registry

Open `lib/services/asset_registry.dart` and add the filename to the appropriate paper's `csvFiles` list:

```dart
Paper(
  name: 'Paper 1',
  directoryName: 'paper1',
  csvFiles: [
    'Existing Unit.csv',
    'New Unit.csv',  // ← add here
  ],
)
```

### Step 3: Commit and push

```bash
git add .
git commit -m "Add New Unit topics"
git push origin main
```

The GitHub Actions workflow will automatically build a new APK.

---

## File-by-File Reference

### Entry Point

| File | Description |
|------|-------------|
| `lib/main.dart` | Flutter entry point. Calls `WidgetsFlutterBinding.ensureInitialized()` and runs the app. |
| `lib/app.dart` | Creates `ChangeNotifierProvider<ProgressProvider>`, configures `MaterialApp` with dark theme and Inter font. |

### Models

| File | Description |
|------|-------------|
| `lib/models/topic.dart` | `Topic` class with all CSV fields. Includes `Topic.fromCsvRow()` factory and `Reference.parse()` for `@book?` format. Has computed properties `timesAsked` and `parsedDescriptionLines`. |
| `lib/models/topic_type.dart` | `TopicType` enum with values `essay` and `short`. Derives from Id prefix (`E_`/`S_`). |
| `lib/models/paper.dart` | `Paper` data class: `name`, `directoryName`, and `csvFiles` list. |

### Services

| File | Description |
|------|-------------|
| `lib/services/csv_loader.dart` | Static `loadFromAsset(path)` method. Uses `csv` package to parse CSV from Flutter's `AssetBundle`. Maps headers to values, skips empty rows, returns `List<Topic>`. |
| `lib/services/asset_registry.dart` | `AssetRegistry.subjects` — static list of `SubjectDef` objects defining the entire subject/paper/file tree. `AssetPath()` helper builds asset paths. |
| `lib/services/topic_cache.dart` | Singleton `TopicCache.instance`. Caches parsed topics by asset path to avoid redundant CSV parsing. |

### Providers

| File | Description |
|------|-------------|
| `lib/providers/progress_provider.dart` | `ProgressProvider` extends `ChangeNotifier`. Stores `Set<String>` of completed topic IDs. Loads/saves to SharedPreferences as JSON. Provides `isDone()`, `toggleDone()`, `doneCount()`, `progressForIds()`. |

### Screens

| File | Description |
|------|-------------|
| `lib/screens/home_screen.dart` | `StatefulWidget`. Async-loads all topic IDs on init. Displays 3 `SubjectCard` widgets with progress rings. |
| `lib/screens/paper_list_screen.dart` | `StatefulWidget`. Async-loads topic IDs per paper. Shows paper cards with progress bars and rings. |
| `lib/screens/topic_list_screen.dart` | `StatefulWidget`. Loads all topics for a paper. Supports filtering by type (Essay/Short/All) and sorting (Importance/Recent/A-Z). |
| `lib/screens/topic_detail_screen.dart` | `StatelessWidget`. Full topic display: type badge, importance dots, year tags, parsed descriptions, formatted references, done toggle. |

### Widgets

| File | Description |
|------|-------------|
| `lib/widgets/gradient_scaffold.dart` | `Scaffold` wrapper with dark gradient `Container` background. |
| `lib/widgets/subject_card.dart` | Home screen card with icon, title, subtitle, and `ProgressRing`. |
| `lib/widgets/progress_ring.dart` | Circular `CircularProgressIndicator` with percentage text center. |
| `lib/widgets/topic_tile.dart` | List item: type badge, title, importance dots, year tags, checkbox, chevron icon. |
| `lib/widgets/importance_dots.dart` | Row of 7 dots, filled/gold for achieved importance, dim for remaining. |
| `lib/widgets/year_tags.dart` | Horizontal `Wrap` of year chips. Shows max 4 + overflow count. |
| `lib/widgets/filter_bar.dart` | Row of filter chips (All/Essay/Short) + `PopupMenuButton` sort dropdown. |

### Utils

| File | Description |
|------|-------------|
| `lib/utils/constants.dart` | `AppColors` (color palette + gradients), `AppDimensions` (spacing/radius tokens). |
| `lib/utils/id_utils.dart` | `IdUtils.formatBookCode()` — maps raw book codes (e.g., `PH-kdtemp`) to display names (e.g., `KDT`). |

---

## Performance Notes

- **CSV parsing** happens once per file via `TopicCache`. Subsequent navigation uses the in-memory cache.
- **Progress state** is stored as a single JSON-encoded string in SharedPreferences (fast read/write).
- **Asset loading** uses Flutter's built-in `rootBundle.loadString()` which reads from the bundled asset archive.
- The app holds no network connections — fully offline.

---

## Future Enhancements

Potential additions for later versions:

- [ ] Search/filter topics by keyword
- [ ] Random topic quiz mode for quick revision
- [ ] Dark/light theme toggle
- [ ] Custom subject color themes
- [ ] Export progress as PDF/CSV
- [ ] Import CSV files from device storage
- [ ] iOS build support via GitHub Actions
- [ ] Animations for page transitions and checkbox toggles
- [ ] In-app CSV editor for adding topics without rebuilding
