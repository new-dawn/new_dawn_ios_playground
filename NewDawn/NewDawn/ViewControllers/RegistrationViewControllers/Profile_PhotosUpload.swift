//
//  Profile_PhotosUpload.swift
//  NewDawn
//
//  Created by Tianchu Xie on 12/30/18.
//  Copyright © 2018 New Dawn. All rights reserved.
//

import UIKit

class Profile_PhotosUpload: UIViewController {
    struct ImageItem {
        let imageName: String!
        var image: UIImage!
    }
    
    
    @IBOutlet var collectionView: UICollectionView!
    lazy var imageCV = ProfileImageUploadModel(collectionView, self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("good")
        collectionView.delegate = imageCV
        collectionView.dataSource = imageCV
        collectionView.dragInteractionEnabled = true
        collectionView.register(UINib(nibName: "ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "imageCell")
    }
    
    
    override func shouldPerformSegue(withIdentifier identifier: String,
                                     sender: Any?) -> Bool{
        let dataPath = ImageUtil.getPersonalImagesDirectory()
        print(dataPath)
        var stored_files = try?FileManager.default.contentsOfDirectory(atPath: dataPath)
        stored_files = stored_files?.filter{$0 != ".DS_Store"}
        if (stored_files!.count < 3) {
            self.displayMessage(userMessage: "为了帮助你配对，请最少上传3张符合要求的照片喔。")
            return false
        }else{
            return true
        }
    }
    
    // Save saves images in collection view to document directory
    @IBAction func continueUploadImageTapped(_ sender: Any) {
        
        if shouldPerformSegue(withIdentifier: "image_continue", sender: self){
            performSegue(withIdentifier: "image_continue", sender: self)
        }
    }
}
