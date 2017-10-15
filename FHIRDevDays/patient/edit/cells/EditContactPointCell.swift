//
//  ContactPointCell.swift
//  FHIRDevDays
//
//  Created by Ryan Baldwin on 2017-10-15.
//  Copyright © 2017 bunnyhug.me. All rights reserved.
//

import UIKit
import FireKit

class EditContactPointCell: UITableViewCell {
    @IBOutlet weak var valueField: UITextField!
    @IBOutlet weak var systemButton: UIButton!
    
    var didTapSystemButton: ((Any) -> ())?
    
    var contactPoint: ContactPoint? {
        didSet {
            systemButton.setTitle(contactPoint?.system ?? "other", for: .normal)
            valueField.text = contactPoint?.value
        }
    }
    
    @IBAction func systemButtonTapped(_ sender: Any) {
        didTapSystemButton?(sender)
    }
}
