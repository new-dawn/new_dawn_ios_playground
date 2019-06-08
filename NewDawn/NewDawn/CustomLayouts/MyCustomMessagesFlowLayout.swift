//
//  MyCustomMessagesFlowLayout.swift
//  NewDawn
//
//  Created by 周珈弘 on 6/6/19.
//  Copyright © 2019 New Dawn. All rights reserved.
//

import Foundation
import MessageKit

open class MyCustomMessagesFlowLayout: MessagesCollectionViewFlowLayout {
    lazy open var customMessageSizeCalculator = CustomMessageSizeCalculator(layout: self)
    
    override open func cellSizeCalculatorForItem(at indexPath: IndexPath) -> CellSizeCalculator {
        let message = messagesDataSource.messageForItem(at: indexPath, in: messagesCollectionView)
        if case .custom = message.kind {
            return customMessageSizeCalculator
        }
        return super.cellSizeCalculatorForItem(at: indexPath);
    }
}

open class CustomMessageSizeCalculator: MessageSizeCalculator {
    open override func messageContainerSize(for message: MessageType) -> CGSize {
        //TODO - Customize to size your content appropriately. This just returns a constant size.
        return CGSize(width: 300, height: 130)
    }
}
