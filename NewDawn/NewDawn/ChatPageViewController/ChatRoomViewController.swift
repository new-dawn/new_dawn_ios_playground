//
//  ChatRoomViewController.swift
//  NewDawn
//
//  Created by 汤子毅 on 2019/2/13.
//  Copyright © 2019 New Dawn. All rights reserved.
//

import UIKit
import MessageKit
import MessageInputBar
import PusherSwift

// Chat history of the user to another user
struct SingleChatHistory: Codable {
    var id: String
    var displayName: String
    var message: String
}

class ChatRoomViewController: MessagesViewController {
    
    let PUSHER_APP_KEY = "6cc619d64bfad1da062a"
    let TEST_CHANNEL = "test_channel"
    let CHAT_EVENT = "chat_event"
    let MESSAGE = "message"
    let CLUSTER = "us2"
    let MESSAGE_USER_FROM_ID = "user_from_id"
    let MESSAGE_USER_TO_ID = "user_to_id"

    // Meta-info about this chat room
    // To be changed by Chat page segue
    // when a chat cell is clicked
    var userIdMe: String = "-1"
    var userIdYou: String = "-1"
    var userNameMe: String = "Me"
    var userNameYou: String = "You"
    var raw_messages: [[String: Any]] = []
    // Senders and messages
    // To be configured when this view is loaded
    var senderMe: Sender?
    var messages: [MessageType] = []
    var pusher: Pusher!
    
    // User profile object
    var userProfileMe: UserProfile?
    var userProfileYou: UserProfile?
    
    func configureSenders() -> Void {
        senderMe = Sender(id: userIdMe, displayName: userNameMe)
    }
    
    func constructChannelName() -> String {
        // TODO: A channel name should be unique for this pair of users
        // Should get a hash string from Backend
        if userIdMe < userIdYou {
            return "\(TEST_CHANNEL)_\(userIdMe)_\(userIdYou)"
        } else {
            return "\(TEST_CHANNEL)_\(userIdYou)_\(userIdMe)"
        }
    }
    
    func fetchMessagesFromHistory() -> Void {
        for chat_record in self.raw_messages {
            if let user_from_id = chat_record[MESSAGE_USER_FROM_ID] as? Int,
            let message = chat_record[MESSAGE] as? String {
                self.messages.append(
                    TextMessage(
                        sender: Sender(id: String(user_from_id), displayName: String(user_from_id)),
                        content: message
                    )
                )
            }
        }
        self.messagesCollectionView.reloadData()
        self.messagesCollectionView.scrollToBottom()
    }

    func subscribeToChat() -> Void {
        let options = PusherClientOptions(
            host: .cluster(CLUSTER)
        )
        pusher = Pusher(
            key: PUSHER_APP_KEY,
            options: options
        )
        // subscribe to channel and bind to event
        let channel = pusher.subscribe(constructChannelName())
        let _ = channel.bind(eventName: CHAT_EVENT, callback: { (data: Any?) -> Void in
            if let data = data as? [String : AnyObject] {
                if let message = data[self.MESSAGE] as? String, let user_id = data[self.MESSAGE_USER_FROM_ID] as? String {
                    var displayName = UNKNOWN
                    if user_id == self.userIdYou {
                        displayName = self.userNameYou
                    }
                    if user_id == self.userIdMe {
                        displayName = self.userNameMe
                    }
                    let sender = Sender(id: user_id, displayName: displayName)
                    self.insertMessage(TextMessage(sender: sender, content: message))
                }
            }
        })
        pusher.connect()
    }
    
    func fetchUserProfiles() -> Void {
        UserProfileBuilder.fetchUserProfiles(params: ["user__id": userIdYou]) {
            (data) in
            let profiles = UserProfileBuilder.parseAndReturn(response: data)
            if !profiles.isEmpty {
                self.userProfileYou = UserProfileBuilder.parseAndReturn(response: data)[0]
                DispatchQueue.main.async {
                    self.messagesCollectionView.reloadData()
                }
            }
        }
        UserProfileBuilder.fetchUserProfiles(params: ["user__id": self.userIdMe]) {
            (data) in
            let profiles = UserProfileBuilder.parseAndReturn(response: data)
            if !profiles.isEmpty {
                self.userProfileMe = UserProfileBuilder.parseAndReturn(response: data)[0]
                DispatchQueue.main.async {
                    self.messagesCollectionView.reloadData()
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureSenders()
        fetchUserProfiles()
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        fetchMessagesFromHistory()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        subscribeToChat()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        pusher.disconnect()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = userNameYou
    }
    
    func isLastSectionVisible() -> Bool {
        guard !messages.isEmpty else { return false }
        let lastIndexPath = IndexPath(item: 0, section: messages.count - 1)
        return messagesCollectionView.indexPathsForVisibleItems.contains(lastIndexPath)
    }
    
    func insertMessage(_ message: MessageType) {
        messages.append(message)
        // Reload last section to update header/footer labels and insert a new one
        messagesCollectionView.performBatchUpdates({
            messagesCollectionView.insertSections([messages.count - 1])
            if messages.count >= 2 {
                messagesCollectionView.reloadSections([messages.count - 2])
            }
        }, completion: { [weak self] _ in
            if self?.isLastSectionVisible() == true {
                self?.messagesCollectionView.scrollToBottom(animated: true)
            }
        })
    }
    
    func storeMessage(_ message: MessageType) {
        // Send to server
        if case let MessageKind.text(message_text) = message.kind {
            HttpUtil.sendMessageAction(
                user_from: self.userIdMe,
                user_to: self.userIdYou,
                action_type: UserActionType.MESSAGE.rawValue,
                entity_type: 0,
                entity_id: 0,
                message: message_text
            )
        }
    }
}

extension ChatRoomViewController: MessagesDataSource {
    func currentSender() -> Sender {
        return senderMe!
    }
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
}

extension ChatRoomViewController: MessagesDisplayDelegate, MessagesLayoutDelegate {
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        let userId = message.sender.id
        if userId == self.userIdMe {
            setAvatarForUser(url: userProfileMe?.mainImages[0].image_url, view: avatarView)
        }
        if userId == self.userIdYou {
            setAvatarForUser(url: userProfileYou?.mainImages[0].image_url, view: avatarView)
        }
    }
    func setAvatarForUser(url: String?, view: AvatarView) -> Void {
        if (url == nil) {
            let avatar = Avatar(image: nil, initials: "NA")
            view.set(avatar: avatar)
        } else {
            ImageUtil.downLoadImage(url: url!) {
                image in
                let avatar = Avatar(image: image, initials: "NA")
                view.set(avatar: avatar)
            }
        }
    }
}

// MARK: - MessageInputBarDelegate
extension ChatRoomViewController: MessageInputBarDelegate {
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        for component in inputBar.inputTextView.components {
            if let str = component as? String {
                let message = TextMessage(sender: Sender(id: userIdMe, displayName: userNameMe), content: str)
                storeMessage(message)
            }
        }
        inputBar.inputTextView.text = String()
        messagesCollectionView.scrollToBottom(animated: true)
    }
}
