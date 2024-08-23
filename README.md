# Spotleflix
Project to mock features of Spotify, Bumble, and Netflix; built following Swiftful Thinking's tutorial. [Tutorial Link](https://shorturl.at/QCbUa).

## Features

- **Shared Components:**
  - Asynchronous `DatabaseHelper` for efficient database operations.
  - Data models including `User` and `Product`.
  - `ImageLoaderView` for asynchronous image loading.

- **Package Dependencies:**
  - `SDWebImageSwiftUI`
  - `SwiftfulRouting`
  - `SwiftfulUI`

- **Extensions:**
  - `View`: To update foreground & background colors dynamically.
  - `UINavigationController`: Allows swipe-to-go-back functionality.

- **Implementation Details:**
  - Component views use generic data types, with property wrappers confined to core views and viewmodels.
  - Buttons feature extra padding and minimal opacity (`0.001`) to enhance clickability.
  - Specific color themes for each app (Spotify, Bumble, Netflix).

### Spotify
- Category cell updates its colors when selected.
- Playlist header cell uses `.asStretchyHeader(startingHeight: height)` to increase image height when pulled down.

### Bumble
- Refactored to MVVM architecture using `Observable`.
- Filter view retains user selection with `@AppStorage`.
- Filter view utilizes `.matchedGeometryEffect` and `.animation` for smooth transitions when updating the selected filter.
- Users can swipe cards left or right, triggering an overlay swiping indicator from the side of the screen, with the next card in the deck partially visible.

### Netflix
- Background gradient layer animates its opacity based on the scroll offset of the main view.
- Header background opacity updates with an animation based on scroll offset.
- Header filters disappear with an animation according to the scroll offset.
- Filter bar view hides non-selected filters with an animation after user selection.
- `MyListButton` in `DetailView` features a bouncy animation, updating its image, opacity, and rotation effect.


