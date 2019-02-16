//
//  ChatRoomViewController.swift
//  NewDawn
//
//  Created by 汤子毅 on 2019/2/13.
//  Copyright © 2019 New Dawn. All rights reserved.
//

import UIKit
import MessageKit

class ChatRoomViewController: MessagesViewController {
    // Display as view title
    // To be changed by Chat page segue
    // when a cell is clicked
    var userNameMe: String = "Me"
    var userNameYou: String = "You"
    var senderA: Sender?
    var senderB: Sender?
    var messages: [MessageType] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        // TODO: The data below are just samples
        // Need to get from backend
        senderA = Sender(id: "Test A", displayName: userNameMe)
        senderB = Sender(id: "Test B", displayName: userNameYou)
        messages = [
            Message(sender: senderA!, content: "Nice to meet you! My name is Teddy and I'd like to grab a coffee with you"),
            Message(sender: senderB!, content: "Of course! When are you available this week?")
        ]
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = userNameYou
    }
}

extension ChatRoomViewController: MessagesDataSource {
    func currentSender() -> Sender {
        return senderA!
    }
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
}

extension ChatRoomViewController: MessagesDisplayDelegate, MessagesLayoutDelegate {}


