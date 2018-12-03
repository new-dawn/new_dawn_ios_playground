//
//  RegisterUserViewController.swift
//  NewDawn
//
//  Created by 汤子毅 on 2018/12/1.
//  Copyright © 2018 New Dawn. All rights reserved.
//

import UIKit

class RegisterUserViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func signUpButtonTapped(_ sender: Any) {
        // Validate required fields are not empty
        if (firstNameTextField.text?.isEmpty)! ||
            (lastNameTextField.text?.isEmpty)! ||
            (emailTextField.text?.isEmpty)! ||
            (passwordTextField.text?.isEmpty)!
        {
            self.displayMessage(userMessage: "Missing Fields", dismiss: false)
            return
        }
        
        // Validate password
        if passwordTextField.text != repeatPasswordTextField.text
        {
            self.displayMessage(userMessage: "Password Doesn't Match", dismiss: false)
            return
        }
        
        // Activity Indicator Created
        let activityIndicator = self.prepareActivityIndicator()
        
        // Create Request
        let request = self.createRegisterRequest()
        if request == nil {
            // Request Creation Failed
            return
        }
        
        // Process Request & Rmove Activity Indicator
        self.processSessionTasks(request: request!, activityIndicator: activityIndicator)

    }
    
    func createRegisterRequest() -> URLRequest? {
        let url = URL(string: "http://django-env.w8iffghn9z.us-west-2.elasticbeanstalk.com/api/v1/register/")
        var request = URLRequest(url:url!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let postString = [
            "first_name": firstNameTextField.text!,
            "last_name": lastNameTextField.text!,
            "email": emailTextField.text!,
            "password": passwordTextField.text!,
            "username": firstNameTextField.text! + lastNameTextField.text!
        ] as [String: String]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: postString, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
            self.displayMessage(userMessage: "Register Request Creation Failed", dismiss: false)
            return nil
        }
        return request
    }
    
    func processSessionTasks(request: URLRequest, activityIndicator: UIActivityIndicatorView) {
        let task = URLSession.shared.dataTask(with: request) {
            (data: Data?, response: URLResponse?, error: Error?) in
            self.removeActivityIndicator(activityIndicator: activityIndicator)
            
            // Check response error
            if error != nil
            {
                self.displayMessage(userMessage: "Could not perform this request", dismiss: false)
                print("error=\(String(describing: error!))")
                return
            }
            // TODO: Check response message to verify the user creation
            self.removeActivityIndicator(activityIndicator: activityIndicator)
            self.displayMessage(userMessage: "Registration Success", dismiss: false)
        }
        task.resume()
    }
    
    func prepareActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = false
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        return activityIndicator
    }
    
    func removeActivityIndicator(activityIndicator: UIActivityIndicatorView) -> Void {
        DispatchQueue.main.async {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
    }
    
    func displayMessage(userMessage:String, dismiss:Bool) -> Void {
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
