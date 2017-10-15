//
//  DetailViewController+Datasource.swift
//  FHIRDevDays
//
//  Created by Ryan Baldwin on 2017-10-12.
//  Copyright © 2017 bunnyhug.me. All rights reserved.
//

import UIKit

extension DetailViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return DetailViewController.Sections.count.rawValue
    }
    
    //2
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        guard let currentSection = DetailViewController.Sections(rawValue: section) else {
            assert(false, "Unknown section: \(section)")
        }
        
        switch currentSection {
        case .contactPoints:
            return model?.telecoms.count ?? 0
        default:
            assert(false, "UICollectionView is asking for more sections than we know about: \(section)")
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: "PatientDetailHeaderView",
                                                                             for: indexPath) as! PatientDetailHeaderView
            headerView.model = model
            return headerView
        default:
            assert(false, "Unexpected element kind")
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let currentSection = DetailViewController.Sections(rawValue: indexPath.section) else {
            assert(false, "Unknown section: \(indexPath.section)")
        }
        
        switch currentSection {
        case .contactPoints:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PatientTelecomCell",
                                                          for: indexPath) as! PatientTelecomCell
            cell.contactPoint = model?.telecoms[indexPath.row]
            return cell
        default:
            assert(false, "UICollectionView is asking for a cell in an unknown section: \(indexPath.section)")
        }
    }
}
