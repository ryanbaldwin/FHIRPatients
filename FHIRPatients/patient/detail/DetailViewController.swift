//
//  DetailViewController.swift
//  FHIRDevDays
//
//  Created by Ryan Baldwin on 2017-10-04.
//  Copyright © 2017 bunnyhug.me. All rights reserved.
//

import UIKit
import FireKit

/// Provides a detailed view of a Patient.
class DetailViewController: UITableViewController {
    /// Defines the sections for this ViewController's TableView
    ///
    /// - telecoms: A section which lists all the `FireKit.ContactPoint`s for the patient
    /// - count: The total number of sections in the TableView.
    enum Sections: Int {
        
        /// lists all the `FireKit.ContactPoint`s for the patient
        case telecoms,
        
        /// The total number of sections in the TableView.
        count
    }
    
    @IBOutlet weak var headerView: PatientDetailHeaderView!
    @IBOutlet weak var uploadButton: SequenceStateButton!
    @IBOutlet weak var downloadButton: SequenceStateButton!
    @IBOutlet weak var viewPatientButton: UIButton!
    
    /// A button which, when tapped, will put this view into Edit mode.
    lazy var editButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTapped(_:)))
        return button
    }()
    
    /// Gets/sets the model containing the PatientData and functionality for this ViewController
    var model: PatientModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        setupButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bind(model: model)
    }
    
    /// Sets the appropriate visibility of the various buttons on the Detail view.
    private func setupButtons() {
        let canUpload = model.canUploadPatient
        navigationItem.rightBarButtonItem = canUpload ? editButton : nil
        uploadButton.isHidden = !canUpload
        downloadButton.isHidden = !model.canDownloadPatient
        viewPatientButton.isHidden = !model.canDownloadPatient
    }
    
    /// Binds a PatientModel to this ViewController and to it's subcomponents
    ///
    /// - Parameter model: The PatientModel
    private func bind(model: PatientModel) {
        headerView.model = model
        tableView.reloadData()
    }
    
    /// Handles the edit button's touchUpInside event
    ///
    /// - Parameter sender: The UIBarButtonItem whose touchUpInside event is being responded to.
    @objc func editButtonTapped(_ sender: UIBarButtonItem) {
        let vc = EditPatientViewController(nibName: String(describing: EditPatientViewController.self), bundle: nil)
        vc.modalTransitionStyle = .crossDissolve
        vc.model = model
        vc.title = "Edit Patient"
        let navController = UINavigationController(rootViewController: vc)
        navigationController?.present(navController, animated: true)
    }
    
    /// Handles the uploadButton.touchUpInside event
    ///
    /// - Parameter sender: The SequenceStateButton whose touchUpInside event is being responded to.
    @IBAction func uploadButtonTapped(_ sender: SequenceStateButton) {
        guard model.canUploadPatient else { return }
        
        sender.sequenceState = .processing
        do {
            try model.uploadPatient { [weak self] error in
                guard error == nil else {
                    self?.uploadButton.sequenceState = .failure
                    return
                }
                
                self?.uploadButton.sequenceState = .success
            }
        } catch {
            uploadButton.sequenceState = .failure
        }
    }
    
    /// Handles the downloadButton.touchUpInside event
    ///
    /// - Parameter sender: The SequenceStateButton whose touchUpInside event is being responded to.
    @IBAction func downloadButtonTapped(_ sender: SequenceStateButton) {
        guard model.canDownloadPatient else { return }
        
        sender.sequenceState = .processing
        do {
            try model.downloadPatient { [weak self] error in
                guard error == nil else {
                    self?.downloadButton.sequenceState = .failure
                    return
                }
                
                self?.downloadButton.sequenceState = .success
                self?.setupButtons()
                if let model = self?.model { self?.bind(model: model) }
            }
        } catch {
            downloadButton.sequenceState = .failure
        }
    }
    
    /// Prepares the OnlineFHIRResourceViewController to present the FHIR Resource JSON on the FHIR Server
    ///
    /// - Parameters:
    ///   - segue: The segue being executed
    ///   - sender: The sender which triggered the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loadRemoteResourceSegue" {
            guard let reference = model.reference else { return }
            
            let controller = (segue.destination as! UINavigationController).topViewController as! OnlineFHIRResourceViewController
            controller.url = URL(string: "\(FHIR_SERVER_BASE_URL)/\(reference.parts!.fhirType)/\(reference.parts!.id)")
        }
    }
}

