//
//  EditPatientViewController.swift
//  FHIRDevDays
//
//  Created by Ryan Baldwin on 2017-10-08.
//  Copyright © 2017 bunnyhug.me. All rights reserved.
//

import UIKit

class EditPatientViewController: UITableViewController {
    enum Sections: Int {
        case telecoms, count
    }
    
    @IBOutlet weak var userImage: PatientAvatarView!
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
        tableView.register(UINib.init(nibName: "AddCollectionItemCell", bundle: nil),
                           forCellReuseIdentifier: "AddCollectionItemCell")
        
        tableView.register(UINib.init(nibName: "EditContactPointCell", bundle: nil),
                           forCellReuseIdentifier: "EditContactPointCell")
        
        setupNavigation()
        setupBirthdate()
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
    
    private func bindData() {
        userImage.image = model.image
        givenNameTextField.text = model.givenName
        familyNameTextField.text = model.familyName
        
        if let gender = model.gender {
            genderControl.selectedSegmentIndex = gender.rawValue
        }
    }
}
