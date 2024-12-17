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
- **iOS**: Version 17.0 or later
- Active IPTV subscription with a playlist URL

## **How to Use**
1. **Add Your Playlist**
   - Click on the menu labeled "IPTV App" on the main page.
   - Press "Add Playlist.
   - Input the M3U playlist URL and/or the EPG file URL.
  
2. **Watch**
   - Choose your Playlist from the menu and you're ready to watch!

## **Roadmap**  
- [x] Add AirPlay support
- [ ] Offline playback for on-demand content
- [ ] Import playlists by uploading M3U files
- [x] Multi-language support
- [x] Picture-in-Picture (PiP) mode

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
We are grateful to the developers of these open-source packages for their contributions to the community. Their work has significantly enhanced the functionality and performance of our IPTV app.

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
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
