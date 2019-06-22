//
//  EditProfileSubViewController.swift
//  NewDawn
//
//  Created by Junlin Liu on 6/15/19.
//  Copyright © 2019 New Dawn. All rights reserved.
//

import Foundation
import UIKit

class EditProfileQuestionViewController: UIViewController, UIScrollViewDelegate{
    
    var scrollView: UIScrollView!
    var containerView = UIView()
    
    let QUESTION_WIDTH = 326
    let QUESTION_HEIGHT = 90
    let QUESTION_BLOCK_HEIGHT = 95
    let Y_TOP_OFFSET = 20
    
    // TODO: Replace hardcoded questions with backend request
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Create a scroll view
        scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: QUESTION_WIDTH, height: getContentHeight())
        // Create a container view
        containerView = UIView()
        scrollView.addSubview(containerView)
        view.addSubview(scrollView)
        // Create Questions
        generateQuestions()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        containerView.frame = CGRect(
            x: 0, y: 0,
            width: scrollView.contentSize.width,
            height: scrollView.contentSize.height)
    }
    
    // Prepare the question sent to Answer Question view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Push the selected Question to the next view
        let answerQuestionController = segue.destination as! EditProfileAnswerQuestionViewController
        answerQuestionController.question = sender as! Question
    }
    
    var sample_questions = [
        Question(id: 1, question: "如果可以出演电影，我想演？"),
        Question(id: 2, question: "周末喜欢做什么?"),
        Question(id: 3, question: "我最喜欢的歌词是?"),
        Question(id: 4, question: "生命中影响我最深的人?"),
        Question(id: 5, question: "我的特别技能?"),
        Question(id: 6, question: "得到我的心的办法?"),
        Question(id: 7, question: "你会知道我喜欢你，如果？"),
        Question(id: 8, question: "Jason是不是最帅的?"),
        ]
    
    func getSampleQuestions() -> Array<Question> {
        return sample_questions
    }
    
    func getContentHeight() -> Int {
        return QUESTION_BLOCK_HEIGHT * self.getSampleQuestions().count + 100
    }
    
    func createQuestionRect(offsetY: Int) -> CGRect {
        let screenSize: CGRect = UIScreen.main.bounds
        let questionRect = CGRect(
            x: (screenSize.width / 2) - CGFloat(QUESTION_WIDTH / 2),
            y: CGFloat(offsetY),
            width: CGFloat(QUESTION_WIDTH), height: CGFloat(QUESTION_HEIGHT))
        return questionRect
    }
    
    func getQuestionAnswersFromLocalStore() -> Array<QuestionAnswer> {
        if let existed_question_answers: Array<QuestionAnswer> = localReadKeyValueStruct(key: QUESTION_ANSWERS) {
            return existed_question_answers
        }
        return [QuestionAnswer]()
    }
    
    func isAnswered(question: Question) -> Bool {
        let answered_questions = self.getQuestionAnswersFromLocalStore()
        for answered_question in answered_questions {
            if answered_question.question.question == question.question {
                return true
            }
        }
        return false
    }
    
    func createQuestionButton(question: Question, offsetY: Int) -> UIButton {
        let questionButton = UIButton(
            frame: createQuestionRect(offsetY: offsetY))
        // Set button style and content
        polishQuestionButton(button: questionButton)
        questionButton.setTitle(question.question, for: .normal)
        if isAnswered(question: question) {
            questionButton.setBackgroundImage(
                UIImage(named: "QuestionBlock2"), for: .normal)
            questionButton.isEnabled = false
        } else {
            questionButton.setBackgroundImage(
                UIImage(named: "QuestionBlock"), for: .normal)
            questionButton.titleEdgeInsets = UIEdgeInsets(top: -10.0, left: 0.0, bottom: 0.0, right: 0.0)
        }
        questionButton.titleLabel?.font =  UIFont(name: "PingFangTC-Regular", size: 16)
        // Store question if as button tag
        questionButton.tag = Int(question.id)
        questionButton.addTarget(self, action:#selector(self.buttonClicked), for: .touchUpInside)
        // Add the button to the container
        return questionButton
    }
    
    func getQuestionByID(id: Int) -> Question {
        for question in self.getSampleQuestions() {
            if question.id == id {
                return question
            }
        }
        return getSampleQuestions()[0]
    }
    
    @objc func buttonClicked(sender: UIButton) {
        // Find the correct question by taking the button tag
        let question = getQuestionByID(id: sender.tag)
        // Segue to the next view (Answer Question)
        performSegue(withIdentifier: "editProfile_answerQuestion", sender: question)
    }
    
    func generateQuestions() -> Void {
        // A dynamic offset to control the distance
        // between question blocks
        var buttonOffsetY: Int = Y_TOP_OFFSET
        for question in getSampleQuestions() {
            // Auto-generate a question button
            // Increment the offset for next button
            let questionButton = createQuestionButton(question: question, offsetY: buttonOffsetY)
            buttonOffsetY = buttonOffsetY + QUESTION_BLOCK_HEIGHT
            containerView.addSubview(questionButton)
        }
    }
}

