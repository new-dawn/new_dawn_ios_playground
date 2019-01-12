//
//  MainPageTableViewCell.swift
//  NewDawn
//
//  Created by 汤子毅 on 2019/1/6.
//  Copyright © 2019 New Dawn. All rights reserved.
//

import UIKit

class MainPageTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

class BasicInfoViewCell: UITableViewCell {
    // TODO: Add IBOutlet for Basic Info Entries
    var item: MainPageViewModellItem? {
        didSet {
            guard let _ = item as? BasicInfoViewModelItem else { return }
        }
    }
}

class QuestionAnswerViewCell: UITableViewCell {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    
    var item: MainPageViewModellItem? {
        didSet {
            guard let item = item as? QuestionAnswerViewModelItem else { return }
            questionLabel?.text = item.question
            answerLabel?.text = item.answer
        }
    }
}

class MainImageViewCell: UITableViewCell {
    
    @IBOutlet weak var mainImageView: UIImageView!

    var item: MainPageViewModellItem? {
        didSet {
            guard let item = item as? MainImageViewModelItem else { return }
            mainImageView!.downloaded(from: mainImageView!.getURL(path: item.mainImageURL))
        }
    }
}
