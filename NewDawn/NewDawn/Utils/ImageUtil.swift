//
//  ImageUtil.swift
//  NewDawn
//
//  Created by 汤子毅 on 2019/2/10.
//  Copyright © 2019 New Dawn. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
import Alamofire

let MAX_IMG_SIZE = 256000
// This image can be replaced by other default images
let BLANK_IMG = UIImage(named: "EmptyImage")!
let DEFAULT_IMG = UIImage(named: "LogoPlaceholder")!

class ImageUtil {
    static func polishCircularImageView(imageView: UIImageView) -> Void {
        imageView.layer.masksToBounds = false
        imageView.layer.cornerRadius = imageView.frame.height/2
        imageView.layer.borderWidth = 4
        let lightblue = UIColor(red:204/255.0, green:229.5/255.0, blue:242.25/255.0, alpha:1)
        imageView.layer.borderColor = lightblue.cgColor
        imageView.clipsToBounds = true
    }
    
    // A Binary helper function to compress a file between a maximum and minimum size of "maxSize" and "minSize", but only try "times" times. If it fails within that time, it will return nil.
    // Defualt to make image size <250kb, compress to 125kb - 250kb
    static func compressJPEG(image: UIImage, maxSize: Int = MAX_IMG_SIZE, minSize: Int = 128000, times: Int = 3) -> Data? {
        var maxQuality: CGFloat = 1.0
        var minQuality: CGFloat = 0.0
        var rightData: Data?
        for _ in 1...times {
            let thisQuality = (maxQuality + minQuality) / 2
            guard let data = image.jpegData(compressionQuality: thisQuality) else { return nil }
            let thisSize = data.count
            if thisSize > maxSize {
                maxQuality = thisQuality
            } else {
                minQuality = thisQuality
                rightData = data
                if thisSize > minSize {
                    return rightData
                }
            }
        }
        return rightData
    }
    
    static func downLoadImage(url: String, callback: @escaping (UIImage) -> Void) -> Void {
        let url = HttpUtil.getURL(path: url, isMedia: true)
        KingfisherManager.shared.retrieveImage(with: url) { result in
            switch result {
            case .success(let value):
                callback(value.image)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // Get Personal Images with data from Document Directory
    static func getPersonalImagesWithData() -> Array<[String: Any]>?{
        let dataPath = ImageUtil.getPersonalImagesDirectory()
        let datapath_url = NSURL(string: dataPath)
        var images_data = [[String: Any]]()
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: datapath_url! as URL, includingPropertiesForKeys: nil)
            for fileurl in fileURLs{
                if String(fileurl.lastPathComponent) == ".DS_Store"{
                    continue
                }
                let img = UIImage(contentsOfFile: fileurl.path)
                let order = Int(String(fileurl.lastPathComponent).prefix(1))!
                let caption = "good"
                let user_id = LoginUserUtil.getLoginUserId()
                let user_uri = "/api/v1/user/\(user_id ?? 1)/"
                images_data.append([
                    "img": img!,
                    "order": order,
                    "caption": caption,
                    "user_uri": user_uri,
                    "user_id": user_id ?? 1
                    ])
            }
        } catch {
            print("Error while enumerating files \(String(describing: datapath_url!.path)): \(error.localizedDescription)")
            return nil
        }
        return images_data
    }
    
    static func getPersonalImagesDirectory() -> String{
         let dataPath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("PersonalImages")
        return dataPath
    }
    
    // A helper function to upload image
    static func photoUploader(photo: UIImage, filename: String, parameters: [String: Any], completion: @escaping (Bool) -> Void) {
        
        let imageData = photo.jpegData(compressionQuality: 1)
        
        //        guard let authToken = Locksmith.loadDataForUserAccount(userAccount: "userToken")?["token"] as? String else {
        //            return
        //        }
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        var url: URLRequest?
        let image_upload_url = HttpUtil.getURL(path: "image/")
        
        do {
            url = try URLRequest(url: image_upload_url, method: .post, headers: headers)
        } catch {
            print("Error")
        }
        
        let data = try! JSONSerialization.data(withJSONObject: parameters)
        
        
        if let url = url {
            upload(multipartFormData: { (mpd) in
                mpd.append(imageData!, withName: "media", fileName: filename, mimeType: "image/jpeg")
                mpd.append(data, withName: "data")
            }, with: url, encodingCompletion: { (success) in
                switch success {
                case .success(let request, let streamingFromDisk, let streamFileURL):
                    completion(true)
                case .failure(let errorType):
                    completion(false)
                    print("cannot upload")
                }
            })
        }
    }
}
