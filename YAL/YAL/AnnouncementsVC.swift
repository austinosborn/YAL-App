//
//  AnnouncementsVC.swift
//  YAL
//
//  Created by Austin on 11/6/18.
//  Copyright © 2018 inTENsity. All rights reserved.
//

import Foundation
import UIKit

struct Annoucement : Codable {
    let title : String?
    let description : String?
    let time : Double?
}
class AnnouncementsVC : UITableViewController {
    
    var sourceURL : String = "https://pastebin.com/raw/H6DZuxGt"
    var annoucements : [Annoucement] = []
    
    
    override func viewDidLoad() {
        self.navigationItem.title = "Annoucements"
        let url = URL(string: sourceURL)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        URLSession.shared.dataTask(with: url!) { data, _, _ in
            guard let data = data else { return }
            let dataString = String(data: data, encoding: .utf8)?.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "\r", with: "")
            do {
                self.annoucements = try JSONDecoder().decode([Annoucement].self, from: data)
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
        
        let annoucement = annoucements[indexPath.row]
        
        cell.textLabel?.text = annoucement.title
        
        var subtitle = ""
        if let description = annoucement.description {
            subtitle.append("Description: \(description)\n")
        }
        if let time = annoucement.time {
            let date = Date(timeIntervalSince1970: Double(time))
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = "EEEE, MMM d, yyyy HH:mm a"
            subtitle.append("Time Sent: \(dateFormatter.string(from: date))\n")
        }
        
        cell.detailTextLabel?.text = subtitle
        cell.detailTextLabel?.numberOfLines = 0
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return annoucements.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
}
