import XCTest

#if !canImport(ObjectiveC)
internal func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(M3UDecoderTests.allTests),
        testCase(M3UEncoderTests.allTests),
    ]
}
#endif
