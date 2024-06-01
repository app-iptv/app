import Foundation

public enum ParseError: Error {
	case unexpectedError
}

public class XML: Codable, Hashable {
    
	public func hash(into hasher: inout Hasher) {
		return hasher.combine(id)
	}
	
	public static func == (lhs: XML, rhs: XML) -> Bool {
		return lhs.id == rhs.id
	}
	
	private var id: UUID = UUID()
	
    public var name: String
    public var attributes: [String:String] = [:]
    public var value: String = ""
    public internal(set) var children: [XML] = []
    
    weak var parent: XML?
    
    private init(xml: XML) {
        self.name = xml.name
        self.attributes = xml.attributes
        self.value = xml.value
        self.addChildren(xml.children)
        self.parent = nil
    }
    
    init(name: String, attributes: [String:Any] = [:]) {
        self.name = name
        self.addAttributes(attributes)
    }
    
	public convenience init(data: Data) throws {
        let parser = LightXMLParser(data: data)
        parser.parse()
        guard let xml = parser.root else { throw ParseError.unexpectedError }
        self.init(xml: xml)
    }
    
    func addAttribute(name: String, value: Any) {
        self.attributes[name] = String(describing: value)
    }
    
    func addAttributes(_ attributes: [String:Any]) {
        for (key, value) in attributes {
            self.addAttribute(name: key, value: value)
        }
    }
    
    func addChild(_ xml:XML) {
        children.append(xml)
        xml.parent = self
    }
    
    func addChildren(_ xmls: [XML]) {
        xmls.forEach{ self.addChild($0) }
    }
    
}

private class LightXMLParser: NSObject, XMLParserDelegate {
    
    var root: XML?
    private let data: Data
    private weak var currentElement: XML?
    
    init(data: Data) {
        self.data = data
    }
    
    func parse() {
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        let element = XML(name: elementName, attributes: attributeDict)
        
        if root == nil {
            root = element
            currentElement = element
        } else {
            currentElement?.addChild(element)
            currentElement = element
        }
        
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        currentElement?.value += string
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        currentElement = currentElement?.parent
    }
    
}
