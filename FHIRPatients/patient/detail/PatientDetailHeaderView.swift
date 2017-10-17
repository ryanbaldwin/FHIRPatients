//
//  PatientDetailHeaderView.swift
//  FHIRDevDays
//
//  Created by Ryan Baldwin on 2017-10-12.
//  Copyright © 2017 bunnyhug.me. All rights reserved.
//

import UIKit

class PatientDetailHeaderView: UIView {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var birthLabel: UILabel!
    @IBOutlet weak var avatar: PatientAvatarView!
    
    var model: PatientModel? {
        didSet {
            configureHeaderView()
        }
    }
    
    let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .short
        return f
    }()
    
    private func configureHeaderView() {
        guard var model = self.model else {
            nameLabel.text = nil
            birthLabel.text = nil
            return
        }
        
        avatar.image = model.image
        nameLabel.text = "\(model.givenName ?? "J.") \(model.familyName ?? "Doe")"
        
        let birthDetails: [String?] = [model.gender != nil ? "\(model.gender!)" : nil,
                                       model.dateOfBirth != nil
                                        ? formatter.string(from: (model.dateOfBirth)!)
                                        : nil]
        let details = birthDetails.flatMap { $0 }.joined(separator: " - ")
        guard details.isEmpty == false else {
            birthLabel.isHidden = true
            return
        }
        
        birthLabel.text = details
    }
}
