//
//  PhotoLayout.swift
//  NewDawn
//
//  Created by Junlin Liu on 5/12/19.
//  Copyright © 2019 New Dawn. All rights reserved.
//

import Foundation
import UIKit

class PhotoCollectionViewLayout: UICollectionViewLayout {
    private var cellLayouts: [AnyHashable : Any] = [:]
    private var unitSize = CGSize.zero
    
    init(size: CGSize) {
        super.init()
        unitSize = CGSize(width: size.width / 100, height: size.height / 100)
        cellLayouts = [:]
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepare() {
        
        for i in 0..<collectionView!.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: i, section: 0)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            var frame: CGRect
            switch indexPath.item {
            case 0:
                frame = CGRect(x: 0, y: 0, width: unitSize.width * 65, height: unitSize.height * 65)
            case 1:
                frame = CGRect(x: unitSize.width * 70.5, y: 0, width: unitSize.width * 29.5, height: unitSize.height * 29.5)
            case 2:
                frame = CGRect(x: unitSize.width * 70.5, y: unitSize.height * 35, width: unitSize.width * 29.5, height: unitSize.height * 29.5)
            case 3:
                frame = CGRect(x: 0, y: unitSize.height * 70, width: unitSize.width * 29.5, height: unitSize.height * 29.5)
            case 4:
                frame = CGRect(x: unitSize.width * 35, y: unitSize.height * 70, width: unitSize.width * 29.5, height: unitSize.height * 29.5)
            case 5:
                frame = CGRect(x: unitSize.width * 70, y: unitSize.height * 70, width: unitSize.width * 29.5, height: unitSize.height * 29.5)
            default:
                frame = CGRect.zero
            }
            attributes.frame = frame
            cellLayouts[indexPath] = attributes
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var retAttributes: [AnyHashable] = []
        for (anIndexPath, _) in cellLayouts {
            let attributes = cellLayouts[anIndexPath] as? UICollectionViewLayoutAttributes
            if rect.intersects((attributes?.frame)!) {
                if let attributes = attributes {
                    retAttributes.append(attributes)
                }
            }
        }
        return retAttributes as? [UICollectionViewLayoutAttributes]
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        return cellLayouts[indexPath] as? UICollectionViewLayoutAttributes
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: unitSize.width * 100, height: unitSize.height * 100)
    }
}
