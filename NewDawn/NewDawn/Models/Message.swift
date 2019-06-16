//
//  AppDelegate.swift
//  NewDawn
//
//  Created by 汤子毅 on 2018/12/1.
//  Copyright © 2018 New Dawn. All rights reserved.
//

import MessageKit

// A Text Message struct conforming to MessageType protocal
// from MessageKit
struct TextMessage: MessageType {
    var kind: MessageKind
    var sentDate: Date
    var sender: Sender
    var messageId: String

    init(sender: Sender, content: String) {
        self.sender = sender
        self.sentDate = Date()
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "PingFangTC-Regular", size: 16)!
        ]
        self.kind = .attributedText(NSAttributedString.init(string: content, attributes: attributes))
        self.messageId = UUID().uuidString
    }
    
    func getText() -> String {
        switch kind {
        case .attributedText(let attributedText):
            return attributedText.string
        default:
            return "N/A"
        }
    }
}

extension TextMessage: Comparable {
  
  static func == (lhs: TextMessage, rhs: TextMessage) -> Bool {
    return lhs.messageId == rhs.messageId
  }
  
  static func < (lhs: TextMessage, rhs: TextMessage) -> Bool {
    return lhs.sentDate < rhs.sentDate
  }
}

class MessageImageItem: MediaItem {
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
    init(image: UIImage) {
        self.placeholderImage = BLANK_IMG
        self.size = CGSize(width: 100, height: 100)
        self.image = image
    }
}

// A Image Message struct conforming to MessageType protocal
// from MessageKit
struct ImageMessage: MessageType {
    var kind: MessageKind
    var sentDate: Date
    var sender: Sender
    var messageId: String
    
    init(sender: Sender, image: UIImage) {
        self.sender = sender
        self.sentDate = Date()
        self.kind = .photo(MessageImageItem(image: image))
        self.messageId = UUID().uuidString
    }
}

extension ImageMessage: Comparable {
    static func == (lhs: ImageMessage, rhs: ImageMessage) -> Bool {
        return lhs.messageId == rhs.messageId
    }
    static func < (lhs: ImageMessage, rhs: ImageMessage) -> Bool {
        return lhs.sentDate < rhs.sentDate
    }
}
