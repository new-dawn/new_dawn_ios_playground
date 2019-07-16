//
//  ViewController.swift
//  NewDawn
//
//  Created by 汤子毅 on 2018/12/1.
//  Copyright © 2018 New Dawn. All rights reserved.
//

import UIKit
import CommonCrypto

// Below is a library for common used code
// applied to ALL UI VIEWS
extension UIViewController {
    
    // Define a default behavior for all views:
    // Get rid of keyboard when an user click on anywhere
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // A helper function to get URL based on prod/test
    // TODO: Figure out a better way to configure it
    func getURL(path:String, prod:Bool = CONNECT_TO_PROD) -> URL {
        var final_path = path
        if final_path.hasPrefix("/") == false {
            final_path = "/" + path
        }
        if prod {
            return URL(string: "http://new-dawn.us-west-2.elasticbeanstalk.com/api/v1" + final_path)!
        } else {
            return URL(string: "http://localhost:8000/api/v1" + final_path)!
        }
    }
    
    // A helper function to throw an alert on the screen
    // with customized function
    func displayMessage(userMessage:String, dismiss:Bool = false) -> Void {
        DispatchQueue.main.async {
            let alertController = UIAlertController(
                title: "Alert", message: userMessage, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default)
            {
                (action:UIAlertAction!) in
                if dismiss == true {
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    // This function is a wrapper of HttpUtil.processSessionTasks
    // It helps view controllers to display an alert when request failed
    func processSessionTasks(
        request: URLRequest, callback: @escaping (NSDictionary, String?) -> Void) {
        HttpUtil.processSessionTasks(request: request) {
            response, error in
            if error != nil {
                DispatchQueue.main.async {
                    self.displayMessage(userMessage: "Error: VC process session tasks failed - \(error!)")
                    callback(["success":false], "error")
                }
                return
            }
            callback(response, nil)
        }
    }
    
    // A helper function to enable activity indicator circle
    // Should be used whenever we want user to wait while loading something
    func prepareActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = false
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        return activityIndicator
    }
    
    // A helper function to remove activity indicator circle
    func removeActivityIndicator(activityIndicator: UIActivityIndicatorView) -> Void {
        DispatchQueue.main.async {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
    }
    
    // A helper function to get API Key from concatenating username and access token
    func getAPIKey(username: String, accessToken: String) -> String {
        // Concatenate according to TastyPie requirement
        return "ApiKey \(String(describing: username)):\(String(describing: accessToken))"
    }
    
    // A helper function to store key value pair locally
    func localStoreKeyValue(key: String, value: Any) -> Void {
        let userDefaults = UserDefaults.standard
        userDefaults.set(value, forKey: key)
        userDefaults.synchronize()
    }
    
    // A helper function to store key value pair locally
    // with value being a codable strct
    func localStoreKeyValueStruct<T: Codable>(key: String, value: T) -> Void {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(value), forKey: key)
    }
    
    // A helper function to get key value pair locally
    func localReadKeyValue(key: String) -> Any? {
        return UserDefaults.standard.object(forKey: key)
    }
    
    // A helper function to get key value pair locally
    // with value being a codable struct
    func localReadKeyValueStruct<T: Codable>(key: String) -> T? {
        if let data = UserDefaults.standard.value(forKey: key) as? Data {
            let value = try? PropertyListDecoder().decode(T.self, from: data)
            return value
        }
        return nil
    }
    
    // A helper function to make text field fancier
    func polishTextField(textField: UITextField) -> Void {
        textField.setLeftPaddingPoints(10)
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 20
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor(red:151/255, green:151/255, blue:151/255, alpha:1).cgColor
        textField.addDoneButtonOnKeyboard()
    }
    
    // A helper function to make text view fancier
    func polishTextView(textView: UITextView, text: String? = nil) -> Void {
        if text != nil {
            textView.text = text
        }
        textView.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        textView.layer.cornerRadius = 20
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor(red:151/255, green:151/255, blue:151/255, alpha:1).cgColor
        textView.layer.masksToBounds = true
        textView.addDoneButtonOnKeyboard()
    }
    
    // A helper function to make button fancier
    func polishUIButton(button: UIButton) -> Void {
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor(red:151/255, green:151/255, blue:151/255, alpha:1).cgColor
        button.layer.masksToBounds = true
    }
    
    // A helper function to make question block fancier
    func polishQuestionButton(button: UIButton) -> Void {
        let black = UIColor(red:0/255, green:0/255, blue:0/255, alpha:1)
        button.setTitleColor(black, for: .normal)
        button.titleLabel?.font = UIFont(name: "PingFangTC-Regular", size: 14)
        button.layer.masksToBounds = true
    }

    // A helper function to select/deselect button
    // The color is aligned with our theme
    func selectButton(button: UIButton, text: String? = nil) -> Void {
        if text != nil {
            button.setTitle(text!, for: .normal)
        }
        let color = UIColor(red:0/255, green:0/255, blue:0/255, alpha:1)
        button.setTitleColor(.white, for: .normal)
        button.layer.borderColor = color.cgColor
        button.layer.backgroundColor = color.cgColor
    }
    
    // A helper function to select/deselect button
    // The color is aligned with our theme
    func deselectButton(button: UIButton, text: String? = nil) -> Void {
        if text != nil {
            button.setTitle(text!, for: .normal)
        }
        let color = UIColor(red:128/255, green:128/255, blue:128/255, alpha:1)
        button.setTitleColor(color, for: .normal)
        button.layer.borderColor = color.cgColor
        button.layer.backgroundColor = UIColor(red:255/255, green:255/255, blue:255/255, alpha:1).cgColor
    }
    
    // Deselect all the buttons in the array.
    // Can be used in single choice scenario.
    func deselectButtons(buttons: [UIButton]) -> Void {
        let buttonsNum = buttons.count - 1
        for buttonIndex in 0...buttonsNum{
            deselectButton(button: buttons[buttonIndex])
        }
    }
    
    // Generate a centered Rectangle
    // The offsetY is used to adjust Y position
    // Can be used to construct text field, button, etc.
    func genCenterRect(width: Int, height: Int, offsetY: Int = 0) -> CGRect {
        let screenSize: CGRect = UIScreen.main.bounds
        return CGRect(
            x: (screenSize.width / 2) - CGFloat(width / 2),
            y: (screenSize.height / 2) - CGFloat(height / 2) + CGFloat(offsetY),
            width: CGFloat(width), height: CGFloat(height))
    }
    
    // A helper function to retrieve user preference
    func getPref() -> Dictionary<String, String> {
        var pref_params = [String: String]()
        if let from_age = LocalStorageUtil.localReadKeyValue(key: "from_age"),
            let to_age = LocalStorageUtil.localReadKeyValue(key: "to_age") {
            let age_range = (from_age as! String)+","+(to_age as! String)
            pref_params += ["age__range": age_range]
        }
        if let from_height = LocalStorageUtil.localReadKeyValue(key: "from_height"),
            let to_height = LocalStorageUtil.localReadKeyValue(key: "to_height") {
            let height_range = (from_height as! String) + "," + (to_height as! String)
            pref_params += ["height__range": height_range]
        }
        return pref_params
    }
    
    func getReviewStatus() -> Dictionary<String, String> {
        return ["review_status__gte": String(UserReviewStatus.NORMAL.rawValue)]
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    @IBInspectable var doneAccessory: Bool{
        get{
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone{
                addDoneButtonOnKeyboard()
            }
        }
    }
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        self.resignFirstResponder()
    }
}

extension UITextView {

    @IBInspectable var doneAccessory: Bool{
        get{
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone{
                addDoneButtonOnKeyboard()
            }
        }
    }
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        self.resignFirstResponder()
    }
}


/* Helper function to merge two dicts */
extension Dictionary {
    
    static func += (lhs: inout Dictionary, rhs: Dictionary) {
        lhs.merge(rhs) { (_, new) in new }
    }
}

extension UITextField {
    func setBottomBorder() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}

extension String{
    static func MD5(_ string: String) -> String? {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        var digest = [UInt8](repeating: 0, count: length)
        
        if let d = string.data(using: String.Encoding.utf8) {
            _ = d.withUnsafeBytes { (body: UnsafePointer<UInt8>) in
                CC_MD5(body, CC_LONG(d.count), &digest)
            }
        }
        
        return (0..<length).reduce("") {
            $0 + String(format: "%02x", digest[$1])
        }
    }
}


// controller() will return the closest responder that is of type UIViewController Then on the returned controller, you can use navigationController tofind its navigation controller.
extension UIView {
    
    func controller() -> UIViewController? {
        if let nextViewControllerResponder = next as? UIViewController {
            return nextViewControllerResponder
        }
        else if let nextViewResponder = next as? UIView {
            return nextViewResponder.controller()
        }
        else  {
            return nil
        }
    }
}
