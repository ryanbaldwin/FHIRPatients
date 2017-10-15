//
//  LabelPickerModel.swift
//  FHIRDevDays
//
//  Created by Ryan Baldwin on 2017-10-15.
//  Copyright © 2017 bunnyhug.me. All rights reserved.
//

import Foundation

struct LabelPickerModel {
    private(set) var labels: [String] = []
    var selectedLabel: String?
    
    init(labels: String...) {
        self.labels = labels
    }
}
