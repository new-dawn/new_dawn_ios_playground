//
//  ChatPageViewController.swift
//  NewDawn
//
//  Created by 汤子毅 on 2019/1/13.
//  Copyright © 2019 New Dawn. All rights reserved.
//

import UIKit

let END_USER_ID = "end_user_id"
let END_USER_FIRSTNAME = "end_user_first_name"
let END_USER_LASTNAME = "end_user_last_name"
let END_USER_IMAGE_URL = "end_user_image_url"
let MESSAGES = "messages"
let VIEWED_MESSAGES = "viewed_messages"
let MATCHED_USER_ID = "matched_user_id"
let MESSAGE_ID = "message_id"

class ChatPageViewController: UIViewController {
    
    @IBOutlet weak var chatTableView: UITableView!
    var chatTableViewModel: ChatPageTableViewModel!
    var allMessages: [[String:Any]] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchEndUsersAndMessages()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchEndUsersAndMessages()
    }
    func fetchEndUsersAndMessages() -> Void {
        // TODO: replace it by login user id in local storage
        HttpUtil.getAllMessagesAction(user_from: String(LoginUserUtil.getLoginUserId()!), callback: {
            response, error in
                DispatchQueue.main.async {
                    if error != nil {
                        DispatchQueue.main.async {
                            self.displayMessage(userMessage: "Error: Fetch end user chat messages failed with \(error!)")
                        }
                        return
                    }
                    if let chat_history = response["objects"] as? [[String:Any]] {
                        self.allMessages = chat_history
                        // Initialize the table view with all chat info
                        self.chatTableViewModel = ChatPageTableViewModel(allMessages: self.allMessages)
                        self.self.chatTableView.dataSource = self.chatTableViewModel
                        self.chatTableView.delegate = self.chatTableViewModel
                        self.chatTableView.rowHeight = UITableView.automaticDimension
                        self.chatTableView.estimatedRowHeight = UITableView.automaticDimension
                    }
                }
        })
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openChat" {
            if let destination = segue.destination as? ChatRoomViewController, let chatIndex = chatTableView.indexPathForSelectedRow?.row {
                // Fetch all messages for a certain end user
                let message_response = allMessages[chatIndex]
                let end_user_id = message_response[END_USER_ID] as! Int
                let end_user_firstname = message_response[END_USER_FIRSTNAME] as! String
                let end_user_lastname = message_response[END_USER_LASTNAME] as! String
                let end_user_messages = message_response[MESSAGES] as! [[String: Any]]
                
                // TODO: Should be the info of the login user
                destination.userNameMe = "Test"
                destination.userIdMe = String(LoginUserUtil.getLoginUserId()!)
                destination.userNameYou = "\(end_user_firstname) \(end_user_lastname)"
                destination.userIdYou = String(end_user_id)
                destination.raw_messages = end_user_messages
            }
        }
    }
}

class ChatPageTableViewModel: NSObject, UITableViewDelegate, UITableViewDataSource {
    var allMessages = [[String:Any]]()
    init(allMessages: [[String:Any]]) {
        super.init()
        self.allMessages = allMessages
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allMessages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentMessageResponse = self.allMessages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath) as! ChatCell
        // Get the end user's information
        if let user_id = currentMessageResponse[END_USER_ID] as? Int, let firstName = currentMessageResponse[END_USER_FIRSTNAME] as? String, let lastName = currentMessageResponse[END_USER_LASTNAME] as? String, let imageURL = currentMessageResponse[END_USER_IMAGE_URL] as? String {
            LoginUserUtil.fetchLoginUserProfile(readLocal: false) {
                my_profile, error in
                //print("taken by:", my_profile?.takenBy)
                //print("user id:", user_id)
                if error != nil {
                    DispatchQueue.main.async {
                        //self.displayMessage(userMessage: "Error: Fetch Login User Profile Failed: \(error!)")
                    }
                    return
                }
                DispatchQueue.main.async {
                    if my_profile?.takenBy == -1 {
                        cell.contentView.alpha = 1.0
                        cell.contentView.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.0)
                        cell.isUserInteractionEnabled = true
                    }
                    if my_profile?.takenBy != -1 {
                        if my_profile?.takenBy != user_id {
                            cell.contentView.alpha = 0.5
                            cell.contentView.backgroundColor = UIColor(red: 165/255, green: 165/255, blue: 165/255, alpha: 0.2)
                            cell.isUserInteractionEnabled = false
                        }
                    }
                }
            }
            cell.chatNameLabel?.text = "\(String(describing: firstName)) \(String(describing: lastName))"
                ImageUtil.polishCircularImageView(imageView: cell.chatImageView!)
                cell.chatImageView.downloaded(from: cell.chatImageView.getURL(path: imageURL))
            // Fetch last message from chat history, if any
            if let messageTuples = currentMessageResponse[MESSAGES] as? [[String: Any]] {
                if let lastMessageTuple = messageTuples.last {
                    cell.lastMessageText?.text = lastMessageTuple["message"] as? String
                    // Check if the last message has been read. If so then hide the notification icon. Also store the updated last message.
                    if let last_message_id = lastMessageTuple[MESSAGE_ID] as? Int, let last_message_user_id = lastMessageTuple["user_from_id"] as? Int {
                        let last_viewed_message_id = LocalStorageUtil.localReadKeyValue(key: VIEWED_MESSAGES + String(user_id)) as? Int ?? -1
                        // If the login user has already viewed the message, or if the message is sent by the login user himself, then hide the notification icon
                        if last_viewed_message_id == last_message_id || last_message_user_id == LoginUserUtil.getLoginUserId() {
                            // Remove new message notification
                            cell.chatNotifImageView.isHidden = true
                        } else {
                            cell.chatNotifImageView.isHidden = false
                        }
                    }
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100
    }
    
}

class ChatCell: UITableViewCell {
    @IBOutlet weak var chatImageView: UIImageView!
    @IBOutlet weak var chatNameLabel: UILabel!
    @IBOutlet weak var lastMessageText: UILabel!
    @IBOutlet weak var chatNotifImageView: UIImageView!
}
