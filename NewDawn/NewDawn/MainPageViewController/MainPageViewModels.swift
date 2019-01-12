//
//  MainPageViewModels.swift
//  NewDawn
//
//  Created by 汤子毅 on 2019/1/5.
//  Copyright © 2019 New Dawn. All rights reserved.
//

import Foundation
import UIKit

// An MVVM design of Main Page display

// The main page has different type of sections
// image, basic info, question answers, instagram/linkedin etc.
enum MainPageViewModelItemType {
    case MAIN_IMAGE
    case BASIC_INFO
    case QUESTION_ANSWER
    case INSTAGRAM
    case LINKEDIN
}


// Standardize the requirement for each section
protocol MainPageViewModellItem {
    var type: MainPageViewModelItemType { get }
    var rowCount: Int { get }
    var sectionTitle: String { get }
    var likable: Bool { get }
    var rowHeight: Int { get }
}

// Specify some default values
extension MainPageViewModellItem {
    var rowCount: Int {
        return 1
    }
    var likable: Bool {
        return false
    }
    var rowHeight: Int {
        return 50
    }
}

// ----------  Build Main Page View Model ----------

class MainPageViewModel: NSObject {
    var items = [MainPageViewModellItem]()
    
    init(userProfile: UserProfile) {
        super.init()
        // Append all items in order
        if !userProfile.mainImages.isEmpty {
            for index in 0...userProfile.mainImages.count-1 {
                items.append(
                    fetchMainImage(userProfile: userProfile, index: index))
            }
        }
        if !userProfile.questionAnswers.isEmpty {
            for index in 0...userProfile.questionAnswers.count-1 {
                items.append(
                    fetchQuestionAnswer(userProfile: userProfile, index: index))
            }
        }
    }
    
    func fetchBasicInfo(userProfile: UserProfile) -> BasicInfoViewModelItem {
        let basicInfo = BasicInfoViewModelItem(
            smoke: userProfile.smoke, school: userProfile.school, degree: userProfile.degree)
        // Populate basic info field with existed data in user profile
        return basicInfo
    }
    
    func fetchQuestionAnswer(userProfile: UserProfile, index: Int) -> QuestionAnswerViewModelItem {
        let questionAnswer = QuestionAnswerViewModelItem(
            question: userProfile.questionAnswers[index].question.question,
            answer: userProfile.questionAnswers[index].answer
        )
        return questionAnswer
    }
    
    func fetchMainImage(userProfile: UserProfile, index: Int) -> MainImageViewModelItem {
        let mainImage = MainImageViewModelItem(
            mainImageURL: userProfile.mainImages[index].image_url,
            caption: userProfile.mainImages[index].caption
        )
        return mainImage
    }
}

extension MainPageViewModel: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].rowCount
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.section]
        switch item.type {
        case .QUESTION_ANSWER:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "questionAnswerCell", for: indexPath) as? QuestionAnswerViewCell {
                cell.item = item
                return cell
            }
        case .MAIN_IMAGE:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "mainImageViewCell", for: indexPath) as? MainImageViewCell {
                cell.item = item
                return cell
            }
        case .BASIC_INFO:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "basicInfoCell", for: indexPath) as? BasicInfoViewCell {
                cell.item = item
                return cell
            }
        case .INSTAGRAM:
        return UITableViewCell()
        case .LINKEDIN:
        return UITableViewCell()
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(items[indexPath.section].rowHeight)
    }
}

// ---------- View Model Item Definitions ----------

class BasicInfoViewModelItem: MainPageViewModellItem {
    
    // Required Attributes
    var type: MainPageViewModelItemType {
        return .BASIC_INFO
    }
    var sectionTitle: String {
        return "Basic Info"
    }
    var rowCount: Int {
        return 1
    }
    var rowHeight: Int {
        return 80
    }
    
    // Customized Attributes
    var smoke: String
    var school: String
    var degree: String
    
    init(smoke: String, school: String, degree: String) {
        self.smoke = smoke
        self.school = school
        self.degree = degree
    }
    
}

class QuestionAnswerViewModelItem: MainPageViewModellItem {
    
    // Required Attributes
    var type: MainPageViewModelItemType {
        return .QUESTION_ANSWER
    }
    var sectionTitle: String {
        return "Question Answer"
    }
    var rowCount: Int {
        return 1
    }
    var rowHeight: Int {
        return 100
    }
    
    // Customized Attributes
    var question: String
    var answer: String
    
    init(question: String, answer: String) {
        self.question = question
        self.answer = answer
    }
    
}

class MainImageViewModelItem: MainPageViewModellItem {
    
    // Required Attributes
    var type: MainPageViewModelItemType {
        return .MAIN_IMAGE
    }
    var sectionTitle: String {
        return "Image"
    }
    var rowCount: Int {
        return 1
    }
    var rowHeight: Int {
        return 380
    }
    
    // Customized Attributes
    var mainImageURL: String
    var caption: String
    
    init(mainImageURL: String, caption: String) {
        self.mainImageURL = mainImageURL
        self.caption = caption
    }
    
}

