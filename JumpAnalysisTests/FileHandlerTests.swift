//
//  FileHandlerTests.swift
//  JumpAnalysis
//
//  Created by Lukas Welte on 19.01.15.
//  Copyright (c) 2015 Lukas Welte. All rights reserved.
//

import XCTest

class FileHandlerTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testCanWriteAndLoadFile() {
        let content = "This is my little test content. /!)))898"
        let fileName = "testFile"
        
        FileHandler.writeToFile(fileName, content: content)
        
        let resolvedContent = FileHandler.readFromFile(fileName)
        
        XCTAssertEqual(content, resolvedContent)
    }

}
