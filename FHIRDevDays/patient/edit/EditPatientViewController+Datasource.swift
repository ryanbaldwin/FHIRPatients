//
//  EditPatientViewController+Datasource.swift
//  FHIRDevDays
//
//  Created by Ryan Baldwin on 2017-10-14.
//  Copyright © 2017 bunnyhug.me. All rights reserved.
//

import UIKit

extension EditPatientViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return EditPatientViewController.Sections.count.rawValue
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch EditPatientViewController.Sections(rawValue: section) {
        case .some(.telecoms):
            return model.telecoms.count + 1 // plus 1 for the "add telecom" cell
        default:
            assert(false, "Unknown section for EditPatientViewController: \(section)")
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch EditPatientViewController.Sections(rawValue: indexPath.section) {
        case .some(.telecoms):
            guard indexPath.row < model.telecoms.count else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddCollectionItemCell",
                                                         for: indexPath) as! AddCollectionItemCell
                cell.label.text = "add telecom"
                return cell
            }

            let cell = tableView.dequeueReusableCell(withIdentifier: "TelecomCell",
                                                     for: indexPath) as! TelecomCell
            cell.contactPoint = model.telecoms[indexPath.row]
            return cell

        default:
            assert(false, "Unknown section for EditPatientViewController: \(indexPath.section)")
        }
    }
}
