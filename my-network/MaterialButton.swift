//
//  MaterialButton.swift
//  my-network
//
//  Created by Stefan Blos on 31.01.16.
//  Copyright © 2016 Stefan Blos. All rights reserved.
//

import UIKit

class MaterialButton: UIButton {

    override func awakeFromNib() {
        layer.shadowColor = UIColor(red: SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: 0.5).CGColor
        layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.cornerRadius = 5.0
    }

}
