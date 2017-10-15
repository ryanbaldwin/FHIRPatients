//
//  LabelPickerViewController.swift
//  FHIRDevDays
//
//  Created by Ryan Baldwin on 2017-10-15.
//  Copyright © 2017 bunnyhug.me. All rights reserved.
//

import UIKit

class LabelPickerViewController: UITableViewController {
    
    var model: LabelPickerModel? {
        didSet {
            tableView.reloadData()
        }
    }
    
    var didSelectLabel: ((String) -> ())?
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.labels.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = model else {
            assert(false, "LabelPickerViewController attempting to load nil LabelPickerModel.")
        }
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "LabelPickerCell")
        cell.textLabel?.text = model.labels[indexPath.row]
        
        if model.labels[indexPath.row] == model.selectedLabel {
            cell.accessoryType = .checkmark
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let model = self.model else {
            assert(false, "LabelPickerViewController selected row while LabelPickerModel was nil.")
        }
        
        didSelectLabel?(model.labels[indexPath.row])
    }
}
