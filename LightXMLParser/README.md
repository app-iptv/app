# LightXMLParser

LightXMLParser is a light-weight Swift package allows you to parse XML files. 

## Installation
Add LightXMLParser to your project using SPM.

## Usage
To parse XML files using LightXMLParser you need to import the package.
`import LightXMLParser`
Then you can use it as simple as you create an XML object passing the content of XML as Data.
`let xml = XML(data: myXMLData)`
Each XML object has name, attributes and value.

An example XML file could be:
```xml
<xml>
	<tag1 attribute="attr-value">
		Value for tag 1.
	</tag1>
</xml>
```

For this example, you can get the following: 
```swift
let xmlName = xml.name // xml
let tag1 = xml.children[0]
let tag1Name = tag1.name // tag1
let tag1Value = tag1.value // Value for tag 1.
let tag1Attributes = tag1.attributes
let tag1Attribute = tag1Attributes["attribute"] // attr-value
```

## Credits
[SwiftyXML](https://github.com/chenyunguiMilook/SwiftyXML)
