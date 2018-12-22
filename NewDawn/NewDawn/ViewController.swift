//
//  ViewController.swift
//  NewDawn
//
//  Created by 汤子毅 on 2018/12/1.
//  Copyright © 2018 New Dawn. All rights reserved.
//

import UIKit

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
    func getURL(path:String, prod:Bool = false) -> URL {
        if prod {
            return URL(string: "http://django-env.w8iffghn9z.us-west-2.elasticbeanstalk.com/api/v1/" + path)!
        } else {
            return URL(string: "http://localhost:8000/api/v1/" + path)!
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
    
    // A helper function to handle HTTP request with a callback function
    func processSessionTasks(
        request: URLRequest, callback: @escaping (NSDictionary) -> Void) {
        let task = URLSession.shared.dataTask(with: request) {
            (data: Data?, response: URLResponse?, error: Error?) in
            
            // Check response error
            if error != nil
            {
                self.displayMessage(userMessage: "Could not perform this request")
                print("error=\(String(describing: error!))")
                return
            }
            // Parse Response
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                if let parseJSON = json {
                    callback(parseJSON)
                }
                print("Session Task Processed")
            } catch {
                print("Error processing response")
                self.displayMessage(userMessage: "Error processing response", dismiss: false)
            }
        }
        task.resume()
    }
    
    // A helper function to get API Key from concatenating username and access token
    func getAPIKey(username: String, accessToken: String) -> String {
        // Concatenate according to TastyPie requirement
        return "ApiKey \(String(describing: username)):\(String(describing: accessToken))"
    }
    
    // A helper function to store key value pair locally
    func localStoreKeyValue(key: String, value: String) -> Void {
        let userDefaults = UserDefaults.standard
        userDefaults.set(value, forKey: key)
        userDefaults.synchronize()
    }
    
    // A helper function to get key value pair locally
    func localReadKeyValue(key: String) -> String {
        if let value: String = UserDefaults.standard.object(forKey: key) as! String? {
            return value
        }
        return "No Value Founded"
    }
    
    // A helper function to make text field fancier
    func polishTextField(textField: UITextField) -> Void {
        textField.setLeftPaddingPoints(25)
        textField.layer.cornerRadius = 20
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor(red:151/255, green:151/255, blue:151/255, alpha:1).cgColor
        textField.layer.masksToBounds = true
    }
}


