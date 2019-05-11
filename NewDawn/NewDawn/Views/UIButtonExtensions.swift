//
//  UIView extensions.swift
//
//  Created by Ziyi Tang on 25/07/2016.
//  Copyright © 2016 Ziyi Tang. All rights reserved.
//

import UIKit

extension UIButton {
    @IBInspectable var topEdgeInset: CGFloat {
        get {
            return self.titleEdgeInsets.top
        }
        set {
            self.titleEdgeInsets.top = newValue
        }
    }
}
