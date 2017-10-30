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
            return model.telecoms.count
        default:
            assert(false, "Unknown section for EditPatientViewController: \(section)")
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch EditPatientViewController.Sections(rawValue: indexPath.section) {
            
        case .some(.telecoms):
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
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        switch EditPatientViewController.Sections(rawValue: section) {
            
        case .some(.telecoms):
            let view = AddCollectionItemView.loadFromNib()
            view.addButton.setTitle("add contact point", for: .normal)
            view.addButton.titleLabel?.sizeToFit()
            view.didTouchUpInside = { [unowned self] _ in
                self.model.telecoms.append(ContactPoint())
                tableView.reloadSections(IndexSet(integer: EditPatientViewController.Sections.telecoms.rawValue),
                                         with: .automatic)
            }
            
            return view
        default:
            assert(false, "Unknown section for EditPatientViewController: \(section)")
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch EditPatientViewController.Sections(rawValue: section) {
            
        case .some(.telecoms):
            return 30
        default:
            assert(false, "Unknown section for EditPatientViewController: \(section)")
        }
    }
    // MARK: Editing the row
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == EditPatientViewController.Sections.telecoms.rawValue
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle,
                            forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            model.telecoms.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

// MARK: supporting actions and such

extension EditPatientViewController {
    func editContactPointCell(for indexPath: IndexPath) -> EditContactPointCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EditContactPointCell",
                                                 for: indexPath) as! EditContactPointCell
        cell.contactPoint = model.telecoms[indexPath.row]
        cell.didTapSystemButton = { [weak self] _ in
            self?.showLabelPickerViewController(for: cell.contactPoint!) }
        return cell
    }
    
    func showLabelPickerViewController(for contactPoint: ContactPoint) {
        let controller = LabelPickerViewController(style: .grouped)
        controller.title = "Label"
        controller.model = LabelPickerModel(labels: "email", "fax", "pager", "phone", "other")
        controller.model!.selectedLabel = contactPoint.system
        
        controller.didSelectLabel = { [weak self] label in
            contactPoint.system = label
            controller.dismiss(animated: true) {
                guard let row = self?.model.telecoms.index(where: {$0.pk == contactPoint.pk}) else {
                    print("Ambiguous row updated. Will reload entire section.")
                    self?.tableView.reloadSections(IndexSet(integer: EditPatientViewController.Sections.telecoms.rawValue),
                                                   with: .none)
                    return
                }
                
                let indexPath = IndexPath(item: row, section: EditPatientViewController.Sections.telecoms.rawValue)
                self?.tableView.reloadRows(at: [indexPath], with: .right)
                (self?.tableView.cellForRow(at: indexPath) as? EditContactPointCell)?.valueField?.becomeFirstResponder()
            }
        }
        
        let navController = UINavigationController(rootViewController: controller)
        navigationController?.present(navController, animated: true)
    }
}
