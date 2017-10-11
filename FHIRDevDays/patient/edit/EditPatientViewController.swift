//
//  EditPatientViewController.swift
//  FHIRDevDays
//
//  Created by Ryan Baldwin on 2017-10-08.
//  Copyright © 2017 bunnyhug.me. All rights reserved.
//

import UIKit

class EditPatientViewController: UIViewController {
    enum State {
        case readonly, edit
    }
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var givenNameTextField: UnderlinedTextField!
    @IBOutlet weak var familyNameTextField: UnderlinedTextField!
    @IBOutlet weak var genderControl: UISegmentedControl!
    @IBOutlet weak var birthdateTextField: UnderlinedTextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet var datePickerToolbar: UIToolbar!
    
    lazy var cancelButton: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .cancel,
                               target: self,
                               action: #selector(cancelEditButtonTapped))
    }()
    
    lazy var doneButton: UIBarButtonItem = {
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                         target: self,
                                         action: #selector(doneEditButtonTapped))
        doneButton.isEnabled = model.canSave()
        return doneButton
    }()
    
    var model: PatientModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupBirthdate()
        setupUserImage()
        bindData()
    }
    
    private func setupNavigation() {
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = doneButton
        model.patientCanSaveChanged = { [weak self] canSave in
            self?.doneButton.isEnabled = canSave
        }
    }
    
    private func setupBirthdate() {
        birthdateTextField.inputView = datePicker
        birthdateTextField.inputAccessoryView = datePickerToolbar
    }
    
    private func setupUserImage() {
        userImage.layer.borderWidth = 3
        userImage.layer.masksToBounds = false
        userImage.layer.borderColor = UIColor.lightGray.cgColor
        userImage.layer.backgroundColor = UIColor.lightGray.cgColor
        userImage.layer.cornerRadius = userImage.bounds.height / 2
        userImage.clipsToBounds = true
    }
    
    private func bindData() {
        userImage.image = model.image
        givenNameTextField.text = model.givenName
        familyNameTextField.text = model.familyName
        
        if let gender = model.gender {
            genderControl.selectedSegmentIndex = gender.rawValue
        }
        
        
    }
}
