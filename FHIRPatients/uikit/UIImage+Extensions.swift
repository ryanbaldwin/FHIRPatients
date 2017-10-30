//
//  UIImage+Extensions.swift
//  FHIRPatients
//
//  Created by Ryan Baldwin on 2017-10-29.
//  Copyright © 2017 bunnyhug.me. All rights reserved.
//

import UIKit

extension UIImage {
    
    /// Attempts to create a new UIImage for a Base64 encoded string.
    /// returns `nil` if the initializer fails.
    convenience init?(base64EncodedString string: String) {
        guard let data = Data(base64Encoded: string, options: .ignoreUnknownCharacters) else {
                return nil
        }
        
        self.init(data: data)
    }
}
