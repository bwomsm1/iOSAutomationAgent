//
//  CustomButton.swift
//  ExampleApp
//
//  Created by Boaz Warshawsky on 04/09/2017.
//  Copyright © 2017 Boaz Warshawsky. All rights reserved.
//

import UIKit
import os.log


class CustomButton: UIButton, AutomationElementView {
    
    init(frame: CGRect, backgroundColor: UIColor, title: String, tag: Int) {
        super.init(frame: frame)
        self.setupButton(backgroundColor: backgroundColor, title: title, tag: tag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButton(backgroundColor: UIColor, title: String, tag: Int) {
        self.tag = tag
        self.backgroundColor = backgroundColor
        self.setTitle(title, for: .normal)
        self.setTitleColor(UIColor.black, for: .normal)
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 3.0
    }
    
    public func enumerateElements() -> Bool {
        
        let stream: DataStream = EnumerateElements.stream()
        stream.beginDictionary(nil)
        
        let basePoint = self.superview?.convert(self.frame.origin, to: nil)
        stream.add(String(describing: CustomButton.self), key: "element_type")
        stream.add(String(describing: self.currentTitle), key: "title")
        stream.add(Float((basePoint?.x)!), key: "x_pos")
        stream.add(Float((basePoint?.y)!), key: "y_pos")
        
        stream.end()
        return true
    }
}
