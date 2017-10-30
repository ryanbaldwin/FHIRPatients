//
//  UnderlinedTextField.swift
//  FHIRDevDays
//
//  Created by Ryan Baldwin on 2017-10-08.
//  Copyright © 2017 bunnyhug.me. All rights reserved.
//

import UIKit

/// Creates a typical UITextField, but with a thin line along its bottom edge.
class UnderlinedTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        borderStyle = .none
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            print("WARNING: Need graphics context to draw bottom edge.")
            return
        }
        
        drawBottomEdge(in: rect, context: context)
    }
    
    private func drawBottomEdge(in rect: CGRect, context: CGContext) {
        context.setStrokeColor(UIColor.lightGray.cgColor)
        context.setLineWidth(1.0)
        context.move(to: CGPoint(x: 0, y: rect.height))
        context.addLine(to: CGPoint(x: rect.width, y: rect.height))
        context.strokePath()
    }
}
