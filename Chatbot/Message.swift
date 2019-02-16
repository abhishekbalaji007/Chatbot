//
//  Message.swift
//  Chatbot
//
//  Created by BALAJI ABHISHEK on 2/16/19.
//  Copyright © 2019 BALAJI ABHISHEK. All rights reserved.
//

import Foundation
import UIKit
import MessageKit
import Photos

//This structure contains member name getting displayed in chat and the color.
struct Member
{
    let name: String
    let color: UIColor
}

//This structure mainly contains member data & kind(text messages & images).
struct Message
{
    let member: Member
    var kind: MessageKind
    let messageId: String
    
    init(image: UIImage, member: Member, messageId: String)
    {
        let mediaItem = ImageMediaItem(image: image)
        self.init(member: member, kind: .photo(mediaItem), messageId: messageId)
    }
    
    init(text: String, member: Member, messageId: String)
    {
        self.init(member: member, kind: .text(text), messageId: messageId)
    }
    
    init(member: Member, kind: MessageKind, messageId: String)
    {
        self.member = member
        self.kind = kind
        self.messageId = messageId
    }
}

//This structure contains Image, Size, URL and Place Holder Item if any.
struct ImageMediaItem: MediaItem
{
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
    
    init(image: UIImage)
    {
        self.image = image
        self.size = CGSize(width: 240, height: 240)
        self.placeholderImage = UIImage()
    }
}

//This strucure contains member display name.
extension Message: MessageType
{
    var sender: Sender
    {
        return Sender(id: member.name, displayName: member.name)
    }
    
    var sentDate: Date
    {
        return Date()
    }
}

