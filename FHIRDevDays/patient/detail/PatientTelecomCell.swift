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
    
    
    var contactPoint: ContactPoint? {
        didSet {
            configureCell()
        }
    }
    
    private func configureCell() {
        
    }
}
