# **IPTV App**
A modern, intuitive, and customizable application for streaming live TV, movies, and series via IPTV.

## **Features**
- 📺 **Live TV**: Stream live channels with smooth playback.
- 🎥 **On-Demand Content**: Access movies, series, and recorded programs.
- 🔍 **EPG (Electronic Program Guide)**: View detailed program schedules.
- 💾 **Playlist Support**: Import M3U playlists for easy access to channels.
- 🌐 **Multiple Formats**: Supports HLS, RTSP, and more.
- 🎨 **Customizable UI**: Adjust themes, layouts, and user preferences.
- 🔒 **Secure Streaming**: Ensures encrypted and private content playback.

## **Getting Started**

### **Installation**
1. **Download the App**
   - [Apple App Store](https://apps.apple.com/lu/app/iptv-app/id6480924954)

2. **Set Up Your Playlist**
   - Add your IPTV provider’s M3U playlist URL.
   - Configure EPG URLs if required.

### **Requirements**
- **macOS**: Version 14.0 or later
- **iOS & iPad OS**: Version 17.0 or later
- **VisionOS**: Version 1.0 or later

## **How to Use**
1. **Add Your Playlist**
   - Click on the menu labeled "IPTV App" on the main page.
   - Press "Add Playlist.
   - Input the M3U playlist URL and/or the EPG file URL.
  
2. **Watch**
   - Choose your Playlist from the menu and you're ready to watch!

## Feature List

### Core Features
- [x] **Live TV Streaming**  
  - [x] Access to live TV channels across various genres (sports, news, entertainment, etc.).
  - [x] High-definition (HD), Full HD, and 4K streaming support.
- [ ] **Electronic Program Guide (EPG)**  
  - [x] Interactive EPG for browsing current and upcoming shows.
  - [ ] Detailed show descriptions and schedules.
- [x] **Video on Demand (VOD)**  
  - [x] Access to movies, series, and other on-demand content.
  - [x] Categorized content for easier navigation.
- [ ] **Multi-Screen Support**  
  - [ ] Compatibility with TVs, smartphones, tablets, and desktops.
  - [x] Cross-device synchronization for saved content and preferences.

### User Features
- [ ] **Favorites & Watchlist**  
  - [x] Save channels, shows, or movies to a favorites list.
  - [ ] Add content to a personalized watchlist.
- [ ] **Parental Controls**  
  - [ ] Restrict access to age-inappropriate content.
  - [ ] PIN protection for specific categories or channels.
- [x] **Multi-Language Support**  
  - [x] Change app interface language.
- [x] **Search Functionality**  
  - [x] Search for channels, shows, movies, or actors.
  - [x] Filter results by genre, release year, or popularity.

### Playback Features
- [x] **Time-Shift Functionality**  
  - [x] Pause, rewind, or fast-forward live TV streams.
- [x] **Adaptive Bitrate Streaming (ABR)**  
  - [x] Automatically adjust video quality based on internet speed (integrated into AVPlayer).
- [x] **Picture-in-Picture Mode**  
  - [x] Watch TV or movies in a small window while using other apps.

## **Packages Used in the IPTV App**

Below is a list of third-party packages used in the IPTV app and their purposes:

### **1. M3UKit**
**Description**: A library for parsing and handling M3U playlists.
**Purpose**: Enables the app to import and manage IPTV playlists.

### **2. SDWebImageSwiftUI**
**Description**: SwiftUI bindings for SDWebImage.
**Purpose**: Handles image downloading and caching efficiently, providing smooth and optimized UI rendering for channel logos and thumbnails.

### **3. SWCompression**
**Description**: A compression framework for Swift.
**Purpose**: Used for decompressing or handling compressed files, such as EPG data or bundled playlists.

### **4. SwiftyXMLParser**
**Description**: A lightweight XML parser for Swift.
**Purpose**: Parses XML data, such as EPG files, to display program information.

### **5. UIOnboarding**
**Description**: A Swift package for creating onboarding screens.
**Purpose**: Provides a user-friendly onboarding experience for first-time users of the app.

### **6. XMLTV**
**Description**: A library for handling XMLTV files.
**Purpose**: Processes TV program schedules from XMLTV sources for use in the Electronic Program Guide (EPG).

## **Acknowledgments**
We are grateful to the developers of these open-source packages for their contributions to the community. Their work has significantly facilitated the development of IPTV App and enhanced its functionality and performance.

## **Contributing**  
We welcome contributions! Please follow these steps:
1. Fork this repository.
2. Create a feature branch (`git checkout -b feature-name`).
3. Commit your changes (`git commit -m "Add new feature"`).
4. Push to the branch (`git push origin feature-name`).
5. Create a Pull Request.

## **Support**
If you encounter any issues, please contact us:
- 📧 Email: [marianaduartesilva425@gmail.com](mailto:marianaduartesilva425@gmail.com)

## **License**  
This project is licensed under the MIT License. See [LICENSE](LICENSE) file for details.
