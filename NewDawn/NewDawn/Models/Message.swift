//
//  AppDelegate.swift
//  NewDawn
//
//  Created by 汤子毅 on 2018/12/1.
//  Copyright © 2018 New Dawn. All rights reserved.
//

import MessageKit

// A Message struct conforming to MessageType protocal
// from MessageKit
struct Message: MessageType {
    var kind: MessageKind
    var sentDate: Date
    var sender: Sender
    var messageId: String

    init(userId: String, userName: String, content: String) {
        self.sender = Sender(id: userId, displayName: userName)
        self.sentDate = Date()
        self.kind = .text(content)
        self.messageId = UUID().uuidString
    }
}

extension Message: Comparable {
  
  static func == (lhs: Message, rhs: Message) -> Bool {
    return lhs.messageId == rhs.messageId
  }
  
  static func < (lhs: Message, rhs: Message) -> Bool {
    return lhs.sentDate < rhs.sentDate
  }
}
