//
//  PatientAvatar.swift
//  FHIRDevDays
//
//  Created by Ryan Baldwin on 2017-10-12.
//  Copyright © 2017 bunnyhug.me. All rights reserved.
//

import UIKit

/// A circular UIImageView which displays a picture of the patient.
class PatientAvatarView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override var image: UIImage? {
        didSet {
            if image == nil {
                image = #imageLiteral(resourceName: "user")
            }
        }
    }
    
    private func setup() {
        contentMode = .scaleAspectFill
        image = #imageLiteral(resourceName: "user")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.borderWidth = 1.5
        layer.masksToBounds = false
        tintColor = .white
        layer.borderColor = UIColor.lightGray.cgColor
        layer.backgroundColor = UIColor.lightGray.cgColor
        layer.cornerRadius = bounds.height / 2
        clipsToBounds = true
    }
}
