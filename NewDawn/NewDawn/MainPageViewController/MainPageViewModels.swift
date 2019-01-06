//
//  MainPageViewModels.swift
//  NewDawn
//
//  Created by 汤子毅 on 2019/1/5.
//  Copyright © 2019 New Dawn. All rights reserved.
//

import Foundation

// An MVVM design of Main Page display

// A user profile class instantiated by json dictionary sent from backend
class UserProfile {
    var firstname: String?
    var lastname: String?
    var height: Int?
    var hometown: String?
    var school: String?
    var degree: String?
    var smoke: String?
    
    init?(data: NSDictionary) {
//        self.firstname = data[FIRSTNAME] as? String
//        self.lastname = data[LASTNAME] as? String
//        self.height = data[HEIGHT] as? Int
//        self.hometown = data[HOMETOWN] as? String
//        self.school = data[SCHOOL] as? String
//        self.degree = data[DEGREE] as? String
//        self.smoke = data[SMOKE] as? String
    }
}

// A collections of Main Page classes

// The main page has different type of sections
// image, basic info, question answers, instagram/linkedin etc.
enum MainPageViewModelItemType {
    case MAIN_IMAGE
    case BASIC_INFO
    case IMAGE
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
}

// Specify some default values
extension MainPageViewModellItem {
    var rowCount: Int {
        return 1
    }
    var likable: Bool {
        return false
    }
}


// ---------- View Model Item Definitions ----------

class BasicInfoViewModelItem: MainPageViewModellItem {
    
    let UNKNOWN: String = "N/A"

    // Required Attributes
    var type: MainPageViewModelItemType {
        return .BASIC_INFO
    }
    var sectionTitle: String {
        return "Basic Info"
    }
    var rowCount: Int {
        return 2
    }
    
    // Customized Attributes
    var smoke: String
    var school: String
    var degree: String
    
    init() {
        self.smoke = UNKNOWN
        self.school = UNKNOWN
        self.degree = UNKNOWN
    }
    
}

// ----------  Build Main Page View Model ----------

class MainPageViewModel: NSObject {
    var items = [MainPageViewModellItem]()
    
    // TODO: replace dummy data with real backend response
    let DUMMY_DATA: NSDictionary = [
        "firstname": "Test",
        "lastname": "User",
        "degree": "Undergrad",
        "school": "NYU"
    ]
    
    init(userProfile: UserProfile) {
        super.init()
        // Append basic info item
        items.append(fetchBasicInfo(userProfile: userProfile))
    }
    
    func fetchBasicInfo(userProfile: UserProfile) -> BasicInfoViewModelItem {
        let basicInfo = BasicInfoViewModelItem()
        // Populate basic info field with existed data in user profile
        if let smoke = userProfile.smoke {
            basicInfo.smoke = smoke
        }
        if let school = userProfile.school {
            basicInfo.school = school
        }
        if let degree = userProfile.degree {
            basicInfo.degree = degree
        }
        return basicInfo
    }
}
