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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        valueField.delegate = self
    }
    
    var contactPoint: ContactPoint? {
        didSet {
            systemButton.setTitle(contactPoint?.system ?? "other", for: .normal)
            valueField.text = contactPoint?.value
            
            if let system = contactPoint?.system,
                let contactPointSystem = ContactPointSystem(rawValue: system) {
                switch contactPointSystem {
                case .email:
                    valueField.keyboardType = .emailAddress
                case .fax, .pager, .phone:
                    valueField.keyboardType = .phonePad
                default:
                    break
                }
            }
        }
    }
    
    @IBAction func editingChanged(_ sender: Any) {
        contactPoint!.value = valueField.text
    }
    
    @IBAction func systemButtonTapped(_ sender: Any) {
        didTapSystemButton?(sender)
    }
}

extension EditContactPointCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
