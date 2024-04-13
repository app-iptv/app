import Foundation

public class M3UDecoder {
	
	public init() {}
	
	public func decode(_ data: Data) -> M3U? {
		guard let string = String(data: data, encoding: .utf8) else { return nil }
		var m3u = M3U()
		var lines = string.components(separatedBy: .newlines)
		lines.removeAll { $0.starts(with: "#EXTM3U") || $0.isEmpty }
		for i in 0 ..< lines.count {
			guard lines[i].starts(with: "#EXTINF") && !lines[i+1].starts(with: "#EXTINF") else { continue }
			let channelInfo = lines[i].split(separator: ",")
			let channelTitle = String(channelInfo.last!)
			let channelAttributes = parseArguments(channelInfo.first!)
			let channelTime = channelInfo
				.first!
				.components(separatedBy: .whitespaces)
				.first!
				.components(separatedBy: ":")
				.last!
			var channelURL: String {
				if lines[i+1].hasPrefix("http") {
					return lines[i+1]
				} else if lines[i+2].hasPrefix("http") {
					return lines[i+2]
				} else if lines[i+3].hasPrefix("http") {
					return lines[i+3]
				} else if lines[i+4].hasPrefix("http") {
					return lines[i+4]
				} else if lines[i+5].hasPrefix("http") {
					return lines[i+5]
				} else {
					return ""
				}
			}
			var channel = M3U.Channel(title: channelTitle, attributes: channelAttributes, url: channelURL)
			if let duration = Int(channelTime) {
				channel.duration = duration
			}
			m3u.channels.append(channel)
		}
		return m3u
	}
	
	private func parseArguments(_ info: Substring) -> [String:String] {
		var channelArguments = info.components(separatedBy: .whitespaces)
		channelArguments.removeFirst()
		channelArguments = channelArguments.joined(separator: " ").components(separatedBy: "\" ").filter { $0.contains("=") }
		var attributes: [String:String] = [:]
		channelArguments.forEach { argument in
			let components = argument.split(separator: "=", maxSplits: 1)
			let key = components.first!
			var value = components.last!
			value.removeFirst()
			if value.hasSuffix("\"") {
				value.removeLast()
			}
			attributes[String(key)] = String(value)
		}
		return attributes
	}
	
}
