//
//  MainPageViewController.swift
//  NewDawn
//
//  Created by 汤子毅 on 2019/1/4.
//  Copyright © 2019 New Dawn. All rights reserved.
//

import UIKit

let MAIN_PAGE_PROFILE_INDEX = "main_page_profile_index"

class MainPageViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var viewModel: MainPageViewModel!
    
    func loadProfileIndex() -> Int {
        if let index = self.localReadKeyValue(key: MAIN_PAGE_PROFILE_INDEX) as? Int {
            return index
        }
        self.localStoreKeyValue(key: MAIN_PAGE_PROFILE_INDEX, value: 0)
        return 0
    }

    func updateProfileIndex() -> Void {
        self.localStoreKeyValue(key: MAIN_PAGE_PROFILE_INDEX, value: loadProfileIndex() + 1)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if loadProfileIndex() >= USER_DUMMY_DATA.count {
            // TODO: When the user has seen all profiles, we go back to the first profile.
            // In the future, we should go to an ending page
            self.localStoreKeyValue(key: MAIN_PAGE_PROFILE_INDEX, value: 0)
        }
        viewModel = MainPageViewModel(userProfile: UserProfile(data: USER_DUMMY_DATA[loadProfileIndex()]))
        tableView.dataSource = viewModel
        tableView.delegate = viewModel
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        navigationItem.hidesBackButton = true
    }

    @IBAction func skipButtonTapped(_ sender: Any) {
        updateProfileIndex()
    }
}
