//
//  PreferenceSonViewControler.swift
//  NewDawn
//
//  Created by Junlin Liu on 4/17/19.
//  Copyright © 2019 New Dawn. All rights reserved.
//

import Foundation
import UIKit
import RangeSeekSlider

class AgePrefViewController: UIViewController{
    
    
    @IBOutlet weak var ageSlider: RangeSeekSlider!
    var age_pref: String = UNKNOWN
    var from_age = 18
    var to_age = 60
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ageSlider.handleColor = UIColor(red: 92/255, green: 117/255, blue: 163/255, alpha: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        from_age = Int(LocalStorageUtil.localReadKeyValue(key: "from_age") as? Int ?? 18)
        to_age = Int(LocalStorageUtil.localReadKeyValue(key: "to_age") as? Int ?? 60)
        ageSlider.selectedMinValue = CGFloat(from_age)
        ageSlider.selectedMaxValue = CGFloat(to_age)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let display = String(Int(self.ageSlider.selectedMinValue)) + " ~ " + String(Int(self.ageSlider.selectedMaxValue)) + " 岁"
        LocalStorageUtil.localStoreKeyValue(key: "age_pref", value:display)
        LocalStorageUtil.localStoreKeyValue(key: "from_age", value: Int(self.ageSlider.selectedMinValue))
        LocalStorageUtil.localStoreKeyValue(key: "to_age", value: Int(self.ageSlider.selectedMaxValue))
    }
    
}




class HeightPrefViewController: UIViewController{
    
    var from_height = 140
    var to_height = 250
    @IBOutlet weak var heightSlider: RangeSeekSlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        heightSlider.handleColor = UIColor(red: 92/255, green: 117/255, blue: 163/255, alpha: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        from_height = Int(LocalStorageUtil.localReadKeyValue(key: "from_height") as? Int ?? 140)
        to_height = Int(LocalStorageUtil.localReadKeyValue(key: "to_height") as? Int ?? 250)
        heightSlider.selectedMinValue = CGFloat(from_height)
        heightSlider.selectedMaxValue = CGFloat(to_height)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let display = String(Int(self.heightSlider.selectedMinValue)) + " ~ " + String(Int(self.heightSlider.selectedMaxValue)) + " cm"
        LocalStorageUtil.localStoreKeyValue(key: "height_pref", value:display)
        LocalStorageUtil.localStoreKeyValue(key: "from_height", value: Int(self.heightSlider.selectedMinValue))
        LocalStorageUtil.localStoreKeyValue(key: "to_height", value: Int(self.heightSlider.selectedMaxValue))
    }
    
}
