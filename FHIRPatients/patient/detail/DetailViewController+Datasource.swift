//
//  DetailViewController+Datasource.swift
//  FHIRDevDays
//
//  Created by Ryan Baldwin on 2017-10-12.
//  Copyright © 2017 bunnyhug.me. All rights reserved.
//

import UIKit

extension DetailViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return DetailViewController.Sections.count.rawValue
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch DetailViewController.Sections(rawValue: section) {
        case .some(.telecoms):
            return model?.telecoms.count ?? 0
        default:
            assert(false, "UICollectionView is asking for more sections than we know about: \(section)")
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch DetailViewController.Sections(rawValue: section) {
        case .some(.telecoms):
            return "Contact Points"
        default:
            assert(false, "Well, this was an unexpected section.")
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch DetailViewController.Sections(rawValue: indexPath.section) {
        case .some(.telecoms):
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "ContactPointCell")
            let contactPoint = model?.telecoms[indexPath.row]
            cell.textLabel?.text = contactPoint?.system
            cell.detailTextLabel?.text = contactPoint?.value
            return cell
        default:
            assert(false, "UICollectionView is asking for a cell in an unknown section: \(indexPath.section)")
        }
    }
}
