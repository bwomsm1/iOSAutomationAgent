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
        let width = Int(UIScreen.main.bounds.width - 200.0 - 200.0)
        
        var offset = 1
        let button1 = CustomButton(frame: CGRect(x: 200, y: 100*offset, width: width, height: 50), backgroundColor: UIColor.red, title: "Red", tag: offset)
        button1.addTarget(self, action: #selector(buttonPressed(button:)), for: .touchUpInside)
        self.view.addSubview(button1)
        
        offset = 2
        let button2 = CustomButton(frame: CGRect(x: 200, y: 100*offset, width: width, height: 50), backgroundColor: UIColor.blue, title: "Blue", tag: offset)
        button2.addTarget(self, action: #selector(buttonPressed(button:)), for: .touchUpInside)
        self.view.addSubview(button2)
        
        offset = 3
        let button3 = CustomButton(frame: CGRect(x: 200, y: 100*offset, width: width, height: 50), backgroundColor: UIColor.yellow, title: "Yellow", tag: offset)
        button3.addTarget(self, action: #selector(buttonPressed(button:)), for: .touchUpInside)
        self.view.addSubview(button3)
        
        offset = 4
        let button4 = CustomButton(frame: CGRect(x: 200, y: 100*offset, width: width, height: 50), backgroundColor: UIColor.green, title: "Green", tag: offset)
        button4.addTarget(self, action: #selector(buttonPressed(button:)), for: .touchUpInside)
        self.view.addSubview(button4)
        
        offset = 5
        let button5 = CustomButton(frame: CGRect(x: 200, y: 100*offset, width: width, height: 50), backgroundColor: UIColor.orange, title: "Orange", tag: offset)
        button5.addTarget(self, action: #selector(buttonPressed(button:)), for: .touchUpInside)
        self.view.addSubview(button5)
    }
    
    private func setupMainViewController() {
        self.view.backgroundColor = UIColor.lightGray
        setupButtons()
    }
}

