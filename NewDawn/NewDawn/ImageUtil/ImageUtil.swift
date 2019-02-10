//
//  ImageUtil.swift
//  NewDawn
//
//  Created by 汤子毅 on 2019/2/10.
//  Copyright © 2019 New Dawn. All rights reserved.
//

import Foundation
import UIKit

class ImageUtil {
    static func roundImageView(imageView: UIImageView) -> Void {
        imageView.layer.masksToBounds = false
        imageView.layer.cornerRadius = imageView.frame.height/2
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.clear.cgColor
        imageView.clipsToBounds = true
    }
}
