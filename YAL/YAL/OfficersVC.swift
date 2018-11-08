//
//  OfficersVC.swift
//  YAL
//
//  Created by Austin on 11/6/18.
//  Copyright © 2018 inTENsity. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import MessageUI
import Messages

struct Officer : Codable {
    let name : String?
    let email : String?
    let phone : Int?
    let position : String?
    let image : String?
}

class OfficersVC : UITableViewController, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate {
    var sourceURL : String = "https://pastebin.com/raw/XPtvDijz"
    var officers : [Officer] = []
    
    
    override func viewDidLoad() {
        self.navigationItem.title = "Officer Directory"
        let url = URL(string: sourceURL)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        URLSession.shared.dataTask(with: url!) { data, _, _ in
            guard let data = data else { return }
            do {
                self.officers = try JSONDecoder().decode([Officer].self, from: data)
            }
            catch let jsonError {
                print("Unable to parse officers: Error \(jsonError.localizedDescription)")
                
            }
            DispatchQueue.main.sync {
                self.tableView.reloadData()
            }
        }.resume()
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        
        let officer = officers[indexPath.row]
        cell.textLabel?.text = officer.name
        var subtitle = ""
        if let position = officer.position {
            subtitle.append("Position: \(position)\n")
        }
        if let email = officer.email {
            subtitle.append("Email: \(email)\n")
        }
        if let phone = officer.phone {
            subtitle.append("Phone: \(phone)\n")
        }
        cell.detailTextLabel?.text = subtitle
        cell.detailTextLabel?.numberOfLines = 0
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let actionSheet = UIAlertController(title: "Please Select an Action", message: "", preferredStyle: .actionSheet)
        if let phone = officers[indexPath.row].phone {
            let call = UIAlertAction(title: "Call: \(phone)", style: .default, handler: { _ in
                UIApplication.shared.open(URL(string: "tel://\(phone)")!, options: [:], completionHandler: nil)
            })
            let text = UIAlertAction(title: "Text: \(phone)", style: .default, handler: { _ in
                if (MFMessageComposeViewController.canSendText()) {
                    let controller = MFMessageComposeViewController()
                    controller.recipients = [String(phone)]
                    controller.messageComposeDelegate = self as! MFMessageComposeViewControllerDelegate
                    controller.body = " - Sent from the YAL App"
                    self.present(controller, animated: true, completion: nil)
                }
            })
            actionSheet.addAction(call)
            actionSheet.addAction(text)
        }
        if let email = officers[indexPath.row].email {
            let mail = UIAlertAction(title: "Email: \(email)", style: .default, handler: { _ in
                if (MFMailComposeViewController.canSendMail()) {
                    let controller = MFMailComposeViewController()
                    controller.setToRecipients([email])
                    controller.mailComposeDelegate = self as! MFMailComposeViewControllerDelegate
                    controller.setSubject("YAL App Contact")
                    controller.setMessageBody("- Sent from the YAL App", isHTML: false)
                    self.present(controller, animated: true, completion: nil)
                }
            })
            actionSheet.addAction(mail)
        }
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in actionSheet.dismiss(animated: true, completion: nil)
            
        }))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return officers.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}
