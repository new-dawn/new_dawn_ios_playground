//
//  ChatRoomViewController.swift
//  NewDawn
//
//  Created by 汤子毅 on 2019/2/13.
//  Copyright © 2019 New Dawn. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import PusherSwift


// Chat history of the user to another user
struct SingleChatHistory: Codable {
    var id: String
    var displayName: String
    var message: String
}

class ChatRoomViewController: MessagesViewController {
    
    @IBOutlet weak var imTakenButton: UIButton!
    
    let PUSHER_APP_KEY = "6cc619d64bfad1da062a"
    let TEST_CHANNEL = "test_channel"
    let CHAT_EVENT = "chat_event"
    let MESSAGE = "message"
    let CLUSTER = "us2"
    let MESSAGE_USER_FROM_ID = "user_from_id"
    let MESSAGE_USER_TO_ID = "user_to_id"
    
    // Chat Background Color
    let myColor = UIColor(red: 189/255, green: 225/255, blue: 237/255, alpha: 1)
    let youColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)

    // Meta-info about this chat room
    // To be changed by Chat page segue
    // when a chat cell is clicked
    var userIdMe: String = "-1"
    var userIdYou: String = "-1"
    var userNameMe: String = "Me"
    var userNameYou: String = "You"
    var raw_messages: [[String: Any]] = []
    var tempTakenBy: Int?
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
    
    func configureMessageCollectionView() {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messageCellDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        scrollsToBottomOnKeyboardBeginsEditing = true // default false
        maintainPositionOnKeyboardFrameChanged = true // default false
    }
    
    func configureMessageInputBar() {
        messageInputBar.delegate = self
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
    
    func fetchLikedInfoAsMessage(likedInfo: LikedInfo, sender: Sender) -> Void {
        if likedInfo.liked_entity_type == EntityType.MAIN_IMAGE.rawValue {
            // Append a image
            let image_message_index = self.messages.count
            self.messages.append(
                ImageMessage(sender: sender, image: DEFAULT_IMG)
            )
            // Append message
            self.messages.append(
                TextMessage(sender: sender, content: likedInfo.liked_message)
            )
            ImageUtil.downLoadImage(url: likedInfo.liked_image_url) {
                image in
                DispatchQueue.main.async {
                    self.messages[image_message_index] = ImageMessage(sender: sender, image: image)
                    self.messagesCollectionView.reloadData()
                    self.messagesCollectionView.scrollToBottom()
                }
            }
        }
        else if likedInfo.liked_entity_type == EntityType.QUESTION_ANSWER.rawValue {
            // Append a answer
            self.messages.append(
                TextMessage(
                    sender: sender,
                    content: "I like your answer \"\(likedInfo.liked_answer)\" for question \"\(likedInfo.liked_question)\""
                )
            )
            // Append message
            self.messages.append(
                TextMessage(sender: sender, content: likedInfo.liked_message)
            )
        }
    }
    
    func fetchAllMessages(profile: UserProfile) -> Void {
        let likedInfoFromYou = profile.likedInfoFromYou
        let likedInfoFromMe = profile.likedInfoFromMe
        fetchLikedInfoAsMessage(
            likedInfo: likedInfoFromYou,
            sender: Sender(id: String(userIdYou), displayName: String(userNameYou))
        )
        fetchLikedInfoAsMessage(
            likedInfo: likedInfoFromMe,
            sender: Sender(id: String(userIdMe), displayName: String(userNameMe))
        )
        fetchRegularMessage()
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
        DispatchQueue.main.async {
            self.messagesCollectionView.reloadData()
            self.messagesCollectionView.scrollToBottom()
        }
    }
    
    func fetchMessagesFromHistory() -> Void {
        fetchEndUserProfile() {
            profile in
            self.fetchAllMessages(profile: profile)
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
            (data, error) in
            if error != nil {
                DispatchQueue.main.async {
                    self.displayMessage(userMessage: "Error: Fetch Login User Profile Failed: \(error!)")
                }
                return
            }
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
        LoginUserUtil.fetchLoginUserProfile(readLocal: false) {
            my_profile, error in
            if error != nil {
                DispatchQueue.main.async {
                    self.displayMessage(userMessage: "Error: Fetch Login User Profile Failed: \(error!)")
                }
                return
            }
            DispatchQueue.main.async {
                self.tempTakenBy = my_profile?.takenBy
                if self.tempTakenBy != -1 {
                    let takenAcceptedimg = UIImage(named: "AcceptedTakenButton")
                    self.imTakenButton.setImage(takenAcceptedimg, for: .normal)
                }
                else {
                    let sendTakenimg = UIImage(named: "ImTakenButton")
                    self.imTakenButton.setImage(sendTakenimg, for: .normal)
                }
            }
        }
        configureSenders()
        configureMessageCollectionView()
        configureMessageInputBar()
        fetchMessagesFromHistory()
        fetchEndUserProfile() {
            profile in
            if self.tempTakenBy == -1 {
                if profile.takenRequestedFromYou {
                    DispatchQueue.main.async {
                        let alertController = UIAlertController(title: "专属模式", message: self.userNameYou + "向你发出“专属”邀请，如果你接受邀请，你们的资料就不再对第三方可见，无法和第三方聊天，也无法再进行新的匹配。专属模式可以随时取消，对方会收到提醒。详情请见帮助菜单。", preferredStyle: .alert)
                        let paragraphStyle = NSMutableParagraphStyle()
                        paragraphStyle.alignment = NSTextAlignment.left
                        let messageText = NSMutableAttributedString(
                            string: self.userNameYou + "向你发出“专属”邀请，如果你接受邀请，你们的资料就不再对第三方可见，无法和第三方聊天，也无法再进行新的匹配。专属模式可以随时取消，对方会收到提醒。详情请见帮助菜单。",
                            attributes: [
                                NSAttributedString.Key.paragraphStyle: paragraphStyle,
                                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13.0)
                            ]
                        )
                        alertController.setValue(messageText, forKey: "attributedMessage")
                        self.present(alertController, animated: true, completion: nil)
                        let acceptAction = UIAlertAction(title: "接受", style: .default) {(_) in
                            HttpUtil.sendAction(user_from: self.userIdMe, user_to: self.userIdYou, action_type: UserActionType.ACCEPT_TAKEN.rawValue, entity_type: EntityType.NONE.rawValue, entity_id: 0, message: UNKNOWN) {
                                success in
                                if success {
                                    DispatchQueue.main.async {
                                        let takenAcceptedimg = UIImage(named: "AcceptedTakenButton")
                                        self.imTakenButton.setImage(takenAcceptedimg, for: .normal)
                                        let acceptAlertController = UIAlertController(title: nil, message: "已与" + self.userNameYou + "进入专属模式。", preferredStyle: .alert)
                                        self.present(acceptAlertController, animated: true, completion: nil)
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                            acceptAlertController.dismiss(animated: true, completion: nil)
                                        }
                                    }
                                }
                            }
                        }
                        let ignoreAction = UIAlertAction(title: "忽略", style: .default)
                        alertController.addAction(acceptAction)
                        alertController.addAction(ignoreAction)
                    }
                }
            }
        }
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
    
    @IBAction func imTakenButtonTapped(_ sender: Any) {
        LoginUserUtil.fetchLoginUserProfile(readLocal: false) {
            my_profile, error in
            if error != nil {
                DispatchQueue.main.async {
                    self.displayMessage(userMessage: "Error: Fetch Login User Profile Failed: \(error!)")
                }
                return
            }
            DispatchQueue.main.async {
                if my_profile?.takenBy == -1 {
                    let alertController = UIAlertController(title: "专属模式", message: "确认向" + self.userNameYou + "发出“专属”邀请吗？" + self.userNameYou + "在接受邀请后，你们的资料就不再对第三方可见，无法和第三方聊天，也无法再进行新的匹配。专属模式可以随时取消，对方会收到提醒。详情请见帮助菜单。", preferredStyle: .alert)
                    let paragraphStyle = NSMutableParagraphStyle()
                    paragraphStyle.alignment = NSTextAlignment.left
                    let messageText = NSMutableAttributedString(
                        string: "确认向" + self.userNameYou + "发出“专属”邀请吗？" + self.userNameYou + "在接受邀请后，你们的资料就不再对第三方可见，无法和第三方聊天，也无法再进行新的匹配。专属模式可以随时取消，对方会收到提醒。详情请见帮助菜单。",
                        attributes: [
                            NSAttributedString.Key.paragraphStyle: paragraphStyle,
                            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13.0)
                        ]
                    )
                    alertController.setValue(messageText, forKey: "attributedMessage")
                    self.present(alertController, animated: true, completion: nil)
                    let confirmAction = UIAlertAction(title: "确定", style: .default) {(_) in
                        HttpUtil.sendAction(user_from: self.userIdMe, user_to: self.userIdYou, action_type: UserActionType.REQUEST_TAKEN.rawValue, entity_type: EntityType.NONE.rawValue, entity_id: 0, message: UNKNOWN) {
                            success in
                            if success {
                                let sentAlertController = UIAlertController(title: nil, message: "专属邀请已成功寄出。", preferredStyle: .alert)
                                self.present(sentAlertController, animated: true, completion: nil)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    sentAlertController.dismiss(animated: true, completion: nil)
                                }
                            }
                        }
                    }
                    let cancelAction = UIAlertAction(title: "取消", style: .default)
                    alertController.addAction(cancelAction)
                    alertController.addAction(confirmAction)
                }
                else {
                    let alertController = UIAlertController(title: "专属模式", message: "确认与" + self.userNameYou + "解除“专属”模式吗？解除后，对方会收到提醒。你们的资料将重新对第三方可见。详情请见帮助菜单。", preferredStyle: .alert)
                    self.present(alertController, animated: true, completion: nil)
                    let confirmAction = UIAlertAction(title: "确定", style: .default) {(_) in
                        HttpUtil.sendAction(user_from: self.userIdMe, user_to: self.userIdYou, action_type: UserActionType.UNTAKEN.rawValue, entity_type: EntityType.NONE.rawValue, entity_id: 0, message: UNKNOWN) {
                            success in
                            if success {
                                DispatchQueue.main.async {
                                    let sendTakenimg = UIImage(named: "ImTakenButton")
                                    self.imTakenButton.setImage(sendTakenimg, for: .normal)
                                    let removeAlertController = UIAlertController(title: nil, message: "专属模式已成功解除。", preferredStyle: .alert)
                                    self.present(removeAlertController, animated: true, completion: nil)
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                        removeAlertController.dismiss(animated: true, completion: nil)
                                    }
                                }
                            }
                        }
                    }
                    let cancelAction = UIAlertAction(title: "取消", style: .default)
                    alertController.addAction(cancelAction)
                    alertController.addAction(confirmAction)
                }
            }
        }
    }
    
    @IBAction func OptionsButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        self.present(alertController, animated: true)
        let unmatchAction = self.getUnmatchAlertAction()
        let cancelAction = UIAlertAction(title: "返回", style: .default)
        alertController.addAction(unmatchAction)
        alertController.addAction(cancelAction)
    }
    
    func getUnmatchAlertAction() -> UIAlertAction {
        return UIAlertAction(title: "删除匹配", style: .default) {(_) in
            let unmatchAlertController = UIAlertController(title: "删除匹配", message: "确认删除与对方用户的匹配吗？删除匹配后，双方将无法继续与对方聊天", preferredStyle: .alert)
            self.present(unmatchAlertController, animated: true)
            let confirmAction = UIAlertAction(title: "确定", style: .default) {(_) in
                HttpUtil.sendAction(user_from: self.userIdMe, user_to: self.userIdYou, action_type: UserActionType.UNMATCH.rawValue, entity_type: EntityType.NONE.rawValue, entity_id: 0, message: UNKNOWN) {
                    success in
                    if success {
                        // Go back to Chat root page
                        DispatchQueue.main.async {
                            let storyBoard = UIStoryboard(name: "MainPage", bundle: nil)
                            let vc = storyBoard.instantiateViewController(withIdentifier: "MainTabViewController") as! UITabBarController
                            self.present (vc, animated: false, completion: nil)
                            vc.selectedIndex = 1
                        }
                    }
                }
            }
            let cancelAction = UIAlertAction(title: "返回", style: .default)
            unmatchAlertController.addAction(cancelAction)
            unmatchAlertController.addAction(confirmAction)
        }
    }
}

