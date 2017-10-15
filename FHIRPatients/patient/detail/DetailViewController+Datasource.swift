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
        guard let currentSection = DetailViewController.Sections(rawValue: section) else {
            assert(false, "Unknown section: \(section)")
        }
        
        switch currentSection {
        case .telecoms:
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
    
//    override func collectionView(_ collectionView: UICollectionView,
//                                 viewForSupplementaryElementOfKind kind: String,
//                                 at indexPath: IndexPath) -> UICollectionReusableView {
//        switch kind {
//        case UICollectionElementKindSectionHeader:
//            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
//                                                                             withReuseIdentifier: "PatientDetailHeaderView",
//                                                                             for: indexPath) as! PatientDetailHeaderView
//            headerView.model = model
//            return headerView
//        default:
//            assert(false, "Unexpected element kind")//        }
//    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let currentSection = DetailViewController.Sections(rawValue: indexPath.section) else {
            assert(false, "Unknown section: \(indexPath.section)")
        }
        
        switch currentSection {
        case .telecoms:
            let cell = UITableViewCell(style: .value2, reuseIdentifier: "ContactPointCell")
            let contactPoint = model?.telecoms[indexPath.row]
            cell.textLabel?.text = contactPoint?.system
            cell.detailTextLabel?.text = contactPoint?.value
            return cell
        default:
            assert(false, "UICollectionView is asking for a cell in an unknown section: \(indexPath.section)")
        }
    }
}
