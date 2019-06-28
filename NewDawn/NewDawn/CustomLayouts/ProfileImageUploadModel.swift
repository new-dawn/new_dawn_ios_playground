//
//  ProfileImageUploadModel.swift
//  NewDawn
//
//  Created by Junlin Liu on 6/4/19.
//  Copyright © 2019 New Dawn. All rights reserved.
//

import Foundation
import UIKit


class ProfileImageUploadModel: NSObject{
    
    struct ImageItem {
        let imageName: String!
        var image: UIImage!
    }
    var collectionView: UICollectionView?
    var viewcontroller: UIViewController?
    var longPressGesture: UILongPressGestureRecognizer!
    let itemCount = 6
    let picker = UIImagePickerController()
    var clicked_image = 0
    var imagesArray = [ImageItem(imageName: "", image: BLANK_IMG), ImageItem(imageName: "", image: BLANK_IMG), ImageItem(imageName: "", image: BLANK_IMG), ImageItem(imageName: "", image: BLANK_IMG), ImageItem(imageName: "", image: BLANK_IMG), ImageItem(imageName: "", image: BLANK_IMG)]
    let dataPath = ImageUtil.getPersonalImagesDirectory()
    
    init(_ cv: UICollectionView, _ Controller: UIViewController?, _ size: Int) {
        super.init()
        collectionView = cv
        viewcontroller = Controller
        let customLayout = PhotoCollectionViewLayout(size: CGSize(width: size, height: size))
        collectionView!.collectionViewLayout = customLayout
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongGesture(gesture:)))
        collectionView!.addGestureRecognizer(longPressGesture)
        picker.delegate = self
        checkFolderExistOrCreate()
        fillCellsWithImages()
    }
    
    func checkFolderExistOrCreate(){
        if !FileManager.default.fileExists(atPath: dataPath) {
            do {
                try FileManager.default.createDirectory(atPath: dataPath, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Couldn't create document directory")
            }
        }
    }
    
    func fillCellsWithImages(){
        if let local_images = ImageUtil.getPersonalImagesWithData(){
            for local_image in local_images{
                let order = local_image["order"] as? Int
                let single_img = local_image["img"]
                imagesArray[order ?? 0].image = (single_img as! UIImage)
            }
        }
    }
    
    // Control state of gesture
    @objc func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        switch(gesture.state){
            
        case .began:
            guard let selectedIndexPath = self.collectionView!.indexPathForItem(at: gesture.location(in: collectionView)) else {
                break
            }
            self.collectionView!.beginInteractiveMovementForItem(at: selectedIndexPath)
            
        case .changed:
            self.collectionView!.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
            
        // TODO: weired flashes after end interactive movement
        case .ended:
            self.collectionView!.endInteractiveMovement()
            self.collectionView!.reloadData()
        default:
            collectionView!.cancelInteractiveMovement()
        }
    }
}


