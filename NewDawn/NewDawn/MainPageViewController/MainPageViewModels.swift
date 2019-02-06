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
enum MainPageViewModelItemType: Int {
    case MAIN_IMAGE = 1
    case BASIC_INFO = 2
    case QUESTION_ANSWER = 3
    case INSTAGRAM = 4
    case LINKEDIN = 5
}

enum UserActionType: Int{
    case LIKE = 1
    case BLOCK = 2
    case MATCH = 3
    case RELATIONSHIP = 4
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
    var image_items = [MainImageViewModelItem]()
    var basic_info_item = [BasicInfoViewModelItem]()
    var question_answer_items = [QuestionAnswerViewModelItem]()
    
    init(userProfile: UserProfile) {
        super.init()
        // Append all items in order
        if !userProfile.mainImages.isEmpty {
            for index in 0...userProfile.mainImages.count-1 {
                image_items.append(
                    fetchMainImage(userProfile: userProfile, index: index))
            }
        }
        // Append basic info
        basic_info_item.append(fetchBasicInfo(userProfile: userProfile))
        
        // Append question answers
        if !userProfile.questionAnswers.isEmpty {
            for index in 0...userProfile.questionAnswers.count-1 {
                question_answer_items.append(
                    fetchQuestionAnswer(userProfile: userProfile, index: index))
            }
        }
        // Apply some order on all items
        self.sectionSort()
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
            name: userProfile.firstname + " " + userProfile.lastname,
            id: index
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
            isFirst: index == 0,
            id: index
        )
        return mainImage
    }
    
    func sectionSort() -> Void {
        // The first image
        if image_items.count > 0 {
            items.append(image_items[0])
            image_items.removeFirst()
        }
        // Ordering of items
        while true {
            var hasNext = 0
            if question_answer_items.count > 0 {
                items.append(question_answer_items[0])
                question_answer_items.removeFirst()
                hasNext = 1
            }
            if image_items.count > 0 {
                items.append(image_items[0])
                image_items.removeFirst()
                hasNext = 1
            }
            if basic_info_item.count > 0 {
                items.append(basic_info_item[0])
                basic_info_item.removeFirst()
                hasNext = 1
            }
            if image_items.count > 0 {
                items.append(image_items[0])
                image_items.removeFirst()
                hasNext = 1
            }
            if hasNext == 0 {
                break
            }
        }
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
    var id: Int
    
    init(question: String, answer: String, name: String, id: Int) {
        self.question = question
        self.answer = answer
        self.name = name
        self.id = id
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
    var id: Int
    
    init(mainImageURL: String, caption: String, name: String, age: Int, jobTitle: String, employer: String, isFirst: Bool, id: Int) {
        self.mainImageURL = mainImageURL
        self.caption = caption
        self.name = name
        self.age = age
        self.jobTitle = jobTitle
        self.employer = employer
        self.isFirst = isFirst
        self.id = id
    }
    
}

