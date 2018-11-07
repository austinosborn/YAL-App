//
//  ResourcesVC.swift
//  YAL
//
//  Created by Austin on 11/6/18.
//  Copyright © 2018 inTENsity. All rights reserved.
//

import Foundation
import UIKit

struct Resource : Codable {
    var title : String = ""
    var link : String = ""
}

class ResourcesVC : UITableViewController {
    
    var sourceURL : String = "https://pastebin.com/raw/GSufdRt9#"
    var resources : [Resource] = []
    
    
    override func viewDidLoad() {
        self.navigationItem.title = "Resources"
        let url = URL(string: sourceURL)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        URLSession.shared.dataTask(with: url!) { data, _, _ in
            guard let data = data else { return }
            let dataString = String(data: data, encoding: .utf8)?.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "\r", with: "")
            do {
                self.resources = try JSONDecoder().decode([Resource].self, from: data)
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
        
        let resource = resources[indexPath.row]
        cell.textLabel?.text = resource.title
        cell.detailTextLabel?.text = resource.link
        cell.detailTextLabel?.numberOfLines = 0
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let url = URL(string: resources[indexPath.row].link) else { return }
        UIApplication.shared.open(url)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resources.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
}
