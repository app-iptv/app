import XCTest
@testable import LightXMLParser

final class LightXMLParserTests: XCTestCase {
    
    let exampleXML = """
    <xml>
        <A>TEST</A>
        <B attr1="1" attr2="2"></B>
    </xml>
    """
    
    func test() {
        
        let xmlData = exampleXML.data(using: .utf8)!
        let xml = try? XML(data: xmlData)
        
        XCTAssertNotNil(xml)
        
        XCTAssert(xml!.name == "xml")
        XCTAssert(xml!.children.count == 2)
        
        let firstChildren = xml!.children[0]
        XCTAssert(firstChildren.name == "A")
        XCTAssert(firstChildren.value == "TEST")
        
        let secondChildren = xml!.children[1]
        XCTAssert(secondChildren.attributes.count == 2)
        XCTAssert(secondChildren.attributes["attr1"] == "1")
        XCTAssert(secondChildren.attributes["attr2"] == "2")
        XCTAssert(secondChildren.name  == "B")
        XCTAssert(secondChildren.value  == "")
        
        
        XCTAssert(true)
    }

    static var allTests = [
        ("test", test),
    ]
}
