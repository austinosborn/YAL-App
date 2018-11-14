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
        //Navigation controller/status bar styling
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        let title = UIImageView(image: UIImage(named: "eagle")?.withRenderingMode(.alwaysTemplate))
        title.tintColor = UIColor(hexString: "#14375F", alpha: 1) ?? UIColor.black
        title.contentMode = .scaleAspectFill
        self.navigationItem.titleView = title
        UIApplication.shared.statusBarStyle = .default
        self.view.backgroundColor = UIColor(hexString: "#14375F", alpha: 1)
        
        
        //Header Icon
        let header = UIImageView(image: UIImage(named: "yal_icon"))
        header.contentMode = .scaleAspectFit
        self.view.addSubview(header)
        header.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(20)
            make.height.equalToSuperview().multipliedBy(0.2)
            make.width.equalToSuperview().multipliedBy(0.4)
        }
        //Stackview holds all menu buttons
        let stack = UIStackView(arrangedSubviews: [
            createButton(name: "Officer Directory", selector: #selector(goToOfficers)),
                createButton(name: "Resources", selector: #selector(goToResources)),
                createButton(name: "Calendar Events", selector: #selector(goToCalendar)),
                createButton(name: "Annoucements", selector: #selector(goToAnnouncements)),
                createButton(name: "Share Our App", selector: #selector(goToShare))
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
        //Layout stackview on screen
        self.view.addSubview(stack)
        stack.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalToSuperview().multipliedBy(0.6)
        }
        
        let banner = UIView()
        //Setup subview of banners first
        let bannerImage = UIImageView(image: UIImage(named: "banner"))
        banner.contentMode = .scaleAspectFill
        banner.addSubview(bannerImage)
        bannerImage.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        let bannerButton = UIButton()
        bannerButton.addTarget(self, action: #selector(goToWebsite), for: .touchUpInside)
        banner.addSubview(bannerButton)
        bannerButton.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        //Now add banner onto screen
        self.view.addSubview(banner)
        banner.snp.makeConstraints { (make) in
            make.bottom.right.left.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.125)
        }
        
        //Banner 
        
        
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
    
    @objc func goToShare() {
        let alert = UIAlertController(title: "Share Link", message: "Coming later. Sharing will be present if this prototype makes its way into the App Store", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true)
    }
    
    @objc func goToWebsite() {
        UIApplication.shared.open(URL(string: "https://www.yaliberty.org")!, options: [:], completionHandler: nil)
    }
    
    func createButton(name: String, selector: Selector) -> UIView {
        let item = UIView()
        item.backgroundColor = UIColor(hexString: "FDC50E", alpha: 1)
        
        let label = UILabel()
        label.text = name
        label.textColor =  UIColor(hexString: "#14375F", alpha: 1)
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

extension UIColor {
    convenience init?(hexString: String, alpha: Float) {
        var localString = hexString
        localString.removeAll { (char) -> Bool in
            let validChars = "0123456789ABCDEFabcdef"
            if (validChars.contains(char)) {
                return false
            }
            else {
                return true
            }
        }
        if localString.count != 6 {
            return nil
        }
        
        guard let red = UInt8(localString.prefix(2), radix: 16) else { return nil }
        let greenIndexStart = localString.index(localString.startIndex, offsetBy: 2)
        let greenIndexEnd = localString.index(localString.endIndex, offsetBy: -2)
        guard let green = UInt8(localString.substring(with: greenIndexStart..<greenIndexEnd), radix: 16) else { return nil }
        guard let blue = UInt8(localString.suffix(2), radix: 16) else { return nil }
        
        let redFloat : Float = (Float(red) / 255)
        let blueFloat : Float = (Float(blue) / 255)
        let greenFloat : Float = (Float(green) / 255)
        
        self.init(red: CGFloat(redFloat), green: CGFloat(greenFloat), blue: CGFloat(blueFloat), alpha: CGFloat(alpha))

    }
}
//

