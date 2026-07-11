name: qBank Lynx

A simple, offline question bank app for 2nd year medical students covering Pathology, Pharmacology, and Microbiology.

## Features

- Browse topics organized by Subject → Paper → Unit
- **Essay** and **Short Answer** question type filtering
- **Importance rating** (1-7) with visual dots
- **Year tags** showing when topics appeared in past exams
- **Progress tracking** — mark topics as "done" with persistent checkboxes
- **Dark Midnight Blue** gradient theme
- Offline — all data bundled in the APK

## Setup

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.x)
- No Android Studio needed — build via GitHub Actions

### Generate Android Project

After cloning, run once to generate the `android/` directory:

```bash
flutter create .
```

This generates platform files while preserving existing `lib/` and `assets/`.

### Run Locally

```bash
flutter pub get
flutter run
```

### Build APK via GitHub

Push to `main` branch or trigger the workflow manually from the **Actions** tab. The APK will be available as a workflow artifact.

```bash
git add .
git commit -m "your message"
git push origin main
```

Then go to **Actions → Build Android APK → download the APK artifact**.

## Project Structure

```
lib/
├── main.dart                    # Entry point
├── app.dart                     # MaterialApp + theme + providers
├── models/
│   ├── topic.dart               # Topic data model + Reference parser
│   ├── topic_type.dart          # Essay/Short enum
│   └── paper.dart               # Paper model
├── providers/
│   └── progress_provider.dart   # SharedPreferences-backed progress
├── services/
│   ├── csv_loader.dart          # CSV → Topic parser
│   ├── asset_registry.dart      # Subject/Paper/File tree definition
│   └── topic_cache.dart         # In-memory cache for loaded CSVs
├── screens/
│   ├── home_screen.dart         # 3 subject cards with progress
│   ├── paper_list_screen.dart   # Paper list with progress bars
│   ├── topic_list_screen.dart   # Filterable/sortable topic list
│   └── topic_detail_screen.dart # Full topic detail view
├── widgets/
│   ├── gradient_scaffold.dart   # Reusable gradient background scaffold
│   ├── subject_card.dart        # Home screen subject card
│   ├── progress_ring.dart       # Circular progress indicator
│   ├── topic_tile.dart          # Topic list item with checkbox
│   ├── importance_dots.dart     # Importance rating dots
│   ├── year_tags.dart           # Year-asked chip tags
│   └── filter_bar.dart          # Essay/Short/All filter + sort
└── utils/
    ├── constants.dart           # Colors, gradients, dimensions
    └── id_utils.dart            # ID parsing utilities
```

## Adding Questions

1. Place your `.csv` files in the appropriate directory:
   ```
   assets/questions/<Subject>/<paperN>/<UnitName>.csv
   ```

2. Register the file in `lib/services/asset_registry.dart`:
   ```dart
   Paper(
     name: 'Paper 1',
     directoryName: 'paper1',
     csvFiles: [
       'ExistingUnit.csv',
       'NewUnit.csv',  // <-- add here
     ],
   )
   ```

3. CSV format:
   ```csv
   Id,Title,Descriptions,HasPreviouslyBeenAsked,Importance,YearsAsked,ProbableCases,References
   S_PH_1.16.1.1,Topic Title,"- Point 1
   - Point 2",True,5,2023-02;2022-08,,@book?n=PH-kdtemp&ed=8&vol=0#100
   ```

## Tech Stack

| Component | Library |
|-----------|---------|
| Framework | Flutter 3.x |
| State | Provider 6.x |
| CSV | csv 6.x |
| Persistence | shared_preferences 2.x |
| Fonts | google_fonts 6.x |
