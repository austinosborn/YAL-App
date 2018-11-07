//
//  CalendarVC.swift
//  YAL
//
//  Created by Austin on 11/6/18.
//  Copyright © 2018 inTENsity. All rights reserved.
//

import Foundation
import UIKit

struct Event : Codable {
    let title : String?
    let description : String?
    let time : Double?
    let address : String?
}

class CalendarVC : UITableViewController {
    
    var sourceURL : String = "https://pastebin.com/raw/ddADXECj"
    var events : [Event] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        self.navigationItem.title = "Organization Calendar"
        let url = URL(string: sourceURL)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        URLSession.shared.dataTask(with: url!) { data, _, _ in
            guard let data = data else { return }
            let dataString = String(data: data, encoding: .utf8)?.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "\r", with: "")
            do {
                self.events = try JSONDecoder().decode([Event].self, from: data)
            }
            catch let jsonError {
                print("Unable to parse officers: Error \(jsonError.localizedDescription)")
                
            }
        }.resume()
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        
        let event = events[indexPath.row]
        
        cell.textLabel?.text = event.title
        
        var subtitle = ""
        

        if let time = event.time {
            let date = Date(timeIntervalSince1970: Double(time))
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = "EEEE, MMM d, yyyy HH:mm a"
            subtitle.append("Time: \(dateFormatter.string(from: date))\n")
        }
        if let location = event.address {
            subtitle.append("Location: \(location)\n")
        }
        
        if let description = event.description {
            subtitle.append("Description: \(description)\n")
        }
        
        cell.detailTextLabel?.text = subtitle
        cell.detailTextLabel?.numberOfLines = 0
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
}
