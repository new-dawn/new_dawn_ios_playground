//
//  Profile_PhotosUpload.swift
//  NewDawn
//
//  Created by Tianchu Xie on 12/30/18.
//  Copyright © 2018 New Dawn. All rights reserved.
//

import UIKit

class Profile_PhotosUpload: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCollectionViewCell
        cell.backgroundColor = UIColor.gray
        cell.deleteButtonBackgroundView.layer.cornerRadius = 15
        cell.deleteButtonBackgroundView.clipsToBounds = true
        cell.deleteButtonBackgroundView.backgroundColor = UIColor.white
        cell.myImage.image = imagesArray[indexPath.row] as? UIImage
        let delete_button = cell.deleteButton
        delete_button!.tag = indexPath.row
        delete_button?.addTarget(self, action: #selector(tap(_:)), for: .allTouchEvents)
        
        return cell
    }
    
    @objc func tap(_ sender: UIButton){
        clicked_image = sender.tag
        let alert = UIAlertController(title: "Delete this Image", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            self.imagesArray.removeObject(at: self.clicked_image)
            self.imagesArray.insert(self.default_button!, at: self.clicked_image)
            self.collectionView.reloadData()
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action) in}))
        present(alert,animated: true,completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        clicked_image = indexPath.row
        let alert = UIAlertController(title: "Photo", message: "Choose Photo", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) in
            self.camera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallary", style: .default, handler: { (action) in
            
            self.gallary()
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in}))
        
        present(alert,animated: true,completion: nil)
    }
    
    func camera() {
        picker.allowsEditing = true
        picker.sourceType = .camera
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .camera)!
        present(picker,animated: true ,completion: nil)
    }
    
    
    func gallary() {
        
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker,animated: true ,completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let editedView = info[.editedImage] as! UIImage
        imagesArray.removeObject(at: clicked_image)
        imagesArray.insert(editedView, at: clicked_image)
        dismiss(animated: true, completion: nil)
        
        
        collectionView.reloadData()
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }


    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let picker = UIImagePickerController()
    var clicked_image = 0
    var default_button = UIImage(named: "MeTab")
    var imagesArray = NSMutableArray()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagesArray = [default_button!, default_button!, default_button!, default_button!, default_button!, default_button!]
        collectionView.dataSource = self
        collectionView.delegate = self
        picker.delegate = self
        
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: (self.collectionView.frame.size.width - 20) / 3, height: 100)
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
