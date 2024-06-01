# M3UKit

This light utility written in Swift allows you to work with M3U/M3U8 lists.

## Usage

Just add M3UKit to you project using Swift Package Manager.

```swift
internal struct M3U: Codable {
    
    internal struct Channel: Codable {
        /// Title of the channel
        internal var title: String
        /// Duration of stream in seconds. -1 for live streams. 0 unknown.
        internal var duration: Int = 0
        /// Custom attributes for the channel
        internal var attributes: [String:String] = [:]
        /// Playback URL
        internal var url: String
    }
    
    internal var channels: [Channel] = []
    
}
```
The usage of this utility is very similar as you use Codable to encode/decode JSON files.
To decode a M3U list, you must to download it and pass it as `Data` using a `M3UDecoder` instance and `decode(_:) -> M3U` method.
To encode an existing M3U instance, you only need to call `encode(_:) -> Data` from a `M3UEncoder` instance.

## Contact

Made by Rubén Fernández in Spain. Twitter: [@RubenApps](https://twitter.com/RubenApps/)
