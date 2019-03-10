//
//  ChatPageViewController.swift
//  NewDawn
//
//  Created by 汤子毅 on 2019/1/13.
//  Copyright © 2019 New Dawn. All rights reserved.
//

import UIKit

class ChatPageViewController: UIViewController {
    
    @IBOutlet weak var chatTableView: UITableView!
    var userProfiles: Array<UserProfile>!
    var chatTableViewModel: ChatPageTableViewModel!
    var allMessages: [[String:Any]] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: Get user data from backend
        userProfiles = [UserProfile]()
        for userData in USER_DUMMY_DATA {
            let userProfile = UserProfile(data: userData)
            userProfiles.append(userProfile)
        }
        chatTableViewModel = ChatPageTableViewModel(userProfiles: userProfiles)
        chatTableView.dataSource = chatTableViewModel
        chatTableView.delegate = chatTableViewModel
        chatTableView.rowHeight = UITableView.automaticDimension
        chatTableView.estimatedRowHeight = UITableView.automaticDimension
    }
    func fetchMessagesFromHistory() -> Void {
        DispatchQueue.global(qos: .userInitiated).async {
            // TODO: replace it by login user id in local storage
            HttpUtil.getAllMessagesAction(user_from: "1", callback: {
                response in
                DispatchQueue.main.async {
                    if let chat_history = response["objects"] as? [[String:Any]] {
                        self.allMessages = chat_history
                    }
                }
            })
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openChat" {
            if let destination = segue.destination as? ChatRoomViewController, let chatIndex = chatTableView.indexPathForSelectedRow?.row {
                // Fetch all messages for a certain end user
                let message_response = allMessages[chatIndex]
                let end_user_id = message_response["end_user_id"] as! String
                let end_user_firstname = message_response["end_user_firstname"] as? String
                let end_user_messages = message_response["messages"] as? [[String: Any]]
                // TODO: Should be the info of the login user
                destination.userNameMe = "Test"
                destination.userIdMe = "3"
                destination.userNameYou = "\(String(describing: end_user_firstname))"
                destination.userIdYou = end_user_id
                destination.raw_messages = end_user_messages
            }
        }
    }
}

class ChatPageTableViewModel: NSObject, UITableViewDelegate, UITableViewDataSource {
    var userProfiles = [UserProfile]()
    init(userProfiles: Array<UserProfile>) {
        super.init()
        self.userProfiles = userProfiles
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userProfiles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userProfile = self.userProfiles[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath) as! ChatCell
        // TODO: Get UserProfile from backend and use the object to get the info
        cell.chatNameLabel?.text = "\(String(describing: userProfile.firstname)) \(String(describing: userProfile.lastname))"
        if userProfile.mainImages.count > 0 {
            ImageUtil.polishCircularImageView(imageView: cell.chatImageView!)
            cell.chatImageView.downloaded(from: cell.chatImageView.getURL(path: userProfile.mainImages[0].image_url))
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
    
}
