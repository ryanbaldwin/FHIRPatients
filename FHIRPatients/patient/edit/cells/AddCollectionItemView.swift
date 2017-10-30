//
//  AddCollectionItemCell.swift
//  FHIRDevDays
//
//  Created by Ryan Baldwin on 2017-10-15.
//  Copyright © 2017 bunnyhug.me. All rights reserved.
//

import UIKit

class AddCollectionItemView: UIView {
    @IBOutlet weak var addButton: UIButton!
    var didTouchUpInside: ((Any) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addButton.setImage(#imageLiteral(resourceName: "plus"), for: .normal)
        addButton.imageView?.tintColor = .green
        addButton.titleEdgeInsets = UIEdgeInsets(top: addButton.titleEdgeInsets.top,
                                                 left: 4,
                                                 bottom: addButton.titleEdgeInsets.bottom,
                                                 right: -4)
        addButton.sizeToFit()
    }
    
    static func loadFromNib() -> AddCollectionItemView {
        return Bundle.main.loadNibNamed("AddCollectionItemView", owner: self, options: nil)?.first as! AddCollectionItemView
    }

    @IBAction func addButtonDidTouchUpInside(_ sender: Any) {
        didTouchUpInside?(self)
    }
}
