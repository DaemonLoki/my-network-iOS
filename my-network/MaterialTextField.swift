//
//  MaterialTextField.swift
//  my-network
//
//  Created by Stefan Blos on 31.01.16.
//  Copyright © 2016 Stefan Blos. All rights reserved.
//

import UIKit

class MaterialTextField: UITextField {

    override func awakeFromNib() {
        layer.borderColor = UIColor(red: SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: 0.1).CGColor
        layer.cornerRadius = 2.0
        layer.borderWidth = 1.0
    }
    
    // placeholder part
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 10, 0)
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 10, 0)
    }

}
