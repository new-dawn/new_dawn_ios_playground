//
//  Profile_PhotosUpload.swift
//  NewDawn
//
//  Created by Tianchu Xie on 12/30/18.
//  Copyright © 2018 New Dawn. All rights reserved.
//

import UIKit

class Profile_PhotosUpload: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.editedImage] as? UIImage{
            imageView.image = image
        }else if let image = info[.originalImage] as? UIImage {
            imageView.image = image
        } else {
            
            print("There was a problem getting the image")
            
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }


    @IBAction func chooseImage(_ sender: Any) {
        
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.delegate = self
//        let actionSheet = UIAlertController()
        imagePickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
        
        imagePickerController.allowsEditing = true
        
        
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
