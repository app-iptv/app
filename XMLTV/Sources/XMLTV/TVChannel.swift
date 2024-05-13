import Foundation

public struct TVChannel: Codable, Hashable {
    public let id: String
    public let name: String?
    public let url: String?
    public let icon: String?
}
