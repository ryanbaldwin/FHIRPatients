//
//  DetailViewController.swift
//  FHIRDevDays
//
//  Created by Ryan Baldwin on 2017-10-04.
//  Copyright © 2017 bunnyhug.me. All rights reserved.
//

import UIKit
import FireKit

class DetailViewController: UITableViewController {
    enum Sections: Int {
        case telecoms, count
    }
    
    @IBOutlet weak var headerView: PatientDetailHeaderView!
    @IBOutlet weak var uploadButton: SequenceStateButton!
    @IBOutlet weak var downloadButton: SequenceStateButton!
    @IBOutlet weak var viewPatientButton: UIButton!
    
    lazy var editButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTapped(_:)))
        return button
    }()
    
    var model: PatientModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        
        setupButtons()
    }
    
    private func setupButtons() {
        let canUpload = model.canUploadPatient
        navigationItem.rightBarButtonItem = canUpload ? editButton : nil
        uploadButton.isHidden = !canUpload
        downloadButton.isHidden = !model.canDownloadPatient
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        headerView.model = model
        tableView.reloadData()
    }
    
    @objc func editButtonTapped(_ sender: UIBarButtonItem) {
        let vc = EditPatientViewController(nibName: String(describing: EditPatientViewController.self), bundle: nil)
        vc.modalTransitionStyle = .crossDissolve
        vc.model = model
        vc.title = "Edit Patient"
        let navController = UINavigationController(rootViewController: vc)
        navigationController?.present(navController, animated: true)
    }
    
    @IBAction func uploadButtonTapped(_ sender: SequenceStateButton) {
        guard model.canUploadPatient else { return }
        
        sender.sequenceState = .processing
        model.uploadPatient { [weak self] error in
            guard error == nil else {
                self?.uploadButton.sequenceState = .failure
                return
            }
            
            self?.uploadButton.sequenceState = .success
            self?.viewPatientButton.isHidden = false
        }
    }
    
    @IBAction func downloadButtonTapped(_ sender: SequenceStateButton) {
        guard model.canDownloadPatient else { return }
        
        sender.sequenceState = .processing
        model.downloadPatient { [weak self] error in
            guard error == nil else {
                self?.downloadButton.sequenceState = .failure
                return
            }
            
            self?.downloadButton.sequenceState = .success
            self?.setupButtons()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loadRemoteResourceSegue" {
            guard let reference = model.reference else { return }
            
            let controller = (segue.destination as! UINavigationController).topViewController as! OnlineFHIRResourceViewController
            controller.url = URL(string: "\(FHIR_SERVER_BASE_URL)/\(reference.parts!.fhirType)/\(reference.parts!.id)")
        }
    }
}

