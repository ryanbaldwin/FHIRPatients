//
//  DetailViewController+Layout.swift
//  FHIRDevDays
//
//  Created by Ryan Baldwin on 2017-10-12.
//  Copyright © 2017 bunnyhug.me. All rights reserved.
//

import UIKit

extension DetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let section = DetailViewController.Sections(rawValue: indexPath.section) else {
            assert(false, "Unknown section for flow layout: \(indexPath)")
        }
        
        switch section {
        case .contactPoints:
            guard let contactPoint = model?.telecoms[indexPath.row] else {
                return CGSize.zero
            }
            
            let width = view.frame.width - sectionInsets.left - sectionInsets.right
            let systemHeight: CGFloat = contactPoint.system != nil ? 18 : 0
            let valueHeight: CGFloat = contactPoint.system != nil ? 20.5 : 0
            
            return CGSize(width: width, height: systemHeight + valueHeight + 4)
        default:
            assert(false, "unknown section for flor layout \(indexPath)")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard let currentSection = DetailViewController.Sections(rawValue: section) else {
            assert(false, "Unknown section for flow layout: \(section)")
        }
        
        switch currentSection {
        case .contactPoints:
            let spacing: CGFloat = 4
            let nameHeight: CGFloat = 41
            let birthHeight: CGFloat = model?.dateOfBirth != nil || model?.gender != nil ? 18 : 0
            return CGSize(width: collectionView.frame.width, height: spacing + nameHeight + birthHeight)
        default:
            assert(false, "unknown section for flor layout \(section)")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
