//
//  PatientDetailHeaderView.swift
//  FHIRDevDays
//
//  Created by Ryan Baldwin on 2017-10-12.
//  Copyright © 2017 bunnyhug.me. All rights reserved.
//

import UIKit

/// Provides a view of a patient's basic demographic information.
class PatientDetailHeaderView: UIView {
    /// A label which contains the patient's full name.
    @IBOutlet weak var nameLabel: UILabel!
    
    /// A label which contains the patient's gender and date of birth
    @IBOutlet weak var birthLabel: UILabel!
    
    /// An avatar of the patient.
    @IBOutlet weak var avatar: PatientAvatarView!
    
    /// Gets/sets the `PatientModel` whose data will be rendered by this view.
    var model: PatientModel? {
        didSet {
            bindNameLabel(to: model)
            bindBirthLabel(to: model)
            bindAvatar(to: model)
        }
    }
    
    /// Binds this instance's `nameLabel` to the provided `PatientModel`
    ///
    /// - Parameter model: The `PatientModel` providing the names of the patient.
    private func bindNameLabel(to model: PatientModel?) {
        guard let model = model else {
            nameLabel.text = nil
            return
        }
        
        nameLabel.text = "\(model.givenName ?? "J.") \(model.familyName ?? "Doe")"
    }
    
    /// Binds this instance's `birthLabel` to the provided `PatientModel`
    ///
    /// - Parameter model: The `PatientModel` providing the gender and date of birth of the patient.
    private func bindBirthLabel(to model: PatientModel?) {
        guard let model = model else {
            birthLabel.text = nil
            return
        }
        
        let birthDetails: [String?] = [model.gender != nil ? "\(model.gender!)" : nil,
                                       model.dateOfBirth != nil
                                        ? DateFormatter.dateOfBirthFormatter.string(from: (model.dateOfBirth)!)
                                        : nil]
        let details = birthDetails.flatMap { $0 }.joined(separator: " - ")
        guard details.isEmpty == false else {
            birthLabel.isHidden = true
            return
        }
        
        birthLabel.text = details
    }
    
    /// Binds this instance's `avatar` to the provided `PatientModel`
    ///
    /// - Parameter model: The `PatientModel` providing the image of the patient.
    private func bindAvatar(to model: PatientModel?) {
        guard let model = model else { return }
        avatar.image = model.image
    }
}
