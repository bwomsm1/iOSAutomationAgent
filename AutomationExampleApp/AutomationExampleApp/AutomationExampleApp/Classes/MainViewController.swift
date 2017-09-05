//
//  MainViewController.swift
//  ExampleApp
//
//  Created by Boaz Warshawsky on 02/09/2017.
//  Copyright © 2017 Boaz Warshawsky. All rights reserved.
//

import UIKit


class MainViewController: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setupMainViewController()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
    }

    public func buttonPressed(button: UIButton) {
        self.view.backgroundColor = button.backgroundColor
    }
    
    private func setupButtons() {
        var offset = 1
        let button1 = CustomButton(frame: CGRect(x: 100, y: 100*offset, width: 100, height: 50), backgroundColor: UIColor.red, title: "red", tag: offset)
        button1.addTarget(self, action: #selector(buttonPressed(button:)), for: .touchUpInside)
        self.view.addSubview(button1)
        
        offset = 2
        let button2 = CustomButton(frame: CGRect(x: 100, y: 100*offset, width: 100, height: 50), backgroundColor: UIColor.blue, title: "blue", tag: offset)
        button2.addTarget(self, action: #selector(buttonPressed(button:)), for: .touchUpInside)
        self.view.addSubview(button2)
        
        offset = 3
        let button3 = CustomButton(frame: CGRect(x: 100, y: 100*offset, width: 100, height: 50), backgroundColor: UIColor.yellow, title: "yellow", tag: offset)
        button3.addTarget(self, action: #selector(buttonPressed(button:)), for: .touchUpInside)
        self.view.addSubview(button3)
        
        offset = 4
        let button4 = CustomButton(frame: CGRect(x: 100, y: 100*4, width: 100, height: 50), backgroundColor: UIColor.green, title: "red", tag: offset)
        button4.addTarget(self, action: #selector(buttonPressed(button:)), for: .touchUpInside)
        self.view.addSubview(button4)
    }
    
    private func setupMainViewController() {
        self.view.backgroundColor = UIColor.lightGray
        setupButtons()
    }
}

