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

struct Officer : Codable {
    let name : String?
    let email : String?
    let phone : Int?
    let position : String?
    let image : String?
}

class OfficersVC : UITableViewController {
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
            let dataString = String(data: data, encoding: .utf8)?.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "\r", with: "")
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return officers.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
}
