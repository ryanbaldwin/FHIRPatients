//
//  PicklistCellTableViewCell.swift
//  FHIRDevDays
//
//  Created by Ryan Baldwin on 2017-10-15.
//  Copyright © 2017 bunnyhug.me. All rights reserved.
//

import UIKit
import FireKit

class TelecomCell: UITableViewCell {
    @IBOutlet weak var systemButton: UIButton!
    @IBOutlet weak var valueField: UnderlinedTextField!
    
    var contactPoint: ContactPoint? {
        didSet {
            systemButton.setTitle(contactPoint?.system, for: .normal)
            valueField.text = contactPoint?.value
        }
    }
}
