//
//  ChatProfileViewController.swift
//  NewDawn
//
//  Created by 汤子毅 on 2019/1/4.
//  Copyright © 2019 New Dawn. All rights reserved.
//

import UIKit


class ChatProfileViewController: UIViewController {
    @IBOutlet weak var chatProfileTableView: UITableView!
    var viewModel: MainPageViewModel!
    var user_profile: UserProfile?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Prepare the current profile view
        if user_profile != nil {
            viewModel = MainPageViewModel(userProfile: user_profile!)
            chatProfileTableView.dataSource = viewModel
            chatProfileTableView.delegate = viewModel
            chatProfileTableView.rowHeight = UITableView.automaticDimension
            chatProfileTableView.estimatedRowHeight = UITableView.automaticDimension
        }
    }
}
