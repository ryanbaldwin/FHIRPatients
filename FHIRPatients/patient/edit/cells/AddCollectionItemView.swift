//
//  AddCollectionItemCell.swift
//  FHIRDevDays
//
//  Created by Ryan Baldwin on 2017-10-15.
//  Copyright © 2017 bunnyhug.me. All rights reserved.
//

import UIKit

class AddCollectionItemView: UIView {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    var didTouchUpInside: (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.tintColor = .green
    }
    
    static func loadFromNib() -> AddCollectionItemView {
        return Bundle.main.loadNibNamed("AddCollectionItemView", owner: self, options: nil)?.first as! AddCollectionItemView
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIViewNoIntrinsicMetric, height: label.intrinsicContentSize.height + 16)
    }
    
    @IBAction func viewDidTap(_ sender: Any) {
        didTouchUpInside?()
    }
}
