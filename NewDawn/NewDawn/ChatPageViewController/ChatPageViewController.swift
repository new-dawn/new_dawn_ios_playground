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
