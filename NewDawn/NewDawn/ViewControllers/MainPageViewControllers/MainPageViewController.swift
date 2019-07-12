//
//  MainPageViewController.swift
//  NewDawn
//
//  Created by 汤子毅 on 2019/1/4.
//  Copyright © 2019 New Dawn. All rights reserved.
//

import UIKit


class MainPageViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var acceptLikeButton: UIButton!
    
    var viewModel: MainPageViewModel!
    var user_profiles: Array<UserProfile>!
    var current_user_profile: UserProfile?
    var profileIndex: Int = 0
    
    func isLiked(_ userProfile: UserProfile) -> Bool {
        return userProfile.likedInfoFromYou.liked_entity_type != 0
    }
    
    func checkReview(my_profile: UserProfile) {
        if my_profile.review_status == UserReviewStatus.PENDING.rawValue {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "pending_review", sender: self)
            }
        }
    }
    
    func checkTaken(my_profile: UserProfile) {
        if my_profile.takenBy != -1 {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "already_taken", sender: self)
            }
        }
    }
    
    func checkRefreshRecommendation() {
        if TimerUtil.checkIfOutdatedAndRefresh() {
            // If outdated, the profile will refresh automatically
            getNewProfiles() {
                profiles in
                // Start new round
                self.user_profiles = profiles
                self.profileIndex = -1
                self.refreshTabBarCounterBadge(self.user_profiles)
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "mainPageSelf", sender: nil)
                }
            }
        } else {
            if self.user_profiles == nil {
                // No profiles have been loaded
                // Get new profiles
                getNewProfiles() {
                    profiles in
                    // Start new round
                    self.user_profiles = profiles
                    self.profileIndex = 0
                    self.setupTableView()
                    self.refreshTabBarCounterBadge(self.user_profiles)
                }
            } else {
                self.setupTableView()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LoginUserUtil.fetchLoginUserProfile() {
            my_profile, error in
            if error != nil || my_profile == nil {
                DispatchQueue.main.async {
                    self.displayMessage(userMessage: "Error: Fetch Login User Profile Failed: \(error!)")
                }
            }
            self.checkReview(my_profile: my_profile!)
            self.checkTaken(my_profile: my_profile!)
            self.checkRefreshRecommendation()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
            NotificationCenter.default.addObserver(self, selector: #selector(self.likeButtonTappedOnPopupModal), name: NSNotification.Name(rawValue: "likeButtonTappedOnPopupModal"), object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Go to next profile
        if segue.identifier == "mainPageSelf" {
            if let destination = segue.destination as? MainPageViewController {
                destination.user_profiles = user_profiles
                destination.profileIndex = profileIndex + 1
            }
        }
        // Prepare the current user profile sent to the match page
        if let matchViewController = segue.destination as? MainPageMatchViewController {
            if let yourProfile = sender as? UserProfile {
                matchViewController.userProfile = yourProfile
            }
        }
    }
    
    func performSegueToNextProfile(_ sender: Any) {
        NotificationCenter.default.removeObserver(self)
        refreshTabBarCounterBadge(user_profiles)
        // This is the last profile. The next one is empty.
        if profileIndex + 1 >= user_profiles.count {
            self.performSegue(withIdentifier: "mainPageEnd", sender: nil)
        } else {
            self.performSegue(withIdentifier: "mainPageSelf", sender: nil)
        }
    }
    
    @objc func likeButtonTappedOnPopupModal(notif: NSNotification) {
        self.performSegueToNextProfile(notif)
    }

    @IBAction func skipButtonTapped(_ sender: Any) {
        // The profile is skipped
        self.performSegueToNextProfile(sender)
    }
    
    @IBAction func acceptLikeButtonTapped(_ sender: Any) {
        LoginUserUtil.fetchLoginUserProfile() {
            userProfile, error in
            if error != nil {
                DispatchQueue.main.async {
                    self.displayMessage(userMessage: "Error: Fetch Login User Profile Failed: \(error!)")
                }
                return
            }
            if let myUserProfile = userProfile, let yourUserProfile = self.current_user_profile {
                // Send an entity-less like action
                // which means accept like
                HttpUtil.sendAction(
                    user_from: String(myUserProfile.user_id),
                    user_to: yourUserProfile.user_id,
                    action_type: UserActionType.LIKE.rawValue,
                    entity_type: EntityType.NONE.rawValue,
                    entity_id: 0,
                    message: UNKNOWN
                )
                // Go to match popup view
                self.performSegue(withIdentifier: "mainPageMatch", sender: yourUserProfile)
            }
        }
    }

    func refreshTabBarCounterBadge(_ profiles: [UserProfile]) {
        DispatchQueue.main.async {
            self.tabBarController?.tabBar.items?.first?.badgeValue = "\(String(ProfileIndexUtil.numOfRemainedProfile(profiles: self.user_profiles)))"
        }
    }
    
    func getNewProfiles(callback: @escaping ([UserProfile]) -> Void) {
        var params = ["viewer_id": String(LoginUserUtil.getLoginUserId()!)]
        params += getPref()
        params += getReviewStatus()
        let sentAlertController = UIAlertController(title: nil, message: "正在获取新的推荐，请等待...", preferredStyle: .alert)
        DispatchQueue.main.async {
            self.present(sentAlertController, animated: true, completion: nil)
        }
        UserProfileBuilder.fetchUserProfiles(params: params) {
            (data, error) in
            if error != nil {
                DispatchQueue.main.async {
                    self.displayMessage(userMessage: "Error: Fetch Login User Profile Failed: \(error!)")
                }
                return
            }
            DispatchQueue.main.async {
                sentAlertController.dismiss(animated: true, completion: nil)
            }
            callback(UserProfileBuilder.parseAndReturn(response: data))
        }
    }
    
    func setupTableView() {
        DispatchQueue.main.async {
            // Prepare the current profile view
            self.current_user_profile = self.user_profiles[self.profileIndex]
            // Show receive like button if the current user liked me
            self.acceptLikeButton.isHidden = !self.isLiked(self.current_user_profile!)
            // Build main page UI
            self.viewModel = MainPageViewModel(userProfile: self.current_user_profile!)
            self.tableView.dataSource = self.viewModel
            self.tableView.delegate = self.viewModel
            self.tableView.rowHeight = UITableView.automaticDimension
            self.tableView.estimatedRowHeight = UITableView.automaticDimension
            self.tableView.backgroundColor = UIColor.init(red: 251, green: 249, blue: 246, alpha: 1)
            self.navigationItem.hidesBackButton = true
        }
    }
}
