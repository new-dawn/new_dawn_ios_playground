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
enum MainPageViewModelItemType: String {
    case MAIN_IMAGE
    case BASIC_INFO
    case QUESTION_ANSWER
    case INSTAGRAM
    case LINKEDIN
}


// Standardize the requirement for each section
protocol MainPageViewModellItem: Codable {
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
        // Append basic info
        items.append(fetchBasicInfo(userProfile: userProfile))
        
        // Append question answers
        if !userProfile.questionAnswers.isEmpty {
            for index in 0...userProfile.questionAnswers.count-1 {
                items.append(
                    fetchQuestionAnswer(userProfile: userProfile, index: index))
            }
        }
        
    }
    
    func fetchBasicInfo(userProfile: UserProfile) -> BasicInfoViewModelItem {
        let basicInfo = BasicInfoViewModelItem(
            degree: userProfile.degree,
            drink: userProfile.drink,
            height: userProfile.height,
            location: userProfile.hometown,
            school: userProfile.school,
            smoke: userProfile.smoke
        )
        // Populate basic info field with existed data in user profile
        return basicInfo
    }
    
    func fetchQuestionAnswer(userProfile: UserProfile, index: Int) -> QuestionAnswerViewModelItem {
        let questionAnswer = QuestionAnswerViewModelItem(
            question: userProfile.questionAnswers[index].question.question,
            answer: userProfile.questionAnswers[index].answer,
            name: userProfile.firstname + " " + userProfile.lastname
        )
        return questionAnswer
    }
    
    func fetchMainImage(userProfile: UserProfile, index: Int) -> MainImageViewModelItem {
        let mainImage = MainImageViewModelItem(
            mainImageURL: userProfile.mainImages[index].image_url,
            caption: userProfile.mainImages[index].caption,
            name: userProfile.firstname + " " + userProfile.lastname,
            age: userProfile.age,
            jobTitle: userProfile.jobTitle,
            employer: userProfile.employer,
            isFirst: index == 0
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
                cell.selectionStyle = .none
                return cell
            }
        case .MAIN_IMAGE:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "mainImageViewCell", for: indexPath) as? MainImageViewCell {
                cell.item = item
                cell.selectionStyle = .none
                return cell
            }
        case .BASIC_INFO:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "basicInfoCell", for: indexPath) as? BasicInfoViewCell {
                cell.item = item
                cell.selectionStyle = .none
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
        return 130
    }
    
    // Customized Attributes
    var degree: String
    var drink: String
    var height: Int
    var location: String
    var school: String
    var smoke: String
    
    init(degree: String, drink: String, height: Int, location: String, school: String, smoke: String) {
        self.degree = degree
        self.drink = drink
        self.height = height
        self.location = location
        self.school = school
        self.smoke = smoke
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
        return 150
    }
    
    // Customized Attributes
    var question: String
    var answer: String
    var name: String
    
    init(question: String, answer: String, name: String) {
        self.question = question
        self.answer = answer
        self.name = name
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
    var name: String
    var age: Int
    var jobTitle: String
    var employer: String
    var isFirst: Bool
    
    init(mainImageURL: String, caption: String, name: String, age: Int, jobTitle: String, employer: String, isFirst: Bool) {
        self.mainImageURL = mainImageURL
        self.caption = caption
        self.name = name
        self.age = age
        self.jobTitle = jobTitle
        self.employer = employer
        self.isFirst = isFirst
    }
    
}

