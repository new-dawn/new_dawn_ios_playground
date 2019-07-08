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
    
    func isLiked(_ userProfile: UserProfile) -> Bool {
        return userProfile.likedInfoFromYou.liked_entity_type != 0
    }
    
    func checkReview() {
        // Check if the current user has passed the review
        LoginUserUtil.fetchLoginUserProfile() {
            user_profile, _  in
            if user_profile != nil {
                if user_profile?.review_status == UserReviewStatus.PENDING.rawValue {
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "pending_review", sender: self)
                    }
                }
            }
        }
    }
    
    func checkTaken() {
        // Check if the current user has been taken
        LoginUserUtil.fetchLoginUserProfile() {
            user_profile, _  in
            if user_profile != nil {
                if user_profile?.takenBy != -1 {
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "already_taken", sender: self)
                    }
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.checkReview()
        self.checkTaken()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
            NotificationCenter.default.addObserver(self, selector: #selector(self.likeButtonTappedOnPopupModal), name: NSNotification.Name(rawValue: "likeButtonTappedOnPopupModal"), object: nil)
        user_profiles = UserProfileBuilder.getUserProfileListFromLocalStorage()
        refreshTabBarCounterBadge(user_profiles)
        if ProfileIndexUtil.noMoreProfile(profiles: user_profiles) || TimerUtil.isOutdated() {
            // Go to the ending page if no profile is available in local storage or is outdated
            // The ending page will handle profile fetch and refresh the main page automatically
            self.performSegue(withIdentifier: "mainPageEnd", sender: nil)
        } else {
            // Prepare the current profile view
            current_user_profile = user_profiles[ProfileIndexUtil.loadProfileIndex()]
            // Show receive like button if the current user liked me
            acceptLikeButton.isHidden = !isLiked(current_user_profile!)
            // Build main page UI
            viewModel = MainPageViewModel(userProfile: current_user_profile!)
            tableView.dataSource = viewModel
            tableView.delegate = viewModel
            tableView.rowHeight = UITableView.automaticDimension
            tableView.estimatedRowHeight = UITableView.automaticDimension
            tableView.backgroundColor = UIColor.init(red: 251, green: 249, blue: 246, alpha: 1)
            navigationItem.hidesBackButton = true
        }
    }
    
    func performSegueToNextProfile(_ sender: Any) {
        NotificationCenter.default.removeObserver(self)
        refreshTabBarCounterBadge(user_profiles)
        if ProfileIndexUtil.reachLastProfile(profiles: user_profiles) {
            self.performSegue(withIdentifier: "mainPageEnd", sender: nil)
        } else {
            ProfileIndexUtil.updateProfileIndex()
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
                    }
                // Go to match popup view
                self.performSegue(withIdentifier: "mainPageMatch", sender: yourUserProfile)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Prepare the current user profile sent to the match page
        if let matchViewController = segue.destination as? MainPageMatchViewController {
            if let yourProfile = sender as? UserProfile {
                matchViewController.userProfile = yourProfile
            }
        }
    }
    
    func refreshTabBarCounterBadge(_ profiles: [UserProfile]) {
        self.tabBarController?.tabBar.items?.first?.badgeValue = "\(String(ProfileIndexUtil.numOfRemainedProfile(profiles: user_profiles)))"
    }
}
