//
//  ViewController.swift
//  YAL
//
//  Created by Austin on 11/6/18.
//  Copyright © 2018 inTENsity. All rights reserved.
//
import Foundation
import UIKit
import SnapKit


class MainMenu: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.0784, green: 0.21568, blue: 0.37254, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        self.navigationItem.title = "Main Menu"
        UIApplication.shared.statusBarStyle = .lightContent
        self.view.backgroundColor = UIColor(red: 0.0784, green: 0.21568, blue: 0.37254, alpha: 1)
        
        let stack = UIStackView(arrangedSubviews: [
            createButton(name: "Officer Directory", selector: #selector(goToOfficers)),
                createButton(name: "Resources", selector: #selector(goToResources)),
                createButton(name: "Calendar Events", selector: #selector(goToCalendar)),
                createButton(name: "Annoucements", selector: #selector(goToAnnouncements))
        ])
        for button in stack.subviews {
            button.snp.makeConstraints { (make) in
                make.width.equalToSuperview()
            }
        }
        stack.alignment = .center
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 12
        
        self.view.addSubview(stack)
        stack.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalToSuperview().multipliedBy(0.65)
        }
    }
    
    @objc func goToOfficers() {
        self.navigationController?.pushViewController(OfficersVC(), animated: true)
    }
    
    @objc func goToResources() {
        self.navigationController?.pushViewController(ResourcesVC(), animated: true)
    }
    
    @objc func goToCalendar() {
        self.navigationController?.pushViewController(CalendarVC(), animated: true)
    }
    
    @objc func goToAnnouncements() {
        self.navigationController?.pushViewController(AnnouncementsVC(), animated: true)
    }
    
    func createButton(name: String, selector: Selector) -> UIView {
        let item = UIView()
        item.backgroundColor = UIColor.white
        
        let label = UILabel()
        label.text = name
        label.textColor =  UIColor(red: 0.0784, green: 0.21568, blue: 0.37254, alpha: 1)
        label.contentMode = .center
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        let button = UIButton()
        button.addTarget(self, action: selector, for: .touchUpInside)
        item.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.edges.centerX.centerY.equalToSuperview()
        }
        item.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        item.layer.cornerRadius = 10
        return item
    }


}
//