class EditProfileAnswerQuestionViewController: UIViewController{
    
    var question = Question()
    @IBOutlet weak var questionTextField: UITextView!
    @IBOutlet weak var answerTextField: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionTextField.text = question.question
        polishTextView(textView: answerTextField)
    }
    
    func createQuestionAnswer() -> QuestionAnswer {
        // ID is just a placeholder. The real question answer id will be assigned in backend
        return QuestionAnswer(id: 0, question: question, answer: answerTextField.text!)
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        if (answerTextField.text?.isEmpty)! {
            displayMessage(userMessage: "Answer cannot be empty")
        }
        // ID is just a placeholder. The real question answer id will be assigned in backend
        let question_answer = QuestionAnswer(id: 0, question: question, answer: answerTextField.text!)
        var question_answers = [QuestionAnswer]()
        // Check if local storage already has question answers
        if let existed_question_answers: Array<QuestionAnswer> = localReadKeyValueStruct(key: QUESTION_ANSWERS) {
            question_answers = existed_question_answers
        }
        // Append the new answer and store all question answers to local storage
        question_answers.append(question_answer)
        localStoreKeyValueStruct(key: QUESTION_ANSWERS, value: question_answers)
        navigationController?.popViewController(animated: true)
        navigationController?.popViewController(animated: true)
    }

}

class EditProfileBasicInfoViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    let MAN = "M"
    let WOMAN = "W"
    var gender = UNKNOWN
    
    @IBOutlet weak var womanButton: UIButton!
    @IBOutlet weak var manButton: UIButton!
    
    @IBOutlet weak var firstnameTextField: UITextField!
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var birthdayTextField: UITextField!
    
    let heightPickerData = Profile_Height.heightGenerator(minHeight: 140, maxHeight: 250)
    
    @IBOutlet weak var heightTextField: UITextField!
    
    let datePicker = UIDatePicker()
    // Load fields that user has already filled in
    func loadStoredFields() {
        if let firstname = localReadKeyValue(key: FIRSTNAME) as? String {
            firstnameTextField.text = firstname
        }
        if let lastname = localReadKeyValue(key: LASTNAME) as? String {
            lastnameTextField.text = lastname
        }
        if let birthday = localReadKeyValue(key: BIRTHDAY) as? String {
            birthdayTextField.text = birthday
        }
        if let stored_gender = localReadKeyValue(key: GENDER) as? String {
            gender = stored_gender
            if gender == MAN {
                selectManButton(button: manButton)
            } else {
                selectWomanButton(button: womanButton)
            }
        }
        if let height = localReadKeyValue(key: HEIGHT) as? String {
            heightTextField.text = height + " cm"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        polishGenderButton(button: womanButton)
        polishGenderButton(button: manButton)
        firstnameTextField.setBottomBorder()
        lastnameTextField.setBottomBorder()
        birthdayTextField.setBottomBorder()
        heightTextField.setBottomBorder()
        loadStoredFields()
        showDatePicker()
        overrideBackbutton()
        
        let loc = Locale(identifier: "zh_Hans_CN")
        self.datePicker.locale = loc
        
        // Height Picker Toolbar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(Profile_Height.donePicker))
        toolbar.setItems([flexSpace, doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        // Degree Picker
        let heightPicker = UIPickerView()
        heightTextField.inputView = heightPicker
        heightTextField.inputAccessoryView = toolbar
        heightPicker.delegate = self
    }
    
    func overrideBackbutton(){
        
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "< Profile Edit", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
    }
    
    @objc func back(sender: UIBarButtonItem){
        if (firstnameTextField.text?.isEmpty)! ||
            (lastnameTextField.text?.isEmpty)! ||
            (birthdayTextField.text?.isEmpty)! ||
            gender == UNKNOWN{
            self.displayMessage(userMessage: "Cannot have empty field")
        }else if (heightTextField.text?.isEmpty)! {
            self.displayMessage(userMessage: "Cannot have empty field")
        }else{
            // Store Name, Birthday locally
            localStoreKeyValue(key: FIRSTNAME, value: firstnameTextField.text!)
            localStoreKeyValue(key: LASTNAME, value: lastnameTextField.text!)
            localStoreKeyValue(key: BIRTHDAY, value: birthdayTextField.text!)
            localStoreKeyValue(key: HEIGHT, value: heightTextField.text!.prefix(3))
            self.dismiss(animated: true, completion: {})
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func womanButtonTapped(_ sender: Any) {
        selectWomanButton(button: womanButton)
        deselectButton(button: manButton)
        gender = WOMAN
        localStoreKeyValue(key: GENDER, value: gender)
    }
    @IBAction func manButtonTapped(_ sender: Any) {
        selectManButton(button: manButton)
        deselectButton(button: womanButton)
        gender = MAN
        localStoreKeyValue(key: GENDER, value: gender)
    }
    
    func showDatePicker() {
        //Formate Date
        datePicker.datePickerMode = .date
        
        //Minimum 18 years old
        datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: -18, to: Date())
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        birthdayTextField.inputAccessoryView = toolbar
        birthdayTextField.inputView = datePicker
    }
    
    @objc func donedatePicker(dateField: UITextField){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        birthdayTextField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    func selectWomanButton(button: UIButton){
        let color = UIColor(red:241/255, green:78/255, blue:78/255, alpha:1)
        button.setTitleColor(.white, for: .normal)
        button.tintColor = UIColor.white
        button.layer.borderColor = color.cgColor
        button.layer.backgroundColor = color.cgColor
    }
    
    func selectManButton(button: UIButton){
        let color = UIColor(red:22/255, green:170/255, blue:184/255, alpha:1)
        button.setTitleColor(.white, for: .normal)
        button.tintColor = UIColor.white
        button.layer.borderColor = color.cgColor
        button.layer.backgroundColor = color.cgColor
    }
    
    func polishGenderButton(button: UIButton) -> Void {
        button.layer.cornerRadius = 13
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor(red:151/255, green:151/255, blue:151/255, alpha:1).cgColor
        button.layer.masksToBounds = true
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return heightPickerData.count
    }
    
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return heightPickerData[row]
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        heightTextField.text = heightPickerData[row]
    }
    
    @objc func donePicker() {
        heightTextField.resignFirstResponder()
    }
    
    class func heightGenerator(minHeight: Int, maxHeight: Int) -> [String]{
        let heights_int = [Int](minHeight...maxHeight)
        var heightStringArray = heights_int.map { String($0) + " cm"}
        let min_value = "<" + String(minHeight) + " cm"
        let max_value = ">" + String(maxHeight) + " cm"
        heightStringArray.insert(min_value, at: 0)
        heightStringArray.insert(max_value, at: heightStringArray.count)
        return heightStringArray
    }
}

class EditProfile_Education: UIViewController {
    
    var degree = UNKNOWN
    // Constant string keys
    let VISIBLE = "edu_visible"
    
    var visibleField = false
    
    
    @IBOutlet weak var undergrad: UIButton!
    @IBOutlet weak var grad: UIButton!
    @IBOutlet weak var phd: UIButton!
    
    
    @IBOutlet weak var schoolTextField: UITextField!
    // Load fields that user has already filled in
    func loadStoredFields() {
        if let school = localReadKeyValue(key: SCHOOL) as? String {
            schoolTextField.text = school
        }
        if let stored_degree = localReadKeyValue(key: DEGREE) as? String {
            degree = stored_degree
            if degree == "本科" {
                selectDegreeButton(button: undergrad)
            }
            else if degree == "硕士" {
                selectDegreeButton(button: grad)
            }
            else {
                selectDegreeButton(button: phd)
            }
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        schoolTextField.setBottomBorder()
        polishDegreeButton(button: undergrad)
        polishDegreeButton(button: grad)
        polishDegreeButton(button: phd)
        loadStoredFields()
        overrideBackbutton()
    }
    
    func overrideBackbutton(){
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "< Profile Edit", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
    }
    
    @objc func back(sender: UIBarButtonItem){
        localStoreKeyValue(key: SCHOOL, value: schoolTextField.text!)
        self.dismiss(animated: true, completion: {})
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func undergradTapped(_ sender: Any) {
        selectDegreeButton(button: undergrad)
        deselectButton(button: grad)
        deselectButton(button: phd)
        degree = "本科"
        localStoreKeyValue(key: DEGREE, value: degree)
    }
    
    @IBAction func gradTapped(_ sender: Any) {
        selectDegreeButton(button: grad)
        deselectButton(button: undergrad)
        deselectButton(button: phd)
        degree = "硕士"
        localStoreKeyValue(key: DEGREE, value: degree)
    }
    
    @IBAction func phdTapped(_ sender: Any) {
        selectDegreeButton(button: phd)
        deselectButton(button: undergrad)
        deselectButton(button: grad)
        degree = "博士"
        localStoreKeyValue(key: DEGREE, value: degree)
    }
    
    func polishDegreeButton(button: UIButton) -> Void {
        button.layer.cornerRadius = 13
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor(red:151/255, green:151/255, blue:151/255, alpha:1).cgColor
        button.layer.masksToBounds = true
    }
    
    func selectDegreeButton(button: UIButton) -> Void {
        button.layer.cornerRadius = 13
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor(red:22/255, green:170/255, blue:184/255, alpha:1).cgColor
        button.layer.backgroundColor = UIColor(red:22/255, green:170/255, blue:184/255, alpha:1).cgColor
        button.layer.masksToBounds = true
    }
}


class EditProfile_WorkJob: UIViewController {
    
    @IBOutlet weak var workplaceTextField: UITextField!
    @IBOutlet weak var jobtitleTextField: UITextField!
    
    
    func loadStoredFields() {
        if let workplace = localReadKeyValue(key: WORKPLACE) as? String {
            workplaceTextField.text = workplace
        }
        if let jobtitle = localReadKeyValue(key: JOBTITLE) as? String {
            jobtitleTextField.text = jobtitle
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        workplaceTextField.setBottomBorder()
        jobtitleTextField.setBottomBorder()
        loadStoredFields()
        overrideBackbutton()
    }
    
    func overrideBackbutton(){
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "< Profile Edit", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
    }
    
    @objc func back(sender: UIBarButtonItem){
        localStoreKeyValue(key: WORKPLACE, value: workplaceTextField.text!)
        localStoreKeyValue(key: JOBTITLE, value: jobtitleTextField.text!)
        self.dismiss(animated: true, completion: {})
        self.navigationController?.popViewController(animated: true)
    }
}


class EditProfile_Smoke: UIViewController {
    
    let FREQUENT_SMOKE = "frequent"
    let NOSMOKE = "no"
    let SOCIAL_SMOKE = "social"
    let UNKNOWN = "N/A"
    var smoke_pref: String? = nil
    
    @IBOutlet weak var sociallyButton: UIButton!
    @IBOutlet weak var frequentlyButton: UIButton!
    @IBOutlet weak var noSmokeButton: UIButton!

    
    
    func loadStoredFields() {
        // Select the buttons if a user has already done so
        if let smoke = localReadKeyValue(key: SMOKE) as? String{
            if smoke == NOSMOKE{
                selectSmokeButton(button: noSmokeButton)
                smoke_pref = NOSMOKE
            }
            else if smoke == FREQUENT_SMOKE{
                selectSmokeButton(button: frequentlyButton)
                smoke_pref = FREQUENT_SMOKE
            }
            else if smoke == SOCIAL_SMOKE{
                selectSmokeButton(button: sociallyButton)
                smoke_pref = SOCIAL_SMOKE
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        polishSmokeButton(button: sociallyButton)
        polishSmokeButton(button: frequentlyButton)
        polishSmokeButton(button: noSmokeButton)
        loadStoredFields()
        overrideBackbutton()
    }
    
    func overrideBackbutton(){
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "< Profile Edit", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
    }
    
    @objc func back(sender: UIBarButtonItem){
        localStoreKeyValue(key: SMOKE, value: smoke_pref ?? UNKNOWN)
        self.dismiss(animated: true, completion: {})
        self.navigationController?.popViewController(animated: true)
    }

    
    @IBAction func noSmokeButtonTapped(_ sender: Any) {
        if smoke_pref == NOSMOKE {
            deselectButton(button: noSmokeButton)
            smoke_pref = nil
        } else {
            selectSmokeButton(button: noSmokeButton)
            deselectButtons(buttons: [sociallyButton,frequentlyButton])
            smoke_pref = NOSMOKE
        }
    }
    
    @IBAction func frequentButtonTapped(_ sender: Any) {
        if smoke_pref == FREQUENT_SMOKE {
            deselectButton(button: frequentlyButton)
            smoke_pref = nil
        } else {
            selectSmokeButton(button: frequentlyButton)
            deselectButtons(buttons: [sociallyButton,noSmokeButton])
            smoke_pref = FREQUENT_SMOKE
        }
    }
    
    @IBAction func sociallyButtonTapped(_ sender: Any) {
        if smoke_pref == SOCIAL_SMOKE {
            deselectButton(button: sociallyButton)
            smoke_pref = nil
        } else {
            selectSmokeButton(button: sociallyButton)
            deselectButtons(buttons: [frequentlyButton,noSmokeButton])
            smoke_pref = SOCIAL_SMOKE
        }
    }
    
    
    func polishSmokeButton(button: UIButton) -> Void {
        button.layer.cornerRadius = 13
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor(red:151/255, green:151/255, blue:151/255, alpha:1).cgColor
        button.layer.masksToBounds = true
    }
    
    func selectSmokeButton(button: UIButton){
        let color = UIColor(red:22/255, green:170/255, blue:184/255, alpha:1)
        button.setTitleColor(.white, for: .normal)
        button.tintColor = UIColor.white
        button.layer.borderColor = color.cgColor
        button.layer.backgroundColor = color.cgColor
    }
    
}


class EditProfile_Drink: UIViewController {
    
    let FREQUENT_DRINK = "frequent"
    let NODRINK = "no"
    let SOCIAL_DRINK = "social"
    let UNKNOWN = "N/A"
    let VISIBLE = "drink_visible"
    var drink_pref: String? = nil
    var visible_state = false
    
    @IBOutlet weak var sociallyButton: UIButton!
    @IBOutlet weak var frequentlyButton: UIButton!
    @IBOutlet weak var noDrinkButton: UIButton!
    
    func loadStoredFields() {
        // Select the buttons if a user has already done so
        if let drink = localReadKeyValue(key: DRINK) as? String{
            if drink == NODRINK{
                selectDrinkButton(button: noDrinkButton)
                drink_pref = NODRINK
            }
            else if drink == FREQUENT_DRINK{
                selectDrinkButton(button: frequentlyButton)
                drink_pref = FREQUENT_DRINK
            }
            else if drink == SOCIAL_DRINK{
                selectDrinkButton(button: sociallyButton)
                drink_pref = SOCIAL_DRINK
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        polishDrinkButton(button: sociallyButton)
        polishDrinkButton(button: frequentlyButton)
        polishDrinkButton(button: noDrinkButton)
        loadStoredFields()
        overrideBackbutton()
    }
    
    func overrideBackbutton(){
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "< Profile Edit", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
    }
    
    @objc func back(sender: UIBarButtonItem){
        localStoreKeyValue(key: DRINK, value: drink_pref ?? UNKNOWN)
        self.dismiss(animated: true, completion: {})
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func noDrinkButtonTapped(_ sender: Any) {
        if drink_pref == NODRINK {
            deselectButton(button: noDrinkButton)
            drink_pref = nil
        } else {
            selectDrinkButton(button: noDrinkButton)
            deselectButtons(buttons: [sociallyButton,frequentlyButton])
            drink_pref = NODRINK
        }
    }
    
    @IBAction func frequentButtonTapped(_ sender: Any) {
        if drink_pref == FREQUENT_DRINK {
            deselectButton(button: frequentlyButton)
            drink_pref = nil
        } else {
            selectDrinkButton(button: frequentlyButton)
            deselectButtons(buttons: [sociallyButton,noDrinkButton])
            drink_pref = FREQUENT_DRINK
        }
    }
    
    @IBAction func sociallyButtonTapped(_ sender: Any) {
        if drink_pref == SOCIAL_DRINK {
            deselectButton(button: sociallyButton)
            drink_pref = nil
        } else {
            selectDrinkButton(button: sociallyButton)
            deselectButtons(buttons: [frequentlyButton,noDrinkButton])
            drink_pref = SOCIAL_DRINK
        }
    }
    
    
    func polishDrinkButton(button: UIButton) -> Void {
        button.layer.cornerRadius = 13
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor(red:151/255, green:151/255, blue:151/255, alpha:1).cgColor
        button.layer.masksToBounds = true
    }
    
    func selectDrinkButton(button: UIButton){
        let color = UIColor(red:22/255, green:170/255, blue:184/255, alpha:1)
        button.setTitleColor(.white, for: .normal)
        button.tintColor = UIColor.white
        button.layer.borderColor = color.cgColor
        button.layer.backgroundColor = color.cgColor
    }
    
}
