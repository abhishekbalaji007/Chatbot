//
//  MessageTests.swift
//  ChatbotTests
//
//  Created by BALAJI ABHISHEK on 2/16/19.
//  Copyright © 2019 BALAJI ABHISHEK. All rights reserved.
//

import XCTest
@testable import Chatbot

class MessageTests: XCTestCase {
    
    var messages: [Message] = []
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    //Test Cases For Message & Member.
    func testMember()
    {
        let member = Member(name: "Balaji Abhishek", color: .blue)
        XCTAssertNotNil(member, "Member should not be nil")
        
        let imgObj = UIImage.init(named: "camera")
        let mediaItem = ImageMediaItem(image: imgObj!)
        let strObj = "Sample String"
        
        let imgMessage = Message(image: imgObj!, member: member, messageId: UUID().uuidString)
        XCTAssertNotNil(imgMessage, "imgMessage should not be nil")
        self.insertMessage(imgMessage)
        
        let textMessage = Message(text: strObj, member: member, messageId: UUID().uuidString)
        XCTAssertNotNil(textMessage, "textMessage should not be nil")
        self.insertMessage(textMessage)
        
        let imgMessageObj = Message(member: member, kind: .photo(mediaItem), messageId: UUID().uuidString)
        XCTAssertNotNil(imgMessageObj, "imgMessageObj should not be nil")
        self.insertMessage(imgMessageObj)
        
        let textMessageObj = Message(member: member, kind: .text(strObj), messageId: UUID().uuidString)
        XCTAssertNotNil(textMessageObj, "textMessageObj should not be nil")
        self.insertMessage(textMessageObj)
        
        XCTAssertNotEqual(messages.isEmpty, true, "Last Section is available")
    }
    
    func insertMessage(_ message: Message)
    {
        messages.append(message)
    }
}

