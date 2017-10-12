//
//  PatientTelecomCell.swift
//  FHIRDevDays
//
//  Created by Ryan Baldwin on 2017-10-12.
//  Copyright © 2017 bunnyhug.me. All rights reserved.
//

import UIKit
import FireKit

class PatientTelecomCell: UICollectionViewCell {
    
    @IBOutlet weak var layout: UIStackView!
    @IBOutlet weak var contactPointLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    var contactPoint: ContactPoint? {
        didSet {
            configureCell()
        }
    }
    
    private func configureCell() {
        contactPointLabel.text = contactPoint?.system
        valueLabel.text = contactPoint?.value
    }
}
