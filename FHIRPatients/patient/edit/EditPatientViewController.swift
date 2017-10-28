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
    
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var editPhotoButton: UIButton!
    
    @IBOutlet weak var userImage: PatientAvatarView!
    @IBOutlet weak var givenNameTextField: UnderlinedTextField!
    @IBOutlet weak var familyNameTextField: UnderlinedTextField!
    @IBOutlet weak var genderControl: UISegmentedControl!
    @IBOutlet weak var birthdateTextField: UnderlinedTextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet var datePickerToolbar: UIToolbar!
    
    lazy var imagePicker: UIImagePickerController = {
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.allowsEditing = false
        controller.sourceType = .photoLibrary
        controller.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        return controller
    }()
    
    lazy var camera: UIImagePickerController = {
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.allowsEditing = false
        controller.sourceType = .camera
        controller.cameraCaptureMode = .photo
        controller.mediaTypes = UIImagePickerController.availableMediaTypes(for: .camera)!
        return controller
    }()
    
    lazy var cancelButton: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .cancel,
                               target: self,
                               action: #selector(cancelEditButtonTapped))
    }()
    
    lazy var doneButton: UIBarButtonItem = {
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                         target: self,
                                         action: #selector(doneEditButtonTapped))
        doneButton.isEnabled = model.canSave
        return doneButton
    }()
    
    var model: PatientModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addPhotoButton.titleLabel?.textAlignment = .center
        
        registerTableViewCells()
        setupNavigation()
        setupBirthdateInputs()
        bindData()
        bindImage()
    }
    
    private func registerTableViewCells() {
        tableView.register(UINib.init(nibName: "AddCollectionItemCell", bundle: nil),
                           forCellReuseIdentifier: "AddCollectionItemCell")
        
        tableView.register(UINib.init(nibName: "EditContactPointCell", bundle: nil),
                           forCellReuseIdentifier: "EditContactPointCell")
    }
    
    private func setupNavigation() {
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = doneButton
        model.patientCanSaveChanged = { [weak self] canSave in
            self?.doneButton.isEnabled = canSave
        }
    }
    
    private func setupBirthdateInputs() {
        birthdateTextField.inputView = datePicker
        birthdateTextField.inputAccessoryView = datePickerToolbar
    }
    
    private func bindData() {
        if let image = model.image {
            userImage.image = image
            addPhotoButton.isHidden = true
        } else {
            editPhotoButton.isHidden = true
        }
        
        givenNameTextField.text = model.givenName
        familyNameTextField.text = model.familyName
        
        if let gender = model.gender {
            genderControl.selectedSegmentIndex = gender.rawValue
        }
        
        if let bday = model.dateOfBirth {
            updateBirthdateTextField(bday)
            datePicker.timeZone = TimeZone(abbreviation: "UTC")
            datePicker.date = bday
        }
    }
    
    func bindImage(animated: Bool = false) {
        let duration = animated ? 0.3 : 0.0
        UIView.animate(withDuration: duration) { [unowned self] in
            self.userImage.image = self.model.image
            self.addPhotoButton.isHidden = self.model.image != nil
            self.editPhotoButton.isHidden = self.model.image == nil
        }
    }
}
