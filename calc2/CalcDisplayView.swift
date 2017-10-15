//
//  CalcDisplayView.swift
//  calc2
//
//  Created by Robert Diamond on 10/14/17.
//  Copyright © 2017 Robert Diamond. All rights reserved.
//

import UIKit

class CalcDisplayView: UICollectionReusableView {
    @IBOutlet weak var label: UILabel!


    public func displayValue(newValue : Double) {
        label.text = String(newValue)
    }

}
