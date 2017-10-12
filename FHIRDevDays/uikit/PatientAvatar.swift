//
//  PatientAvatar.swift
//  FHIRDevDays
//
//  Created by Ryan Baldwin on 2017-10-12.
//  Copyright © 2017 bunnyhug.me. All rights reserved.
//

import UIKit

class PatientAvatarView: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.borderWidth = 2
        layer.masksToBounds = false
        layer.borderColor = tintColor.cgColor
        layer.backgroundColor = UIColor.white.cgColor
        layer.cornerRadius = bounds.height / 2
        clipsToBounds = true
    }
}
