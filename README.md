# Spotleflix
Project to mock UI features of Spotify, Bumble & Netflix following Swiftful Thinking's tutorial (https://shorturl.at/QCbUa)

## This app features 
<ul>
<li>Shared components: Asyncrhonous DatabaseHelper, Data models (User & Product) and a ImageLoaderView</li>
<li>Package Dependencies: SDWebImageSwiftUI // SwiftfulRouting // SwiftfulUI</li>
<li>Extensions: View (to update foreground & background color) and UINavigationController (to allow going back to previous viewControllers swiping left)</li>
<li>Specific Color Theme for each app </li>
<li>Component views of each app use generic data types, property wrappers are used only in core views and viewmodels</li>
<br/>
  
### Spotify
<li>Category cell updates its colors when selected</li>
<li>Playlist header cell uses modifier .asStretchyHeader(startingHeight: height) to increase image's height when pulling it</li>
<br/>
  
### Bumble
<li>Refactored to MVVM architecture, using Observable</li>
<li>Filter view retains user's selection using @AppStorage</li>
<li>Filter view uses modifier .matchedGeometryEffect and .animation to smoothly update the filter selected by the user</li>
<li>User can swipe cards left or right, then an overlaySwipingIndicator appears from the side of the screen according to user's choice, while the following card of the deck can be seen</li>
<br/>
  
### Netflix

