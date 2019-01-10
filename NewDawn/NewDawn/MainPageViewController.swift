//
//  MainPageViewController.swift
//  NewDawn
//
//  Created by 汤子毅 on 2019/1/4.
//  Copyright © 2019 New Dawn. All rights reserved.
//

import UIKit

class MainPageViewController: UIViewController {
    
    fileprivate let viewModel = MainPageViewModel(userProfile: UserProfile(data: USER_DUMMY_DATA))
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = viewModel
        tableView.delegate = viewModel
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
    }

}
