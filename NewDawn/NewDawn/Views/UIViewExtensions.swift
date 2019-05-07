//
//  UIView extensions.swift
//
//  Created by Ziyi Tang on 25/07/2016.
//  Copyright © 2016 Ziyi Tang. All rights reserved.
//

import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
            self.layer.masksToBounds = true
        }
    }
}
