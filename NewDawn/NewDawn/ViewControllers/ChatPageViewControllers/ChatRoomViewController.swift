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
    
    // Chat Background Color
    let myColor = UIColor(red: 255/255, green: 224/255, blue: 224/255, alpha: 1)
    let youColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)

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
    
    func fetchLikeMessage(profile: UserProfile) -> Void {
        let likeInfo = profile.likedInfo
        let sender = Sender(id: String(userIdYou), displayName: String(userNameYou))
        if likeInfo.liked_entity_type == EntityType.MAIN_IMAGE.rawValue {
            ImageUtil.downLoadImage(url: likeInfo.liked_image_url) {
                image in
                // Append a image
                self.messages.append(
                    ImageMessage(sender: sender, image: image)
                )
                // Append message
                self.messages.append(
                    TextMessage(sender: sender, content: likeInfo.liked_message)
                )
                self.fetchRegularMessage()
            }
        }
        else if likeInfo.liked_entity_type == EntityType.QUESTION_ANSWER.rawValue {
            // Append a answer
            self.messages.append(
                TextMessage(
                    sender: sender,
                    content: "I like your answer \"\(likeInfo.liked_answer)\" for question \"\(likeInfo.liked_question)\""
                )
            )
            // Append message
            self.messages.append(
                TextMessage(sender: sender, content: likeInfo.liked_message)
            )
            fetchRegularMessage()
        }
        else {
            fetchRegularMessage()
        }
    }
    
    func fetchRegularMessage() -> Void {
        for chat_record in self.raw_messages {
            if let user_from_id = chat_record[self.MESSAGE_USER_FROM_ID] as? Int,
                let message = chat_record[self.MESSAGE] as? String {
                self.messages.append(
                    TextMessage(
                        sender: Sender(id: String(user_from_id), displayName: String(user_from_id)),
                        content: message
                    )
                )
            }
        }
        let last_message = self.raw_messages.last
        if last_message != nil {
            // Record last seen message
            if let message_id = last_message![MESSAGE_ID] as? Int {
                LocalStorageUtil.localStoreKeyValue(key: VIEWED_MESSAGES + String(userIdYou), value: message_id)
            }
        }
        self.messagesCollectionView.reloadData()
        self.messagesCollectionView.scrollToBottom()
    }
    
    func fetchMessagesFromHistory() -> Void {
        fetchEndUserProfile() {
            profile in
            self.fetchLikeMessage(profile: profile)
        }
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
    
    func fetchEndUserProfile(callback: @escaping (UserProfile) -> Void) -> Void {
        if self.userProfileYou != nil {
            DispatchQueue.main.async {
                callback(self.userProfileYou!)
            }
            return
        }
        UserProfileBuilder.fetchUserProfiles(params: ["viewer_id": userIdMe,"user__id": userIdYou]) {
            (data) in
            let profiles = UserProfileBuilder.parseAndReturn(response: data)
            if !profiles.isEmpty {
                self.userProfileYou = profiles[0]
                DispatchQueue.main.async {
                    callback(profiles[0])
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureSenders()
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self
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
        if case let MessageKind.attributedText(message_attributed_text) = message.kind {
            HttpUtil.sendMessageAction(
                user_from: self.userIdMe,
                user_to: self.userIdYou,
                action_type: UserActionType.MESSAGE.rawValue,
                entity_type: 0,
                entity_id: 0,
                message: message_attributed_text.string
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
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        if message.sender.id == self.userIdMe {
            return myColor
        } else {
            return youColor
        }
    }
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        let userId = message.sender.id
        if userId == self.userIdMe {
            LoginUserUtil.fetchLoginUserProfile() {
                my_profile in
                if my_profile != nil && !my_profile!.mainImages.isEmpty {
                    self.setAvatarForUser(url: my_profile!.mainImages[0].image_url, view: avatarView)
                }
            }
        }
        if userId == self.userIdYou {
            fetchEndUserProfile() {
                profile in
                self.setAvatarForUser(url: profile.mainImages[0].image_url, view: avatarView)
            }
        }
    }
    func setAvatarForUser(url: String?, view: AvatarView) -> Void {
        if (url == nil) {
            let avatar = Avatar(image: BLANK_IMG, initials: "NA")
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

// MARK: - MessageCellDelegate
extension ChatRoomViewController: MessageCellDelegate {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Prepare fields sent to next page
        let chatProfileController = segue.destination as! ChatProfileViewController
        if let sender = sender as? UserProfile {
            chatProfileController.user_profile = sender
        }
    }
    func didTapAvatar(in cell: MessageCollectionViewCell) {
        guard let indexPath = messagesCollectionView.indexPath(for: cell) else { return }
        guard let messagesDataSource = messagesCollectionView.messagesDataSource else { return }
        let message = messagesDataSource.messageForItem(at: indexPath, in: messagesCollectionView)
        let sender = message.sender
        if sender.id == self.userIdYou {
            self.performSegue(withIdentifier: "chatProfile", sender: self.userProfileYou)
        }
        if sender.id == self.userIdMe {
            LoginUserUtil.fetchLoginUserProfile() {
                userProfileMe in
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "chatProfile", sender: userProfileMe)
                }
            }
        }
    }
}
