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
        layer.borderWidth = 1.5
        layer.masksToBounds = false
        tintColor = .white
        layer.borderColor = UIColor.lightGray.cgColor
        layer.backgroundColor = UIColor.lightGray.cgColor
        layer.cornerRadius = bounds.height / 2
        clipsToBounds = true
    }
}