extension ChatRoomViewController: MessagesDataSource {
    func currentSender() -> SenderType {
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
        if message.sender.senderId == self.userIdMe {
            return myColor
        } else {
            return youColor
        }
    }
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        let userId = message.sender.senderId
        if userId == self.userIdMe {
            LoginUserUtil.fetchLoginUserProfile() {
                my_profile, error in
                if error != nil {
                    DispatchQueue.main.async {
                        self.displayMessage(userMessage: "Error: Fetch Login User Profile Failed: \(error!)")
                    }
                    return
                }
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
                DispatchQueue.main.async {
                    let avatar = Avatar(image: image, initials: "NA")
                    view.set(avatar: avatar)
                }
            }
        }
    }
}

// MARK: - MessageInputBarDelegate
extension ChatRoomViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
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
        if sender.senderId == self.userIdYou {
            self.performSegue(withIdentifier: "chatProfile", sender: self.userProfileYou)
        }
        if sender.senderId == self.userIdMe {
            LoginUserUtil.fetchLoginUserProfile() {
                userProfileMe, error in
                if error != nil {
                    DispatchQueue.main.async {
                        self.displayMessage(userMessage: "Error: Fetch Login User Profile Failed: \(error!)")
                    }
                    return
                }
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "chatProfile", sender: userProfileMe)
                }
            }
        }
    }
}
