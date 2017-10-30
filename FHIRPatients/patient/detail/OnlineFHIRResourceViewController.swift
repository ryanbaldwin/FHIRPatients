//
//  OnlineFHIRResourceViewController.swift
//  FHIRPatients
//
//  Created by Ryan Baldwin on 2017-10-25.
//  Copyright © 2017 bunnyhug.me. All rights reserved.
//

import UIKit
import WebKit

/// Provides a simple WKWebView which simply renders the remote FHIR Server's JSON for a Patient.
class OnlineFHIRResourceViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    
    /// The URL to load
    var url: URL? {
        didSet {
            guard webView != nil else { return }
            loadURL()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadURL()
    }
    
    /// Loads the URL into the webView.
    private func loadURL() {
        guard url != nil else { return }
        webView.load(URLRequest(url: url!))
    }
    
    /// The Done button which, when tapped, dismisses this view.
    ///
    /// - Parameter sender: The sender whose touchUpInside event we are responding to.
    @IBAction func doneTapped(_ sender: Any) {
        dismiss(animated: true)
    }
}
