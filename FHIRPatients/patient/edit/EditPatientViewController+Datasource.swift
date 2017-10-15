//
//  EditPatientViewController+Datasource.swift
//  FHIRDevDays
//
//  Created by Ryan Baldwin on 2017-10-14.
//  Copyright © 2017 bunnyhug.me. All rights reserved.
//

import UIKit
import FireKit

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

            return editContactPointCell(for: indexPath)

        default:
            assert(false, "Unknown section for EditPatientViewController: \(indexPath.section)")
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch EditPatientViewController.Sections(rawValue: indexPath.section) {
        case .some(.telecoms):
            model.telecoms.append(ContactPoint())
            tableView.reloadSections(IndexSet(integer: EditPatientViewController.Sections.telecoms.rawValue),
                                     with: .automatic)
        default:
            assert(false, "Unknown section for EditPatientViewController: \(indexPath.section)")
        }
    }
    
    func editContactPointCell(for indexPath: IndexPath) -> EditContactPointCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EditContactPointCell",
                                                 for: indexPath) as! EditContactPointCell
        cell.contactPoint = model.telecoms[indexPath.row]
        cell.didTapSystemButton = { [weak self] _ in self?.showLabelPickerViewController(for: indexPath) }
        return cell
    }
    
    func showLabelPickerViewController(for indexPath: IndexPath) {
        let controller = LabelPickerViewController(style: .grouped)
        controller.title = "Label"
        controller.model = LabelPickerModel(labels: "email", "fax", "pager", "phone", "other")
        
        controller.didSelectLabel = { [weak self] label in
            self?.model.telecoms[indexPath.row].system = label
            controller.dismiss(animated: true) {
                self?.tableView.reloadRows(at: [indexPath], with: .none)
            }
        }
        
        let navController = UINavigationController(rootViewController: controller)
        navigationController?.present(navController, animated: true)
    }
}