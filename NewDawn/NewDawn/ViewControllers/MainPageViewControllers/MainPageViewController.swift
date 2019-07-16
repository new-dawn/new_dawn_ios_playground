//
//  MainPageViewController.swift
//  NewDawn
//
//  Created by 汤子毅 on 2019/1/4.
//  Copyright © 2019 New Dawn. All rights reserved.
//

import UIKit

struct CandidateProfiles: Codable {
    var user_profiles: [UserProfile]
    var profile_index: Int
}

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
    
    func refreshView() {
        DispatchQueue.main.async {
            self.setupTableView()
            self.refreshTabBarCounterBadge()
            self.tableView.reloadData()
        }
    }
    
    func checkRefreshRecommendation() {
        if TimerUtil.checkIfOutdatedAndRefresh() {
            // If outdated, the profile will refresh automatically
            self.startNewRound()
        } else {
            if self.user_profiles == nil {
                // This happens when the app is re-launched, or the view was killed. We then need to fetch stored candidates from local storage
                if let candidate_profiles: CandidateProfiles = LocalStorageUtil.localReadKeyValueStruct(key: CANDIDATE_PROFILES) {
                    self.user_profiles = candidate_profiles.user_profiles
                    self.profileIndex = candidate_profiles.profile_index
                    if self.profileIndex >= self.user_profiles.count {
                        // All profiles have been viewed
                        self.performSegueToNextProfile(self.user_profiles)
                    } else {
                        self.refreshView()
                    }
                } else {
                    // No profiles have been loaded
                    // Get new profiles
                    self.startNewRound()
                }
            } else {
                if self.profileIndex >= self.user_profiles.count {
                    // All profile have been viewed
                    self.performSegueToNextProfile(self.user_profiles)
                } else {
                    self.refreshView()
                }
            }
        }
    }
    
    func startNewRound() {
        // Start new round
        getNewProfiles() {
            profiles in
            // Start new round
            DispatchQueue.main.async {
                self.user_profiles = profiles
                self.profileIndex = -1 // Next round will update to 0
                self.performSegueToNextProfile(self)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true
        NotificationCenter.default.addObserver(self, selector: #selector(self.likeButtonTappedOnPopupModal), name: NSNotification.Name(rawValue: "likeButtonTappedOnPopupModal"), object: nil)
        self.checkRefreshRecommendation()
    }
    
    override func viewDidLoad() {
        LoginUserUtil.fetchLoginUserProfile() {
            my_profile, error in
            if error != nil || my_profile == nil {
                DispatchQueue.main.async {
                    self.displayMessage(userMessage: "Error: Fetch Login User Profile Failed: \(error!)")
                }
            }
            self.checkReview(my_profile: my_profile!)
            self.checkTaken(my_profile: my_profile!)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
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
        if profileIndex + 1 >= user_profiles.count {
            LocalStorageUtil.localStoreKeyValueStruct(key: CANDIDATE_PROFILES, value: CandidateProfiles(user_profiles: self.user_profiles, profile_index: user_profiles.count))
            self.performSegue(withIdentifier: "mainPageEnd", sender: nil)
        } else {
            LocalStorageUtil.localStoreKeyValueStruct(key: CANDIDATE_PROFILES, value: CandidateProfiles(user_profiles: self.user_profiles, profile_index: profileIndex + 1))
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
                ) {
                    success in
                    if success {
                        DispatchQueue.main.async {
                            // Go to match popup view
                            self.performSegue(withIdentifier: "mainPageMatch", sender: yourUserProfile)
                        }
                    }
                }
            }
        }
    }

    func refreshTabBarCounterBadge() {
        DispatchQueue.main.async {
            self.tabBarController?.tabBar.items?.first?.badgeValue = "\(String(self.user_profiles.count - self.profileIndex - 1))"
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
            let profiles = UserProfileBuilder.parseAndReturn(response: data)
            callback(profiles)
        }
    }
    
    func setupTableView(_ reload: Bool = false) {
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
    }
}
