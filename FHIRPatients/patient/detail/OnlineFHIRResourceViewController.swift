//
//  OnlineFHIRResourceViewController.swift
//  FHIRPatients
//
//  Created by Ryan Baldwin on 2017-10-25.
//  Copyright © 2017 bunnyhug.me. All rights reserved.
//

import UIKit
import WebKit

class OnlineFHIRResourceViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    
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
    
    private func loadURL() {
        guard url != nil else { return }
        webView.load(URLRequest(url: url!))
    }
    
    @IBAction func doneTapped(_ sender: Any) {
        dismiss(animated: true)
    }
}
