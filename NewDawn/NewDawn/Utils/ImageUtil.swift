//
//  ImageUtil.swift
//  NewDawn
//
//  Created by 汤子毅 on 2019/2/10.
//  Copyright © 2019 New Dawn. All rights reserved.
//

import Foundation
import UIKit

let MAX_IMG_SIZE = 256000
// This image can be replaced by other default images
let BLANK_IMG = UIImage(named: "MeTab")!

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
        if let imageFromCache = imageCache.object(forKey: url as AnyObject) as? UIImage {
            DispatchQueue.main.async() {
                callback(imageFromCache)
            }
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                imageCache.setObject(image, forKey: url as AnyObject)
                callback(image)
            }
        }.resume()
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
}
