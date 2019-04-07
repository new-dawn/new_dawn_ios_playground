//
//  Profile_PhotosUpload.swift
//  NewDawn
//
//  Created by Tianchu Xie on 12/30/18.
//  Copyright © 2018 New Dawn. All rights reserved.
//

import UIKit

class Profile_PhotosUpload: UIViewController {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    fileprivate var longPressGesture: UILongPressGestureRecognizer!
    
    let picker = UIImagePickerController()
    // Use this variable to track which image to replace with
    var clicked_image = 0
    var imagesArray = NSMutableArray()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Default images
        imagesArray = [BLANK_IMG, BLANK_IMG, BLANK_IMG, BLANK_IMG, BLANK_IMG, BLANK_IMG]
        
        // Get documents folder
        let dataPath = ImageUtil.getPersonalImagesDirectory()
        
        //Check is folder available or not, if not create
        if !FileManager.default.fileExists(atPath: dataPath) {
            do {
                try FileManager.default.createDirectory(atPath: dataPath, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Couldn't create document directory")
            }
        }
        
        // Fill in cells with existing images
        if let local_images = ImageUtil.getPersonalImagesWithData(){
            for local_image in local_images{
                let order = local_image["order"] as! Int
                let single_img = local_image["img"]
                imagesArray[order] = single_img as! UIImage
            }
        }
        
        // Delegate
        collectionView.dataSource = self
        collectionView.delegate = self
        picker.delegate = self
        
        // Layout
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        // square spacing
        layout.itemSize = CGSize(width: (self.collectionView.frame.size.width - 40) / 3, height: (self.collectionView.frame.size.width - 40) / 3)
        
        // Handle long press gesture
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongGesture(gesture:)))
        collectionView.addGestureRecognizer(longPressGesture)
    }
    
    // Control state of gesture
    @objc func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        switch(gesture.state){
            
        case .began:
            guard let selectedIndexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else {
                break
            }
            collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
            
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        
        // TODO: weired flashes after end interactive movement
        case .ended:
            collectionView.performBatchUpdates({
                self.collectionView.endInteractiveMovement()
            })

        default:
            collectionView.cancelInteractiveMovement()
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String,
                                     sender: Any?) -> Bool{
        let images = imagesArray as NSArray as! [UIImage]
        let used_images = images.filter{$0 != BLANK_IMG}
        if (used_images.count < 3) {
            self.displayMessage(userMessage: "Need to upload at least 3 images")
            return false
        }else{
            return true
        }
    }
    
    // Save saves images in collection view to document directory
    @IBAction func continueUploadImageTapped(_ sender: Any) {
        
        let dataPath = ImageUtil.getPersonalImagesDirectory()
        print(dataPath)
        var stored_files = try?FileManager.default.contentsOfDirectory(atPath: dataPath)
        stored_files = stored_files?.filter{$0 != ".DS_Store"}
        print(stored_files!)
        
        if shouldPerformSegue(withIdentifier: "image_continue", sender: self){
            performSegue(withIdentifier: "image_continue", sender: self)
        }
    }
}



// Handle collection view data source and delegate
extension Profile_PhotosUpload: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCollectionViewCell
        cell.backgroundColor = UIColor.gray
        cell.deleteButtonBackgroundView.layer.cornerRadius = 0.5 * cell.deleteButtonBackgroundView.bounds.size.width
        cell.deleteButtonBackgroundView.clipsToBounds = true
        cell.deleteButtonBackgroundView.backgroundColor = UIColor.white
        cell.myImage.image = imagesArray[indexPath.row] as? UIImage
        let delete_button = cell.deleteButton
        delete_button!.tag = indexPath.row
        delete_button?.addTarget(self, action: #selector(tap(_:)), for: .allTouchEvents)
        
        return cell
    }
    
    // Enable drag and drop
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Define start and destination object
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let item = imagesArray[sourceIndexPath.item]
        imagesArray.removeObject(at: sourceIndexPath.item)
        imagesArray.insert(item, at: destinationIndexPath.item)
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
}

// Handle image related behavior
extension Profile_PhotosUpload: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @objc func tap(_ sender: UIButton){
        clicked_image = sender.tag
        let alert = UIAlertController(title: "Delete this Image", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            self.imagesArray.removeObject(at: self.clicked_image)
            self.imagesArray.insert(BLANK_IMG, at: self.clicked_image)
            
            let dataPath = ImageUtil.getPersonalImagesDirectory()
            var fileURL = URL(fileURLWithPath:dataPath).appendingPathComponent(String(self.clicked_image))
            fileURL = fileURL.appendingPathExtension("jpeg")
            do {
                try FileManager.default.removeItem(at: fileURL)
            }catch{
                print(error.localizedDescription)
            }
            self.collectionView.reloadData()
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action) in}))
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
        
        // Compress and save images
        let dataPath = ImageUtil.getPersonalImagesDirectory()
        var fileURL = URL(fileURLWithPath:dataPath).appendingPathComponent(String(clicked_image))
        if var imagedata = editedView.jpegData(compressionQuality: 1.0) {
            if (imagedata.count > MAX_IMG_SIZE){
                imagedata = ImageUtil.compressJPEG(image: editedView)!
            }
            fileURL = fileURL.appendingPathExtension("jpeg")
            do{
                try imagedata.write(to: fileURL, options: .atomic)
            }catch{
                print ("error", error)
            }
            
        }else{
            self.displayMessage(userMessage: "cannot compress the image", dismiss: false)
        }
        
        dismiss(animated: true, completion: nil)
        
        collectionView.reloadData()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