// Handle collection view data source and delegate
extension ProfileImageUploadModel: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImageCollectionViewCell
        cell.backgroundColor = UIColor.white
        print(cell.imageview)
        cell.imageview.image = imagesArray[indexPath.row].image as UIImage
        let delete_button = cell.deleteButton
        delete_button!.tag = indexPath.row
        if imagesArray[indexPath.row].image != BLANK_IMG{
            delete_button?.addTarget(self, action: #selector(tap(_:)), for: .allTouchEvents)
        } else {
            delete_button?.removeTarget(self, action: #selector(tap(_:)), for: .allTouchEvents)
        }
        return cell
    }
    
    // Enable drag and drop
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        if imagesArray[indexPath.row].image == BLANK_IMG{
            return false
        }
        return true
    }
    
    // Define start and destination object
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = self.imagesArray[sourceIndexPath.row]
        self.imagesArray.remove(at: sourceIndexPath.row)
        self.imagesArray.insert(item, at: destinationIndexPath.row)
        swapLocalImages(sourceRow: sourceIndexPath.row, destRow: destinationIndexPath.row)
        
    }
    
    func swapLocalImages(sourceRow: Int, destRow:Int) -> Void{
        let dataPath = URL(fileURLWithPath: ImageUtil.getPersonalImagesDirectory())
        if sourceRow > destRow{
            // Source to temp name
            var originPath = dataPath.appendingPathComponent(String(sourceRow) + ".jpeg")
            var destinationPath = dataPath.appendingPathComponent("temp.jpeg")
            do {
                try FileManager.default.moveItem(at: originPath, to: destinationPath)
            } catch {
                print(error)
            }
            for index in stride(from: sourceRow - 1, to: destRow - 1, by: -1){
                originPath = dataPath.appendingPathComponent(String(index) + ".jpeg")
                destinationPath = dataPath.appendingPathComponent(String(index + 1) + ".jpeg")
                do {
                    try FileManager.default.moveItem(at: originPath, to: destinationPath)
                } catch {
                    print(error)
                }
            }
            originPath = dataPath.appendingPathComponent("temp.jpeg")
            destinationPath = dataPath.appendingPathComponent(String(destRow) + ".jpeg")
            do {
                try FileManager.default.moveItem(at: originPath, to: destinationPath)
            } catch {
                print(error)
            }
        }else if sourceRow < destRow{
            // Source to temp name
            var originPath = dataPath.appendingPathComponent(String(sourceRow) + ".jpeg")
            var destinationPath = dataPath.appendingPathComponent("temp.jpeg")
            do {
                try FileManager.default.moveItem(at: originPath, to: destinationPath)
            } catch {
                print(error)
            }
            for index in stride(from: sourceRow + 1, to: destRow + 1, by: 1){
                originPath = dataPath.appendingPathComponent(String(index) + ".jpeg")
                destinationPath = dataPath.appendingPathComponent(String(index - 1) + ".jpeg")
                do {
                    try FileManager.default.moveItem(at: originPath, to: destinationPath)
                } catch {
                    print(error)
                }
            }
            originPath = dataPath.appendingPathComponent("temp.jpeg")
            destinationPath = dataPath.appendingPathComponent(String(destRow) + ".jpeg")
            do {
                try FileManager.default.moveItem(at: originPath, to: destinationPath)
            } catch {
                print(error)
            }
        }else{
            return
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        clicked_image = indexPath.row
        let alert = UIAlertController(title: "Photo", message: "Choose Photo", preferredStyle: .actionSheet)
        
        //        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) in
        //            self.camera()
        //        }))
        
        alert.addAction(UIAlertAction(title: "Gallary", style: .default, handler: { (action) in
            self.gallary()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in}))
        viewcontroller!.present(alert,animated: true,completion: nil)
    }
}



// Handle image related behavior
extension ProfileImageUploadModel: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @objc func tap(_ sender: UIButton){
        collectionView!.reloadData()
        clicked_image = sender.tag
        let alert = UIAlertController(title: "确定要删除这张照片吗？", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "是", style: .default, handler: { (action) in
            
            self.imagesArray[self.clicked_image].image = BLANK_IMG
            let dataPath = ImageUtil.getPersonalImagesDirectory()
            var fileURL = URL(fileURLWithPath:dataPath).appendingPathComponent(String(self.clicked_image))
            fileURL = fileURL.appendingPathExtension("jpeg")
            do {
                try FileManager.default.removeItem(at: fileURL)
            }catch{
                print(error.localizedDescription)
            }
            self.collectionView!.reloadData()
        }))
        
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (action) in}))
        viewcontroller!.present(alert,animated: true,completion: nil)
    }
    
    //    func camera() {
    //        picker.allowsEditing = true
    //        picker.sourceType = .camera
    //        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .camera)!
    //        present(picker,animated: true ,completion: nil)
    //    }
    
    func gallary() {
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        viewcontroller!.present(picker,animated: true ,completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let editedView = info[.editedImage] as! UIImage
        let editedViewItem = ImageItem(imageName: "", image: editedView)
        imagesArray[clicked_image] = editedViewItem
        
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
            print("cannot compress the image")
        }
        
        viewcontroller!.dismiss(animated: true, completion: nil)
        
        collectionView!.reloadData()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        viewcontroller!.dismiss(animated: true, completion: nil)
    }
}
