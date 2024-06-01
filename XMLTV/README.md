# XMLTV

XMLTV is a Swift package which allows you to parse XML files using the EPG XMLTV structure.

## Usage
Add XMLTV to your project using Swift Package Manager.

XMLTV provides two structs representing channels and programs.

```swift
internal struct TVChannel {
    internal let id: String
    internal let name: String?
    internal let url: String?
    internal let icon: String?
}

internal struct TVProgram {
    internal let start: Date?
    internal let stop: Date?
    internal let channel: TVChannel
    internal let title: String?
    internal let description: String?
    internal let credits: [String:String]
    internal let date: String?
    internal let categories: [String]
    internal let country: String?
    internal let episode: String?
    internal let icon: String?
    internal let rating: String?
}
```

To parse files, you need to create an XMLTV object using the file data. Then you can use `getChannels() -> [TVChannel]` and `getPrograms(channel:) -> [TVProgram]` to get the information.
